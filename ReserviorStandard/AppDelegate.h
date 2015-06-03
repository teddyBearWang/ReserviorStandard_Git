//
//  AppDelegate.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-22.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHAREAPP ((AppDelegate*)([[UIApplication sharedApplication]delegate]))
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSInteger remYear;
@property (assign, nonatomic) NSInteger remDay;
@property (assign, nonatomic) NSInteger remMonth;
@property (assign, nonatomic) NSInteger remHour;
@property (assign, nonatomic) NSInteger remMinute;
@property (assign, nonatomic) NSInteger remSecond;

- (void)refreshNowTimeDate;
@end
