//
//  ReportedObject.h
//  ReserviorStandard
//  **********已经上报对象************
//  Created by teddy on 14-11-20.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportedObject : NSObject

@property (nonatomic, strong) NSString *deviceNum; //
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *danger;
@property (nonatomic, strong) NSString *checkPerson;
@property (nonatomic, strong) NSString *recordePerson;
@end
