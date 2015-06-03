//
//  SegtonInstance.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-29.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "SegtonInstance.h"

@implementation SegtonInstance
+ (SegtonInstance *)sharedTheme
{
    static dispatch_once_t onceToken;
    static SegtonInstance *segtonInstance = nil;
    dispatch_once(&onceToken, ^{
        segtonInstance = [[SegtonInstance alloc] init];
    });
    return segtonInstance;
}

@end
