//
//  ATAPIBaseRequester.h
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "APIBaseRequester.h"
#import "ATAPIBaseParam.h"

@interface ATAPIBaseRequester : APIBaseRequester<APIRequester,APIRequesterParamSourceDelegate,APIRequesterDataValidator>

@property (nonatomic, strong, readwrite) ATAPIBaseParam *param;

@end
