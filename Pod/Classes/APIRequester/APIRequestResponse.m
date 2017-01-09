//
//  APIRequestResponse.m
//  fcuhConsumerArc
//
//  Created by Peter on 15/11/25.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "APIRequestResponse.h"

@interface APIRequestResponse()

@property (nonatomic, assign, readwrite) NSUInteger requestId;
@property (nonatomic, strong, readwrite) id responseData;
@property (nonatomic, strong, readwrite) NSURLRequest *request;
@property (nonatomic, strong, readwrite) NSError *error;

@end

@implementation APIRequestResponse

- (instancetype)initWithRequestId:(NSUInteger)requestId
                     responseData:(id)data
                          request:(NSURLRequest *)request
                            error:(NSError *)error
{
    self = [self init];
    if (self)
    {
        _requestId = requestId;
        _responseData = data;
        _request = request;
        _error = error;
    }
    
    return self;
}

@end
