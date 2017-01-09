//
//  ATAPIRequestConfig.m
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ATAPIRequestConfig.h"
#import "APIRequestServiceManager.h"
#import "APIRequestCommonService.h"

@implementation ATAPIRequestConfig

+ (void)configService
{
    APIRequestCommonService *service = [[APIRequestCommonService alloc] initServiceWithIdentifier:kServiceCommonIdentifier];
    
    service.requestGenerator.apiBaseURL = @"http://api.user.local.fcuh.com";
    service.requestGenerator.apiVersion = @"v2";
    
    [[APIRequestServiceManager sharedManager] registerRequestService:service];
}

+ (NSString *)requestURLStringWithActionName:(NSString *)actionName
{
    APIRequestCommonService *service = (APIRequestCommonService *)[[APIRequestServiceManager sharedManager] serviceWithIdentifier:kServiceCommonIdentifier];
    
    return [service.requestGenerator requestURLStringWithActionName:actionName];
}

@end
