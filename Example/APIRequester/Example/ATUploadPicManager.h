//
//  ATUploadPicManager.h
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ATUploadResult)
{
    ATUploadResultSuc,
    ATUploadResultCancel,
    ATUploadResultFail,
};

typedef void(^ATUploadCallback)(ATUploadResult result, NSString *picURL, NSString *errMsg);

@interface ATUploadPicManager : NSObject

- (void)requestUploadPictureInController:(UIViewController *)controller uploadCallback:(ATUploadCallback)callback;

@end
