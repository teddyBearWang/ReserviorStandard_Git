//
//  UserObject.h
//  ReserviorStandard
// ****************用户对象***********
//  Created by teddy on 14-11-19.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property (nonatomic, strong) NSString *userName; //账号
@property (nonatomic, strong) NSString *psw; //密码
@property (nonatomic, strong) NSString *idNum;
@property (nonatomic, strong) NSString *phoneNumber; //电话号码
@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, assign) BOOL isMark;  //是否标记

@end
