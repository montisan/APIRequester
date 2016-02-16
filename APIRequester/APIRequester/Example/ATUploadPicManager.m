//
//  ATUploadPicManager.m
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ATUploadPicManager.h"
#import "ATUploadPictureRequester.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

//#import "WSProgressHUD.h"
#import "ATUploadPicReformer.h"

@interface ATUploadPicManager()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,APIRequesterResponseDelegate>

@property (nonatomic, weak) UIViewController *inController;

@property (nonatomic, strong) ATUploadPictureRequester *uploadRequester;

@property (nonatomic, copy) ATUploadCallback callback;

@end

@implementation ATUploadPicManager

- (ATUploadPictureRequester *)uploadRequester
{
    if (!_uploadRequester)
    {
        _uploadRequester = [[ATUploadPictureRequester alloc] init];
        _uploadRequester.delegate = self;
    }
    
    return _uploadRequester;
}

- (void)requestUploadPictureInController:(UIViewController *)controller uploadCallback:(ATUploadCallback)callback
{
    self.inController = controller;
    
    self.callback = callback;
    
    [self showGetPictureSheet];
}

#pragma mark - Private
- (void)showGetPictureSheet
{
    UIActionSheet * as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
    UIView * view = ((UIViewController *)self.inController).view;
    [as showInView:view];
}

- (void)doUploadPicture:(UIImage *)image
{
//    [WSProgressHUD showWithStatus:@"上传中..." maskType:(WSProgressHUDMaskTypeClear) maskWithout:(WSProgressHUDMaskWithoutNavigation)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = UIImageJPEGRepresentation(image,0.1);//UIImageJPEGRepresentation(image , 0.4)
        NSString * base64String = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.uploadRequester uploadPicture:base64String imageType:nil];
            
        });
        
    });
    
}

- (void)notifyUploadPictureURL:(NSString *)picURL error:(NSString *)errMsg
{
//    [WSProgressHUD dismiss];
    
    if (self.callback)
    {
        self.callback(picURL.length > 0?ATUploadResultSuc:ATUploadResultFail,picURL,errMsg);
        
        self.callback = nil;
    }
}


#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIViewController * controller = self.inController;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        UIAlertView *  alert = [[UIAlertView alloc] initWithTitle:@"权限未开启" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        
        if (buttonIndex ==0) {
            UIImagePickerController * pick = [UIImagePickerController new];
            pick.navigationBar.tintColor = [UIColor whiteColor];
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            pick.allowsEditing = true;
            pick.delegate = self;
            [controller presentViewController:pick animated:true completion:nil];
        }else if(buttonIndex == 1){
            UIImagePickerController * pick = [UIImagePickerController new];
            pick.navigationBar.tintColor = [UIColor whiteColor];
            pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pick.allowsEditing = true;
            pick.delegate = self;
            [controller presentViewController:pick animated:true completion:nil];
        }
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self performSelector:@selector(doUploadPicture:) withObject:image afterDelay:0.0];
    
    [picker dismissViewControllerAnimated:true completion:nil];
    
}

#pragma mark - 
- (void)apiRequester:(APIBaseRequester *)requester didSuccessWithRequestId:(NSUInteger)requestId
{
    NSString *picURL = [requester transformDataWithReformer:[[ATUploadPicReformer alloc] init]];
    
    [self notifyUploadPictureURL:picURL error:requester.errorMsg];
}

- (void)apiRequester:(APIBaseRequester *)requester didFailWithRequestId:(NSUInteger)requestId
{
    [self notifyUploadPictureURL:nil error:requester.errorMsg];
}


@end
