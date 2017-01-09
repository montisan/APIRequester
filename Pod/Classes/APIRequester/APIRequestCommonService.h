//
//  APIRequestCommonService.h
//  fcuhConsumerArc
//
//  Created by Peter on 15/12/2.
//  Copyright © 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequestService.h"

extern NSString * const kServiceCommonIdentifier;

@interface APIRequestCommonService : NSObject<APIRequestService,APIRequestDataProcessor,APIRequestURLRequestGenerator>

@property (nonatomic, assign) BOOL compressEnabled;

@end
