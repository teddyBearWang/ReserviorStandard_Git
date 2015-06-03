//
//  ReportViewController.m
//  ReserviorStandard
//
//  Created by teddy on 14-11-20.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportedCell.h"
#import "ReportedObject.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "ReportedObject.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"已上报";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.reportedType == kDamReportedType) {
        //获取大坝上报记录
        [self getDamReportedInfoAction];
    } else if (self.reportedType == kDamHoistReportedType){
        //大坝启闭机
        [self getDamHoistAndFirstPowerHoistReportedAction];
    }else if(self.reportedType == kFirstPowerHoistReportedType){
        //一级电厂
        [self getDamHoistAndFirstPowerHoistReportedAction];
    } else if (self.reportedType == kSecondPowerHoistReportedType){
        //二级电厂启闭机
        [self getSecondePowerHoistAction];
    } else {
        //闸门
        [self getSteelGateReportAction];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT} style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 160;
    [self.view addSubview:self.myTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getWebServerAction
//获取大坝的上报信息
- (void)getDamReportedInfoAction
{
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"GetDamInfo" forKey:@"t"];
    [request setTimeOutSeconds:30];
    [SVProgressHUD show];
    [request startAsynchronous];
}

//获取卷扬式启闭机上报信息s
- (void)getDamHoistAndFirstPowerHoistReportedAction
{
    NSString *result = nil;
    if (self.reportedType == kDamHoistReportedType) {
        result = @"大坝";
    } else {
        result = @"一级电厂";
    }
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"GetGateLiftingHoistCheck" forKey:@"t"];
    [request setPostValue:result forKey:@"results"];
    [request setTimeOutSeconds:60];
    [SVProgressHUD show];
    [request startAsynchronous];
}

//获取二级电厂螺杆启闭机
- (void)getSecondePowerHoistAction
{
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"GetScrewHoistCheck" forKey:@"t"];
    [request setTimeOutSeconds:60];
    [SVProgressHUD show];
    [request startAsynchronous];
}

//获取钢闸门上报信息
- (void)getSteelGateReportAction
{
    NSString *gateType = nil;
    if (self.reportedType == kDamGateReportedType)
    {
        //大坝钢闸门
        gateType = @"1";
    } else if (self.reportedType == kFirstPowerGateReportedType){
        //一级电厂钢闸门
        gateType = @"3";
    } else {
        //二级电厂钢闸门
        gateType = @"2";
    }
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"GetGateCheck" forKey:@"t"];
    [request setPostValue:gateType forKey:@"results"];
    [request setTimeOutSeconds:60];
    [SVProgressHUD show];
    [request startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        [SVProgressHUD dismissWithSuccess:@"加载成功"];
        NSString *resString = request.responseString;
        NSData *data = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if (_listArray.count != 0) {
            [_listArray removeAllObjects];
        } else {
            _listArray = [NSMutableArray arrayWithCapacity:arr.count];
        }
        //根据不同类型处理
        if (self.reportedType == kDamReportedType) {
            //大坝
            for (int i=0; i<arr.count; i++) {
                ReportedObject *report = [[ReportedObject alloc] init];
                NSDictionary *dic = [arr objectAtIndex:i];
                report.time = [dic objectForKey:@"AddTime"];
                report.checkPerson = [dic objectForKey:@"CheckUserName"];
                report.recordePerson = [dic objectForKey:@"RecordUserName"];
                report.content = [dic objectForKey:@"part"];
                report.danger = @"有问题";
                [_listArray addObject:report];
            }
        } else if (self.reportedType == kDamHoistReportedType || self.reportedType == kFirstPowerHoistReportedType || self.reportedType == kSecondPowerHoistReportedType) {
            //启闭机
            for (int i=0; i<arr.count; i++) {
                ReportedObject *report = [[ReportedObject alloc] init];
                NSDictionary *dic = [arr objectAtIndex:i];
                report.time = [dic objectForKey:@"AddTime"];
                report.deviceNum = [dic objectForKey:@"HoistNo"];
                report.checkPerson = [dic objectForKey:@"CheckUserName"];
                report.recordePerson = [dic objectForKey:@"RecordUserName"];
                report.area = [dic objectForKey:@"part"];
                report.content = [dic objectForKey:@"checkItem"];
                report.danger = [dic objectForKey:@"checkResult"];
                [_listArray addObject:report];
            }
        } else {
            //钢闸门
            for (int i=0; i<arr.count; i++) {
                ReportedObject *report = [[ReportedObject alloc] init];
                NSDictionary *dic = [arr objectAtIndex:i];
                report.time = [dic objectForKey:@"AddTime"];
                report.deviceNum = [dic objectForKey:@"GateNo"];
                report.checkPerson = [dic objectForKey:@"CheckUserName"];
                report.recordePerson = [dic objectForKey:@"RecordUserName"];
                report.content = [dic objectForKey:@"part"];
                //report.content = [dic objectForKey:@"checkItem"];
                report.danger = [dic objectForKey:@"checkResult"];
                [_listArray addObject:report];
            }
        }
        [self.myTableView reloadData];
    } else {
        [SVProgressHUD dismissWithSuccess:@"加载失败"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"加载失败"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myCell";
    ReportedCell *cell = (ReportedCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        @try {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportedCell" owner:self options:nil] firstObject];

        }
        @catch (NSException *exception) {
            NSLog(@"抓到的错误是：%@",exception);
        }
    }
    if (_listArray.count != 0) {
        ReportedObject *report = (ReportedObject *)[_listArray objectAtIndex:indexPath.section];
        cell.hoistNumlabel.text = [NSString stringWithFormat:@"台号：%@",report.deviceNum];
        cell.timeLabel.text = report.time;
        cell.areaLabel.text = report.area;
        cell.contentLabel.text = report.content;
        cell.dangerLabel.text = report.danger;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
