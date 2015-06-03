//
//  RepairObject.h
//  ReserviorStandard
//*****************维修表对象*****************
//  Created by teddy on 14-10-31.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepairObject : NSObject

@property (nonatomic, strong) NSString *machineName; //设备名称
@property (nonatomic, strong) NSString *parameter; // 参数
@property (nonatomic, strong) NSString *repairReason; //维修事由
@property (nonatomic, strong) NSString *content; //工作内容
@property (nonatomic, strong) NSString *processState; //完成情况
@property (nonatomic, strong) NSString *problem;// 遗留问题
@property (nonatomic, strong) NSString *repairUnit;//检修单位
@property (nonatomic, strong) NSString *acceptUnit; //验收单位
@property (nonatomic, strong) NSString *repairPerson; //检修负责人
@property (nonatomic, strong) NSString *acceptPerson; //验收人员
@property (nonatomic, strong) NSString *repairTime; //检修时间
@property (nonatomic, strong) NSString *acceptTime; //验收时间
@property (nonatomic, strong) NSString *note; //备注
@end
