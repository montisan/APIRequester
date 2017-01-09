//
//  APIRequestResponse.h
//  fcuhConsumerArc
//
//  Created by Peter on 15/11/25.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequestResponse : NSObject

@property (nonatomic, assign, readonly) NSUInteger requestId;
@property (nonatomic, strong, readonly) id responseData;
@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSError *error;

- (instancetype)initWithRequestId:(NSUInteger)requestId
                     responseData:(id)data
                          request:(NSURLRequest *)request
                            error:(NSError *)error;

@end
