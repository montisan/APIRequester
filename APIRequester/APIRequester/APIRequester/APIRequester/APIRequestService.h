//
//  APIRequestService.h
//  fcuhConsumerArc
//
//  Created by Peter on 15/12/2.
//  Copyright © 2015年 Peter. All rights reserved.
//

#ifndef APIRequestService_h
#define APIRequestService_h

@protocol APIRequestDataProcessor <NSObject>

@required

- (NSData *)dataAfterProcessParamData:(NSData *)data;

- (id)dataAfterProcessResponseData:(NSData *)data;

@end

@protocol APIRequestURLRequestGenerator <NSObject>

@property (nonatomic, copy) NSString *apiBaseURL;
@property (nonatomic, copy) NSString *apiVersion;

@required

- (NSString *)requestURLStringWithActionName:(NSString *)actionName;

- (NSMutableURLRequest *)generateGETRequestWithParams:(NSDictionary *)params actionName:(NSString *)actionName;

- (NSMutableURLRequest *)generatePOSTRequestWithParams:(NSDictionary *)params actionName:(NSString *)actionName;

@end

@protocol APIRequestService <NSObject>


@property (nonatomic, copy, readonly) NSString *identifier;

@property (nonatomic, weak) id<APIRequestURLRequestGenerator> requestGenerator;
@property (nonatomic, weak) id<APIRequestDataProcessor> dataProcessor;

- (instancetype)initServiceWithIdentifier:(NSString *)identifier;

@end

#endif /* APIRequestService_h */
