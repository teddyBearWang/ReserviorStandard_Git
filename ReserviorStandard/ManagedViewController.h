//
//  ManagedViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-11-19.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegtonInstance.h"
#import "ASIHTTPRequest.h"

@interface ManagedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    UITableView *_myTableView;
    SegtonInstance *_instance;
    BOOL _isNeed;//需要刷新的条件
    NSString *_downloadUrl;
}

@property (nonatomic, strong) UITableView *myTableView;
@end
