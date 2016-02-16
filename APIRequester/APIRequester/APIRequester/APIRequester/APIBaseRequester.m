//
//  APIBaseRequester.m
//  fcuhConsumerArc
//
//  Created by Peter on 15/11/24.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "APIBaseRequester.h"
#import "APIRequestProxy.h"

#define APIReqProxy(REQ_METHOD, REQ_ID) \
{   \
    REQ_ID = [[APIRequestProxy sharedProxy] do##REQ_METHOD##RequestWithParams:params serviceIdentifier:self.child.serviceIdentifier actionName:self.child.actionName completion:^(APIRequestResponse *response) { \
        [self requestCompletionWithResponse:response]; \
    }];\
}

@interface APIBaseRequester()

@property (nonatomic, strong, readwrite)        id fetchedRawData;

@property (nonatomic, assign, readwrite)        APIRequesterErrorType errorType;
@property (nonatomic, copy, readwrite)          NSString *errorMsg;

@property (nonatomic, strong)                   NSMutableArray *requestIdList;

@property (nonatomic, assign, readwrite)         NSUInteger requestId;

@end

@implementation APIBaseRequester

- (void)dealloc
{
    [self cancelRequest];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _errorType = APIRequesterErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(APIRequester)])
        {
            self.child = (id <APIRequester>) self;
        }
    }
    
    return self;
}

#pragma mark - Public functions
- (NSUInteger)requestData
{
    [self cancelRequest];
    
    NSDictionary *params = [self.paramSource paramsForAPIRequester:self];
    _requestId = [self requestDataWithParams:params];
    
    return _requestId;
}

- (void)cancelRequest
{
    [[APIRequestProxy sharedProxy] cancelRequestWithRequestId:_requestId];
    
    _errorType  = APIRequesterErrorTypeDefault;
    _errorMsg   = nil;
}

- (id)transformDataWithReformer:(id<APIRequesterDataReformer>)reformer
{
    return [reformer apiRequester:self reformData:self.fetchedRawData];
}

- (BOOL)isLoading
{
    return [[APIRequestProxy sharedProxy] isLoadingWithRequestId:_requestId];
}

- (BOOL)isReachable
{
    return [[APIRequestProxy sharedProxy] isReachable];
}

#pragma mark - Private functions

- (NSUInteger)requestDataWithParams:(NSDictionary *)params
{
    NSUInteger requestId = 0;
    
    if ([self.validator apiRequester:self isValidWithParamData:params])
    {
        if ([self isReachable])
        {
            switch (self.child.requestType)
            {
                case APIRequesterRequestTypeGet:
                    APIReqProxy(Get,requestId);
                    break;
                    
                case APIRequesterRequestTypePost:
                    APIReqProxy(Post,requestId);
                    break;
            }
        }
        else
        {
            [self requestCompletionWithErrorType:APIRequesterErrorTypeDisconnect errorMsg:nil];
        }
    }
    else
    {
        [self requestCompletionWithErrorType:APIRequesterErrorTypeParamInvalid errorMsg:nil];
    }
    
    return requestId;
}

- (void)requestCompletionWithResponse:(APIRequestResponse *)response
{
    if (response.error)
    {
        [self requestCompletionWithErrorType:APIRequesterErrorTypeServer errorMsg:response.error.domain];
    }
    else
    {
        self.fetchedRawData = response.responseData;
        
        if ([self.validator apiRequester:self isValidWithResponseData:self.fetchedRawData])
        {
            [self requestCompletionWithErrorType:APIRequesterErrorTypeSuccess errorMsg:nil];
        }
        else
        {
            [self requestCompletionWithErrorType:APIRequesterErrorTypeResponseInvalid errorMsg:nil];
        }
        
    }
}

- (void)requestCompletionWithErrorType:(APIRequesterErrorType)type errorMsg:(NSString *)errorMsg
{
    _errorType = type;
    
    self.errorMsg = errorMsg;
    
    if (type == APIRequesterErrorTypeSuccess)
    {
        [self.delegate apiRequester:self didSuccessWithRequestId:_requestId];
    }
    else
    {
        [self.delegate apiRequester:self didFailWithRequestId:_requestId];
    }
}

@end
