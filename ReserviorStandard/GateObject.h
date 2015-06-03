//
//  GateObject.h
//  ReserviorStandard
//// **************闸门对象s********************
//  Created by teddy on 14-11-4.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GateObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *idNum;
@property (nonatomic, strong) NSString *state; //表示隐患

@end
