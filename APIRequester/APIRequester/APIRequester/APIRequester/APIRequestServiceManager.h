//
//  APIRequestServiceManager.h
//  fcuhConsumerArc
//
//  Created by Peter on 15/11/25.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonDefine.h"
#import "APIRequestService.h"


@interface APIRequestServiceManager : NSObject

SINGLETON_FUN_DECLARE(Manager)

- (BOOL)registerRequestService:(id<APIRequestService>)service;

- (id<APIRequestService>)serviceWithIdentifier:(NSString *)identifier;

@end
