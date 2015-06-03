//
//  ApprovalViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-30.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSButton.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"

@interface ApprovalViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet RSButton *repairBtn;
@property (weak, nonatomic) IBOutlet RSButton *unRepairBtn;

@property (nonatomic, strong) NSMutableArray *listArr; //数据源
@property (nonatomic, assign) BOOL isOK; //是否审批结束
@property (nonatomic, strong) NSString *patrolId;

//放弃修理
- (IBAction)griveUpRepairAction:(id)sender;
//修理
- (IBAction)repairAction:(id)sender;
@end
