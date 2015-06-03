//
//  ReportedListViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-30.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface ReportedListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *_listArray; //数据源list
    BOOL _isLoadDetail; //是否加载详情
    BOOL _isOver;//是否审批结束
}

@property (nonatomic, strong) IBOutlet UITableView *myTableView;

@end
