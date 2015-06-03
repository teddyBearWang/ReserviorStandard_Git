//
//  HoistObject.h
//  ReserviorStandard
// **************启闭机对象*************
//  Created by teddy on 14-11-4.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HoistObject : NSObject

@property (nonatomic, strong) NSString *name; //姓名
@property (nonatomic, strong) NSString *idNum; //id号码
@property BOOL isMark; //是否已经标志
@property (nonatomic, strong) NSString *danger; //存在问题
@end
