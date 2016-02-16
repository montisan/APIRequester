//
//  ATUploadPictureRequester.m
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ATUploadPictureRequester.h"
#import "ATUploadPictureParam.h"

@implementation ATUploadPictureRequester

- (NSString *)actionName
{
    return @"activitiesUserInformation/imageUpLoad";
}

- (NSUInteger)uploadPicture:(NSString *)picBase64 imageType:(NSString *)type
{
    ATUploadPictureParam *param = [ATUploadPictureParam param];
    param.picture = picBase64;
    param.imageType = type;
    
    self.param = param;
    
    return [super requestData];
}

@end
