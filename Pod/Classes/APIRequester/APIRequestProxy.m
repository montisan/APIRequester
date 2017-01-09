//
//  APIRequestProxy.m
//  fcuhConsumerArc
//
//  Created by Peter on 15/11/24.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "APIRequestProxy.h"
#import "AFNetworking.h"
#import "APIRequestServiceManager.h"

@interface APIRequestProxy()

@property (nonatomic, strong) NSMutableDictionary *requestOperations;
@property (nonatomic, strong) NSMutableDictionary *serviceIdentifiers;
@property (nonatomic, assign) NSUInteger currentRequestId;

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@end

@implementation APIRequestProxy

SINGLETON_FUN_IMP(Proxy)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _requestOperations = [NSMutableDictionary dictionary];
        _serviceIdentifiers = [NSMutableDictionary dictionary];
        _requestManager = [AFHTTPRequestOperationManager manager];
        _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _currentRequestId = 0;
    }
    
    return self;
}

- (BOOL)isReachable
{
    BOOL isReachable = NO;
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown)
    {
        isReachable = YES;
    }
    else
    {
        isReachable = [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
    
    return isReachable;
}

- (NSUInteger)doGetRequestWithParams:(NSDictionary *)params
                   serviceIdentifier:(NSString *)identifier
                          actionName:(NSString *)actionName
                          completion:(RequestCompletion)completion
{
    
    id<APIRequestService> service = [[APIRequestServiceManager sharedManager] serviceWithIdentifier:identifier];
    NSMutableURLRequest *request = [service.requestGenerator generateGETRequestWithParams:params actionName:actionName];
    
    NSUInteger requestId = [self request:request completion:completion];
    if (identifier.length > 0 && requestId > 0)
    {
        [_serviceIdentifiers setObject:identifier forKey:@(requestId)];
    }
   
    return requestId;
    
}

- (NSUInteger)doPostRequestWithParams:(NSDictionary *)params
                  serviceIdentifier:(NSString *)identifier
                         actionName:(NSString *)actionName
                         completion:(RequestCompletion)completion
{
    id<APIRequestService> service = [[APIRequestServiceManager sharedManager] serviceWithIdentifier:identifier];
     NSMutableURLRequest *request = [service.requestGenerator generatePOSTRequestWithParams:params actionName:actionName];
    if (service.dataProcessor)
    {
        request.HTTPBody = [service.dataProcessor dataAfterProcessParamData:request.HTTPBody];
    }
    
    NSUInteger requestId = [self request:request completion:completion];
    if (identifier.length > 0 && requestId > 0)
    {
        [_serviceIdentifiers setObject:identifier forKey:@(requestId)];
    }
    
    return requestId;
}

- (NSUInteger)request:(NSURLRequest *)request completion:(RequestCompletion)completion
{
    if (request == nil)
    {
        return 0;
    }
    
    NSUInteger requestId = [self generateRequestId];
    
    AFHTTPRequestOperation *operation = [self.requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self requestCompletion:completion requestId:requestId operation:operation error:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self requestCompletion:completion requestId:requestId operation:operation error:error];
    }];
    
    [_requestOperations setObject:operation forKey:@(requestId)];
    [[self.requestManager operationQueue] addOperation:operation];
    
    return requestId;
}

- (void)requestCompletion:(RequestCompletion)completion
                requestId:(NSUInteger)requestId
                operation:(AFHTTPRequestOperation *)operation
                    error:(NSError *)error
{
    AFHTTPRequestOperation *op = [_requestOperations objectForKey:@(requestId)];
    if (op == nil)
    {
        return;
    }
    
    APIRequestResponse *response = [self responseWithOperation:operation error:error requestId:requestId];
    
    completion(response);
    
    [_requestOperations removeObjectForKey:@(requestId)];
    [_serviceIdentifiers removeObjectForKey:@(requestId)];
}


- (APIRequestResponse *)responseWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error requestId:(NSUInteger)requestId
{
    
    NSString *identifier = [_serviceIdentifiers objectForKey:@(requestId)];
    id responseData = operation.responseData;
    if (identifier.length > 0)
    {
        id<APIRequestService> service = [[APIRequestServiceManager sharedManager] serviceWithIdentifier:identifier];
        
        if (service.dataProcessor)
        {
            responseData = [service.dataProcessor dataAfterProcessResponseData:operation.responseData];
        }
    }
    
    APIRequestResponse *response = [[APIRequestResponse alloc] initWithRequestId:requestId responseData:responseData request:operation.request error:error];
    
    return response;
}

- (void)cancelRequestWithRequestId:(NSUInteger)requestId
{
    AFHTTPRequestOperation *operation = [_requestOperations objectForKey:@(requestId)];
    [operation cancel];
    
    [_requestOperations removeObjectForKey:@(requestId)];
    [_serviceIdentifiers removeObjectForKey:@(requestId)];
}

- (BOOL)isLoadingWithRequestId:(NSUInteger)requestId
{
    AFHTTPRequestOperation *operation = [_requestOperations objectForKey:@(requestId)];
    
    return operation != nil;
}

- (NSUInteger)generateRequestId
{
    if (_currentRequestId == NSUIntegerMax)
    {
        _currentRequestId = 1;
    }
    else
    {
        _currentRequestId += 1;
    }
    
    return _currentRequestId;
}

@end
