//
//  SegtonInstance.h
//  ReserviorStandard
//  *****************单例******************
//  Created by teddy on 14-10-29.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegtonInstance : NSObject

@property (nonatomic, strong) NSMutableArray *userArray; // 巡查人数组
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *idNum;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, assign) int selectedIndex;

@property (nonatomic, assign) BOOL isFirst; //标志为否第一次填维护单
@property  (nonatomic, strong) NSMutableArray *imageArr; //存在本地的图片路劲

+ (SegtonInstance *)sharedTheme;
@end
