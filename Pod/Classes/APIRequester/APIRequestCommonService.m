//
//  APIRequestCommonService.m
//  fcuhConsumerArc
//
//  Created by Peter on 15/12/2.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "APIRequestCommonService.h"
#import "AFURLRequestSerialization.h"

NSString * const kServiceCommonIdentifier = @"kServiceCommonIdentifier";

@interface APIRequestCommonService()

@property (nonatomic, copy, readwrite) NSString *identifier;

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

@end

@implementation APIRequestCommonService

@synthesize dataProcessor = _dataProcessor;
@synthesize requestGenerator = _requestGenerator;
@synthesize apiBaseURL = _apiBaseURL;
@synthesize apiVersion = _apiVersion;

- (instancetype)initServiceWithIdentifier:(NSString *)identifier
{
    self = [self init];
    if (self)
    {
        _identifier = [identifier copy];
        
        if ([self conformsToProtocol:@protocol(APIRequestDataProcessor)])
        {
            self.dataProcessor = self;
        }
        
        if ([self conformsToProtocol:@protocol(APIRequestURLRequestGenerator)])
        {
            self.requestGenerator = self;
        }
    }
    
    return self;
}

- (AFHTTPRequestSerializer *)requestSerializer
{
    if (!_requestSerializer)
    {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    return _requestSerializer;
}

#pragma mark - APIRequestDataProcessor

- (NSData *)dataAfterProcessParamData:(NSData *)data
{
    if (!data)
    {
        return nil;
    }
    
    id processedData = data;
    
    if (self.compressEnabled)
    {
//        processedData = [processedData cf_gzipData];
    }
    
    return processedData;
}

- (id)dataAfterProcessResponseData:(NSData *)data
{
    if (!data)
    {
        return nil;
    }
    
    NSData *processedData = data;
    if (self.compressEnabled)
    {
//        processedData = [processedData cf_uncompressZippedData];
    }
    
    NSDictionary *processedDic = [NSJSONSerialization JSONObjectWithData:processedData options:NSJSONReadingAllowFragments error:nil];
    
    return processedDic;
}

#pragma mark - APIRequestURLRequestGenerator

- (NSString *)requestURLStringWithActionName:(NSString *)actionName
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",self.apiBaseURL,self.apiVersion,actionName];
    
    return url;
}

- (NSMutableURLRequest *)generateGETRequestWithParams:(NSDictionary *)params actionName:(NSString *)actionName
{
    NSString *url = [self requestURLStringWithActionName:actionName];
    
    return [self.requestSerializer requestWithMethod:@"GET" URLString:url parameters:params error:nil];
}

- (NSMutableURLRequest *)generatePOSTRequestWithParams:(NSDictionary *)params actionName:(NSString *)actionName
{
    NSString *url = [self requestURLStringWithActionName:actionName];
    
    return [self.requestSerializer requestWithMethod:@"POST" URLString:url parameters:params error:nil];
}

@end
