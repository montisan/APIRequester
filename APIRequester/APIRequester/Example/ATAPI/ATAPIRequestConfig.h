//
//  ATAPIRequestConfig.h
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATAPIRequestConfig : NSObject

+ (void)configService;

+ (NSString *)requestURLStringWithActionName:(NSString *)actionName;

@end
