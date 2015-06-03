//
//  DetailProcessObject.h
//  ReserviorStandard
//  ****************审批详情对象************
//  Created by teddy on 14-11-6.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailProcessObject : NSObject

@property (nonatomic, strong) NSString *idNum;
@property (nonatomic, strong) NSString *patrolId;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSString *answerName;
@end
