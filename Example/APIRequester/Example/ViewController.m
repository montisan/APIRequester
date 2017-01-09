//
//  ViewController.m
//  APIRequester
//
//  Created by Peter on 16/1/8.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ViewController.h"
#import "ATUploadPicManager.h"
#import "ATAPIRequestConfig.h"

@interface ViewController ()

@property (nonatomic, strong) ATUploadPicManager *uploadManager;

@end

@implementation ViewController

- (ATUploadPicManager *)uploadManager
{
    if (!_uploadManager)
    {
        _uploadManager = [[ATUploadPicManager alloc] init];
    }
    
    return _uploadManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [ATAPIRequestConfig configService];
    
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadBtn setTitle:@"Upload Picture" forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadPic:) forControlEvents:UIControlEventTouchUpInside];
    [uploadBtn setFrame:CGRectMake(100, 200, 100, 40)];
    [uploadBtn setBackgroundColor:[UIColor redColor]];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:uploadBtn];
}

- (void)uploadPic:(id)sender
{
    [self.uploadManager requestUploadPictureInController:self uploadCallback:^(ATUploadResult result, NSString *picURL, NSString *errMsg) {
        
        NSLog(@"Upload picture with response url:%@",picURL);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
