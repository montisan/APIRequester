//
//  APIRequestServiceManager.m
//  fcuhConsumerArc
//
//  Created by Peter on 15/11/25.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import "APIRequestServiceManager.h"

@interface APIRequestServiceManager()

@property (nonatomic, strong) NSMutableDictionary *services;

@end

@implementation APIRequestServiceManager

SINGLETON_FUN_IMP(Manager)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _services = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (BOOL)registerRequestService:(id<APIRequestService>)service
{
    if (service.identifier.length == 0)
    {
        return NO;
    }
    
    [_services setObject:service forKey:service.identifier];
    
    return YES;
}

- (id<APIRequestService>)serviceWithIdentifier:(NSString *)identifier
{
    return [_services objectForKey:identifier];
}

@end
