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

@property (nonatomic, strong) NSMutableDictionary *requestTasks;
@property (nonatomic, strong) NSMutableDictionary *serviceIdentifiers;
@property (nonatomic, assign) NSUInteger currentRequestId;

@property (nonatomic, strong) AFHTTPSessionManager *requestManager;

@end

@implementation APIRequestProxy

SINGLETON_FUN_IMP(Proxy)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _requestTasks = [NSMutableDictionary dictionary];
        _serviceIdentifiers = [NSMutableDictionary dictionary];
        _requestManager = [AFHTTPSessionManager manager];
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
    
    NSURLSessionDataTask *task = [self.requestManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [self requestCompletion:completion requestId:requestId task:task responseObject:responseObject error:error];
        
    }];
    
    [task resume];
    
    [_requestTasks setObject:task forKey:@(requestId)];
    
    return requestId;
}

- (void)requestCompletion:(RequestCompletion)completion
                requestId:(NSUInteger)requestId
                task:(NSURLSessionDataTask *)task
           responseObject:(id)responseObject
                    error:(NSError *)error
{
    NSURLSessionDataTask *op = [_requestTasks objectForKey:@(requestId)];
    if (op == nil)
    {
        return;
    }
    
    APIRequestResponse *response = [self responseWithTask:task responseObject:responseObject error:error requestId:requestId];
    
    completion(response);
    
    [_requestTasks removeObjectForKey:@(requestId)];
    [_serviceIdentifiers removeObjectForKey:@(requestId)];
}


- (APIRequestResponse *)responseWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error requestId:(NSUInteger)requestId
{
    
    NSString *identifier = [_serviceIdentifiers objectForKey:@(requestId)];
    id responseData = task.response;
    if (identifier.length > 0)
    {
        id<APIRequestService> service = [[APIRequestServiceManager sharedManager] serviceWithIdentifier:identifier];
        
        if (service.dataProcessor)
        {
            responseData = [service.dataProcessor dataAfterProcessResponseData:responseObject];
        }
    }
    
    APIRequestResponse *response = [[APIRequestResponse alloc] initWithRequestId:requestId responseData:responseData request:task.originalRequest error:error];
    
    return response;
}

- (void)cancelRequestWithRequestId:(NSUInteger)requestId
{
    NSURLSessionDataTask *task = [_requestTasks objectForKey:@(requestId)];
    [task cancel];
    
    [_requestTasks removeObjectForKey:@(requestId)];
    [_serviceIdentifiers removeObjectForKey:@(requestId)];
}

- (BOOL)isLoadingWithRequestId:(NSUInteger)requestId
{
    NSURLSessionDataTask *task = [_requestTasks objectForKey:@(requestId)];
    
    return task != nil;
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
