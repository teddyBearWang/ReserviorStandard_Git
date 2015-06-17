//
//  PrePareViewController.m
//  ReserviorStandard
//
//  Created by teddy on 14-11-13.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "PrePareViewController.h"
#import "SegtonInstance.h"
#import "CustomDateActionSheet.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "ConcreteCheckViewController.h"
#import "ReportViewController.h"

@interface PrePareViewController ()

@end

@implementation PrePareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    self.dateTimeField.delegate = self;
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",SHAREAPP.remYear,SHAREAPP.remMonth,SHAREAPP.remDay,SHAREAPP.remHour,SHAREAPP.remMinute];
    self.dateTimeField.text = dateStr;
    
    
    SegtonInstance *instance = [SegtonInstance sharedTheme];
    self.checkField.text = instance.userName;
    self.orderField.text = instance.userName;
    self.tempertureField.text = instance.temperture;
    self.weatherField.text = instance.weather;
    self.checkField.delegate = self;
    self.orderField.delegate = self;
    
    [self.checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    [self.checkBtn addTarget:self action:@selector(startCheckAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem= [[UIBarButtonItem alloc] initWithTitle:@"已上报" style:UIBarButtonItemStylePlain target:self action:@selector(reportedAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取上报信息
- (void)reportedAction:(id)sender
{
    ReportViewController *report = [[ReportViewController alloc] init];
    report.reportedType = kDamReportedType;
    [self.navigationController pushViewController:report animated:YES];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1001) {
        CustomDateActionSheet *timeAction = [[CustomDateActionSheet alloc] initWithTitle:@"请选择时间" delegate:self];
        timeAction.tag = 3001;
        [timeAction showInView:self.view];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1001) {
        [self.view endEditing:YES];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    [UIView commitAnimations];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CustomDateActionSheet *time = (CustomDateActionSheet *)actionSheet;
    if (time.Index == 1) {
        self.dateTimeField.text = time.selectedTime.time;
    }
}

#pragma mark - private method
//开始巡查
- (void)startCheckAction
{
    if (self.dateTimeField.text.length == 0 || self.weatherField.text.length == 0 || self.tempertureField.text.length == 0 || self.checkField.text.length == 0 || self.orderField.text == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你填写的信息不完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    SegtonInstance *seg = [SegtonInstance sharedTheme];
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    NSString *value = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@$%@",self.dateTimeField.text,self.weatherField.text,self.tempertureField.text,seg.userName,seg.userName,seg.idNum,seg.idNum];
    
    [request setPostValue:@"InsertConcreteDamSafetyCheck" forKey:@"t"];
    [request setPostValue:value forKey:@"results"];
    [SVProgressHUD showWithStatus:@"巡查准备中..."];
    [request startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        NSString *resString = request.responseString;
        NSData *jsonData = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dic = [jsonArray objectAtIndex:0];
         _ParentId = [dic objectForKey:@"parentId"];
        [SVProgressHUD dismissWithSuccess:@"开始巡查"];
        ConcreteCheckViewController *conrete = [[ConcreteCheckViewController alloc] init];
        conrete.parentID = _ParentId;
        [self.navigationController pushViewController:conrete animated:YES];
    } else {
        [SVProgressHUD dismissWithError:@"巡查失败"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"巡查失败"];
}

- (IBAction)tapBgView:(id)sender
{
    CustomDateActionSheet *date = (CustomDateActionSheet *)[self.view viewWithTag:3001];
    [date cancelAction:nil];
    [self.dateTimeField resignFirstResponder];
    [self.weatherField resignFirstResponder];
    [self.tempertureField resignFirstResponder];
    [self.checkField resignFirstResponder];
    [self.orderField resignFirstResponder];
}
@end
