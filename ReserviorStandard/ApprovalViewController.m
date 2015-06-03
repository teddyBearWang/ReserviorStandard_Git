//
//  ApprovalViewController.m
//  ReserviorStandard
// ******************审批流程显示******************
//  Created by teddy on 14-10-30.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "ApprovalViewController.h"
#import "RepairViewController.h"
#import "CustomReportCell.h"
#import "DetailProcessObject.h"
#import "ASIFormDataRequest.h"

@interface ApprovalViewController ()

@end

@implementation ApprovalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"审批详情";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self getWebServerAction];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 50;
    
    [self.unRepairBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    [self.repairBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    self.repairBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.unRepairBtn.layer.borderColor = [UIColor clearColor].CGColor;
    if (!_isOK) {
        self.unRepairBtn.hidden = YES;
        self.repairBtn.hidden = YES;
    } else {
        self.unRepairBtn.hidden = NO;
        self.repairBtn.hidden = NO;
    }
    if (self.listArr.count == 0) {
        self.listArr = [NSMutableArray array];
        DetailProcessObject *detaol = [[DetailProcessObject alloc] init];
        [self.listArr addObject:detaol];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//不修理
- (IBAction)griveUpRepairAction:(id)sender
{
    //不修理的处理方法
}

//修理
- (IBAction)repairAction:(id)sender
{
    //填写维修表
    RepairViewController *repair = [[RepairViewController alloc] init];
    DetailProcessObject *detail = (DetailProcessObject *)[self.listArr objectAtIndex:0];
    repair.common_id = detail.patrolId;
    [self.navigationController pushViewController:repair animated:YES];
    
}

#pragma mark - UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myCell";
    CustomReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CustomReportCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    DetailProcessObject *detail = (DetailProcessObject *)[self.listArr objectAtIndex:indexPath.row];
    cell.textLabel.text = detail.answerName;
    cell.detailTextLabel.text = detail.time;
    cell.stateLabel.text = detail.answer;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 
- (void)getWebServerAction
{
    //选择进去看详细进度
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"GetCommonPatrolDetail" forKey:@"t"];
    [request setPostValue:self.patrolId forKey:@"results"];
    [SVProgressHUD showWithStatus:@"数据加载中.."];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        [SVProgressHUD dismissWithSuccess:@"加载成功"];
        NSString *resString = request.responseString;
        NSData *data = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        self.listArr = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary *dic in arr) {
            DetailProcessObject *detail = [[DetailProcessObject alloc] init];
            detail.idNum = [dic objectForKey:@"Id"];
            detail.patrolId = [dic objectForKey:@"PatrolId"];
            detail.time = [dic objectForKey:@"Time"];
            detail.answer = [dic objectForKey:@"Answer"];
            detail.answerName = [dic objectForKey:@"AnswerUserName"];
            [self.listArr addObject:detail];
        }
        [self.myTableView reloadData];
    } else{
         [SVProgressHUD dismissWithSuccess:@"加载失败"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
      [SVProgressHUD dismissWithSuccess:@"加载失败"];
}
@end
