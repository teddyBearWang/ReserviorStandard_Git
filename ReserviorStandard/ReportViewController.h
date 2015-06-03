//
//  ReportViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-11-20.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHttpRequest.h"

@interface ReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *_listArray;
}

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, assign) KReportedType reportedType;//上报信息类型
@end
