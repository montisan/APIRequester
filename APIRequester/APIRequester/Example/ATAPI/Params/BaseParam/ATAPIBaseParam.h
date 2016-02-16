//
//  ATAPIBaseParam.h
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATAPIBaseParam : NSObject

@property(nonatomic, copy) NSString *appId;
@property(nonatomic, copy) NSString *deviceType;
@property(nonatomic, copy) NSString *appVersion;
@property(nonatomic, copy) NSString *deviceId;
@property(nonatomic, assign) long long timestamp;
@property(nonatomic, copy) NSString* token;

+ (instancetype)param;
/**
 *  忽略某些字段
 *
 *  @param ingoreKeys 需要忽略的字段名
 */
- (void)setIngoreKeys:(NSArray *)ingoreKeys;


- (NSMutableDictionary *)paramData;

@end
