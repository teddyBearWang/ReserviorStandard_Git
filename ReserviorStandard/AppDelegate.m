//
//  AppDelegate.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-22.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "IFlyFlowerCollector.h"

@implementation AppDelegate
@synthesize remDay = _remDay;
@synthesize remMonth = _remMonth;
@synthesize remYear = _remYear;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [IFlyFlowerCollector SetAppid:@"54b8aacf"];
    
    //隐藏statusBar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self refreshNowTimeDate];
     
    LoginViewController *loginCtrl = [[LoginViewController alloc] init];
    UINavigationController *navigtion = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
      //  navigtion.navigationBar.barTintColor = [UIColor colorWithRed:62/255.0 green:172/255.0 blue:247/255.0 alpha:1.0f];
        navigtion.navigationBar.barTintColor = [UIColor colorWithRed:103/255.0 green:188/255.0 blue:223/255.0 alpha:1.0];
        navigtion.navigationBar.tintColor = [UIColor whiteColor];
        //ios 7.0的系统
        navigtion.navigationBar.translucent = NO;//表示颜色不模糊
    }else{
        //ios 6修改nabigationBar颜色
        navigtion.navigationBar.tintColor = [UIColor colorWithRed:103/255.0 green:188/255.0 blue:223/255.0 alpha:1.0];
    }
    self.window.rootViewController = navigtion;
    return YES;
}

- (void)refreshNowTimeDate
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateCom = [currentCalendar components:unitFlag fromDate:currentDate];
    self.remYear = [dateCom year];
    self.remMonth = [dateCom month];
    self.remDay = [dateCom day];
    self.remHour = [dateCom hour];
    self.remMinute = [dateCom minute];
    self.remSecond = [dateCom second];
}

//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
