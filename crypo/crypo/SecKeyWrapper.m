//
//  SecKeyWrapper.m
//  crypo
//
//  Created by Caland on 14/10/31.
//  Copyright (c) 2014年 Caland. All rights reserved.
//

#import "SecKeyWrapper.h"

@implementation SecKeyWrapper

@synthesize publicTag, privateTag, symmetricTag, symmetricKeyRef;
//调试的常量
#if DEBUG
    #define LOGGING_FACILITY(X, Y)	\
    NSAssert(X, Y);

    #define LOGGING_FACILITY1(X, Y, Z)	\
    NSAssert1(X, Y, Z);
#else
    #define LOGGING_FACILITY(X, Y)	\
                if (!(X)) {			\
                    NSLog(Y);		\
                }

    #define LOGGING_FACILITY1(X, Y, Z)	\
                if (!(X)) {				\
                    NSLog(Y, Z);		\
                }
#endif

//只能运行在真机上
#if TARGET_IPHONE_SIMULATOR
#error This sample is designed to run on a device, not in the simulator. To run this sample, \
choose Project > Set Active SDK > Device and connect a device. Then click Build and Go.







@end
