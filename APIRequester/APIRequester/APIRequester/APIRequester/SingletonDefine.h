//
//  SingletonDefine.h
//  fcuhConsumerArc
//
//  Created by Peter on 15/11/23.
//  Copyright © 2015年 Peter. All rights reserved.
//

#ifndef SingletonDefine_h
#define SingletonDefine_h

#define SINGLETON_FUN_DECLARE(funname) +(instancetype)shared##funname;

#define SINGLETON_FUN_IMP(funname) +(instancetype)shared##funname \
{\
    static id sharedInstance = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        sharedInstance = [[[self class] alloc] init];\
    });\
    \
    return sharedInstance;\
}

#endif /* SingletonDefine_h */
