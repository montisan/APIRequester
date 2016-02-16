//
//  APIRequestProxy.h
//  fcuhConsumerArc
//
//  Created by Peter on 15/11/24.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonDefine.h"
#import "APIRequestResponse.h"

typedef void (^RequestCompletion)(APIRequestResponse *response) ;

@interface APIRequestProxy : NSObject

@property (nonatomic, assign, readonly) BOOL isReachable;

SINGLETON_FUN_DECLARE(Proxy)

- (NSUInteger)doGetRequestWithParams:(NSDictionary *)params
                 serviceIdentifier:(NSString *)identifier
                        actionName:(NSString *)actionName
                        completion:(RequestCompletion)completion;

- (NSUInteger)doPostRequestWithParams:(NSDictionary *)params
                  serviceIdentifier:(NSString *)identifier
                         actionName:(NSString *)actionName
                         completion:(RequestCompletion)completion;

- (void)cancelRequestWithRequestId:(NSUInteger)requestId;

- (BOOL)isLoadingWithRequestId:(NSUInteger)requestId;

@end
