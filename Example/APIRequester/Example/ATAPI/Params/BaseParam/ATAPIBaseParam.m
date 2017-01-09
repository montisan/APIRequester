//
//  ATAPIBaseParam.m
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ATAPIBaseParam.h"
#import "NSObject+MJKeyValue.h"
//#import "ATAPIBaseData.h"

@implementation ATAPIBaseParam {
     NSArray * _ingoreKeys;
}

- (id)init
{
    if (self = [super init])
    {
//        self.appId = [ATAPIBaseData sharedData].appId;
//        self.deviceType = [ATAPIBaseData sharedData].deviceType;
//        self.deviceId = [ATAPIBaseData sharedData].deviceId;
//        self.appVersion = [ATAPIBaseData sharedData].appVersion;
//        self.token = [ATAPIBaseData sharedData].token;
//        self.timestamp = [ATAPIBaseData sharedData].timeStamp;
    }
    
    return self;
}

+ (instancetype)param
{
    //设计成self是可以用于初始化子类,子类可以有无限多个
    //self	Class	UserInfoParam
    //self	Class	HomeStatusesParam
    return [[self alloc] init];
}

- (void)setIngoreKeys:(NSArray *)ingoreKeys
{
    _ingoreKeys = ingoreKeys;
}

- (NSMutableDictionary *)paramData
{
//    self.timestamp = [ATAPIBaseData sharedData].timeStamp;
    
    return [self keyValues];
}

- (NSMutableDictionary *)keyValues
{
    NSMutableDictionary *keyValues = [self keyValuesWithIgnoredKeys:_ingoreKeys];
    
    return [self encodeParams:keyValues];
}

- (NSMutableDictionary *)encodeParams:(NSMutableDictionary *)params
{
    for (NSString *key in [params allKeys])
    {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSString class]] && [value length] > 0)
        {
            
            NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                          (CFStringRef)value, nil,
                                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
            
            [params setObject:encodedValue forKey:key];
        }
    }
    
    return params;
}

@end
