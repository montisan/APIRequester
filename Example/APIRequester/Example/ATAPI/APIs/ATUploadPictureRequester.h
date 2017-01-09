//
//  ATUploadPictureRequester.h
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ATAPIBasePostRequester.h"

@interface ATUploadPictureRequester : ATAPIBasePostRequester

- (NSUInteger)uploadPicture:(NSString *)picBase64 imageType:(NSString *)type;

@end
