//
//  ReportedListViewController.m
//  ReserviorStandard
// ******************已经上报的数据控制器******************
//  Created by teddy on 14-10-30.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "ReportedListViewController.h"
#import "ApprovalViewController.h"
#import "RTLabel.h"
#import "ASIFormDataRequest.h"
#import "SegtonInstance.h"
#import "SVProgressHUD.h"
#import "ProcessObject.h"
#import "DetailProcessObject.h"
#import "CustomReportCell.h"

@interface ReportedListViewController ()

@end

@implementation ReportedListViewController
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"上报详情";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self getWebDataAction];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webServerAction
- (void)getWebDataAction
{
    SegtonInstance *instance = [SegtonInstance sharedTheme];
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"GetCommonPatrolStatus" forKey:@"t"];
    [request setPostValue:instance.idNum forKey:@"results"];
    [SVProgressHUD showWithStatus:@"加载数据中.."];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
   
    if (request.responseStatusCode == 200) {
        [SVProgressHUD dismissWithSuccess:@"加载成功"];
        NSString *resString = request.responseString;
        NSData *data = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //表示加载本列表数据源
            _listArray = [NSMutableArray arrayWithCapacity:arr.count];
            for (NSDictionary *dic in arr) {
                ProcessObject *process = [[ProcessObject alloc] init];
                process.machineName = [dic objectForKey:@"EquipmentName"];
                process.patrolId = [dic objectForKey:@"PatrolId"];
                process.patrolTime = [dic objectForKey:@"PatrolTime"];
                process.WFStatus = [dic objectForKey:@"WFStatus"];
                [_listArray addObject:process];
            }
            [self.myTableView reloadData];
    }else{
         [SVProgressHUD dismissWithSuccess:@"加载失败"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"数据加载失败"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyCell";
    CustomReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CustomReportCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    ProcessObject *process = (ProcessObject *)[_listArray objectAtIndex:indexPath.row];
    cell.textLabel.text = process.machineName;
    cell.detailTextLabel.text = process.patrolTime;
    cell.stateLabel.text = process.WFStatus;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    ProcessObject *process = (ProcessObject *)[_listArray objectAtIndex:indexPath.row];
    _isLoadDetail = YES;
    SegtonInstance *instance = [SegtonInstance sharedTheme];
    if ([process.WFStatus isEqualToString:@"等待维护确认"]  ) {
        //表示可以维修
        _isOver = YES;
        instance.isFirst = YES;
    }else if ([process.WFStatus isEqualToString:@"维护中"]){
        _isOver = YES;//维护中
        instance.isFirst = NO;
    } else {
        _isOver = NO;
    }
    ApprovalViewController *approval = [[ApprovalViewController alloc] init];
    //approval.listArr = (NSMutableArray *)[[result reverseObjectEnumerator] allObjects]; //传值
    approval.isOK = _isOver;
    approval.patrolId = process.patrolId;
    [self.navigationController pushViewController:approval animated:YES];
}

@end
