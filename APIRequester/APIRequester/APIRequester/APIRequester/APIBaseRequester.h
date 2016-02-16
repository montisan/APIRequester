//
//  APIBaseRequester.h
//  fcuhConsumerArc
//
//  Created by Peter on 15/11/24.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APIBaseRequester;

@protocol APIRequesterParamSourceDelegate <NSObject>

@required

- (NSDictionary *)paramsForAPIRequester:(APIBaseRequester *)requester;

@end


@protocol APIRequesterResponseDelegate <NSObject>

@required

- (void)apiRequester:(APIBaseRequester *)requester didSuccessWithRequestId:(NSUInteger)requestId;
- (void)apiRequester:(APIBaseRequester *)requester didFailWithRequestId:(NSUInteger)requestId;

@end


@protocol APIRequesterDataValidator <NSObject>

@required

- (BOOL)apiRequester:(APIBaseRequester *)requester isValidWithParamData:(NSDictionary *)data;
- (BOOL)apiRequester:(APIBaseRequester *)requester isValidWithResponseData:(NSDictionary *)data;

@end

@protocol APIRequesterDataReformer <NSObject>

@required

- (id)apiRequester:(APIBaseRequester *)requester reformData:(id)data;

@end

typedef NS_ENUM(NSUInteger, APIRequesterRequestType)
{
    APIRequesterRequestTypeDefault,
    APIRequesterRequestTypeGet = APIRequesterRequestTypeDefault,
    APIRequesterRequestTypePost,
};

typedef NS_ENUM(NSUInteger, APIRequesterErrorType)
{
    APIRequesterErrorTypeDefault,
    APIRequesterErrorTypeSuccess,
    APIRequesterErrorTypeParamInvalid,
    APIRequesterErrorTypeResponseInvalid,
    APIRequesterErrorTypeServer,
    APIRequesterErrorTypeDisconnect,
};

@protocol APIRequester <NSObject>

- (NSString *)actionName;
- (APIRequesterRequestType)requestType;
- (NSString *)serviceIdentifier;

@end

@interface APIBaseRequester : NSObject

@property (nonatomic, weak) id<APIRequesterParamSourceDelegate> paramSource;
@property (nonatomic, weak) id<APIRequesterDataValidator> validator;
@property (nonatomic, weak) id<APIRequesterResponseDelegate> delegate;

@property (nonatomic, weak) id<APIRequester> child;

@property (nonatomic, assign, readonly)     APIRequesterErrorType errorType;
@property (nonatomic, copy, readonly)       NSString *errorMsg;

@property (nonatomic, assign, readonly)     NSUInteger requestId;

@property (nonatomic, assign, readonly)     BOOL isLoading;

@property (nonatomic, assign, readonly)     BOOL isReachable;

- (NSUInteger)requestData;
- (void)cancelRequest;

- (id)transformDataWithReformer:(id<APIRequesterDataReformer>)reformer;


@end
