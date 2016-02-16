//
//  ATAPIBaseRequester.m
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ATAPIBaseRequester.h"
#import "APIRequestCommonService.h"
#import "ATAPIRequestConfig.h"
//#import "ATAPIRequestSign.h"

@implementation ATAPIBaseRequester

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        if ([self conformsToProtocol:@protocol(APIRequesterDataValidator)])
        {
            self.validator = (id <APIRequesterDataValidator>) self;
        }
        
        if ([self conformsToProtocol:@protocol(APIRequesterParamSourceDelegate)])
        {
            self.paramSource = (id <APIRequesterParamSourceDelegate>) self;
        }
    }
    
    return self;
}

#pragma mark - APIRequester
- (NSString *)actionName
{
    return nil;
}

- (APIRequesterRequestType)requestType
{
    return APIRequesterRequestTypeDefault;
}

- (NSString *)serviceIdentifier
{
    return kServiceCommonIdentifier;
}

#pragma mark - APIRequesterParamSourceDelegate

- (NSDictionary *)paramsForAPIRequester:(APIBaseRequester *)requester
{
    
    NSMutableDictionary *paramData = [self.param paramData];
    
    /*
    NSString *requestURL = [ATAPIRequestConfig requestURLStringWithActionName:[self actionName]];
    
    // Sign 
    NSString* sign = [ATAPIRequestSign generateSignWithDict:paramData requestURL:requestURL];
    [paramData setValue:sign forKey:@"sign"];
     */
    
    return paramData;
}

#pragma mark - APIRequesterDataValidator

- (BOOL)apiRequester:(APIBaseRequester *)requester isValidWithParamData:(NSDictionary *)data
{
    return data != nil;
}

- (BOOL)apiRequester:(APIBaseRequester *)requester isValidWithResponseData:(NSDictionary *)data
{
    return data != nil;
}

@end
