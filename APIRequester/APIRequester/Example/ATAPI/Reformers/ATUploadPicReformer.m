//
//  ATUploadPicReformer.m
//  FcuhActivityTool
//
//  Created by Peter on 16/1/6.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ATUploadPicReformer.h"


@implementation ATUploadPicReformer

- (id)apiRequester:(APIBaseRequester *)requester reformData:(id)data
{
    NSDictionary *result = [data objectForKey:@"data"];
    
    NSString *picUrl = [result objectForKey:@"pictureUrl"];
    
    return picUrl;
}

@end
