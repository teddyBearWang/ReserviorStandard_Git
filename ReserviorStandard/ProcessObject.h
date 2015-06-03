//
//  ProcessObject.h
//  ReserviorStandard
// *******审批进度对象********
//  Created by teddy on 14-11-6.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessObject : NSObject

@property (nonatomic, strong) NSString *machineName;
@property (nonatomic, strong) NSString *patrolId;
@property (nonatomic, strong) NSString *patrolTime;
@property (nonatomic, strong) NSString *WFStatus;
@property (nonatomic, strong) NSString *WF_Step;

@end
