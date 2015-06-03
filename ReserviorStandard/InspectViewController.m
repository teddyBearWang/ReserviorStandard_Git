//
//  InspectViewController.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-30.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "InspectViewController.h"
#import "ReportedListViewController.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "SegtonInstance.h"
#import "SVProgressHUD.h"

@interface InspectViewController ()

@end

@implementation InspectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设备巡查";
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
    self.processTextView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardCancelAction:) name:UIKeyboardWillHideNotification object:nil];
    [self.uploadBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    [self.OKBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    
    NSArray *arr = @[@"拍照",@"已上报"];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:arr];
    seg.segmentedControlStyle = UISegmentedControlStyleBar;
    seg.multipleTouchEnabled = NO;
    seg.momentary = YES; //点击之后知否恢复原样
    seg.apportionsSegmentWidthsByContent = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:seg];
    [seg addTarget:self action:@selector(ReportedItemAction:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    _isMoved = YES;
    [UIView commitAnimations];
}

- (void)keyboardCancelAction:(NSNotification *)notification
{
    if (_isMoved) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:-0.5];
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
        [UIView commitAnimations];
        _isMoved = NO;
    }
}

#pragma mark - privated Action
- (void)ReportedItemAction:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if (seg.selectedSegmentIndex == 0) {
        TakePhotoViewController *takePhoto = [[TakePhotoViewController alloc] init];
        takePhoto.delegate = self;
        [self.navigationController pushViewController:takePhoto animated:YES];
    } else {
        ReportedListViewController *reported = [[ReportedListViewController alloc] init];
        [self.navigationController pushViewController:reported animated:YES];
    }
}

#pragma mark - takePhotoDelegate
- (void)takePhotoWithArray:(NSMutableArray *)array
{
    _imgArray = [NSMutableArray arrayWithArray:array];
}

//存在问题上报或者自行处理
- (IBAction)uploadProblemAction:(id)sender
{
    if (![self checkTextIsEmputy]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"是否需要领导审批处理" delegate:self cancelButtonTitle:@"不需要" otherButtonTitles:@"需要", nil];
        [alert show];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *is_needReport = nil;
    NSString *wfStatus = nil;
    if (buttonIndex == 0) {
        is_needReport = @"0";
        wfStatus = @"-2";
    } else {
        is_needReport = @"1";
        wfStatus = @"-1";
    }
    [self webActionWithResport:is_needReport withStatus:wfStatus];
}

//没有问题
- (IBAction)noproblemAction:(id)sender
{
    NSString *is_needReport = @"0";
    NSString *WFStatus = @"-2";
    [self webActionWithResport:is_needReport withStatus:WFStatus];
    is_noProblem = YES;
}

//检查必填选项是否为空
- (BOOL)checkTextIsEmputy
{
    if (self.resultTextView.text.length == 0 || self.machineTextField.text.length == 0 || self.reasontextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"必填的选项不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return YES;
    } else {
        return NO;
    }
    
}

#pragma mark - webServerAction
- (void)webActionWithResport:(NSString *)is_needReport withStatus:(NSString *)WFStatus
{
    //没有问题上传数据
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    NSString *dateString = [NSString stringWithFormat:@"%d-%.2d-%.2d",SHAREAPP.remYear,SHAREAPP.remMonth,SHAREAPP.remDay];
    SegtonInstance *instance = [SegtonInstance sharedTheme];
    NSString *valueStr = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@$%@$%@$%@$%@",self.machineTextField.text,dateString,self.reasontextField.text,instance.idNum,instance.userName,self.resultTextView.text,self.processTextView.text,is_needReport,instance.idNum,WFStatus];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.timeOutSeconds = 30;
    [request setPostValue:@"insertCommonPatrol" forKey:@"t"];
    [request setPostValue:valueStr forKey:@"results"];
    //上传图片
    for (int i = 0; i < _imgArray.count; i++) {
        NSData *imgData = [_imgArray objectAtIndex:i];
        [request addData:imgData withFileName:@"image.jpg" andContentType:@"image/png" forKey:@"photo"];
    }
    if (!is_noProblem) {
        [SVProgressHUD showWithStatus:@"数据上传中.."];
    }
    [request startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        NSString *resString = request.responseString;
        NSData *data = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dic = [arr objectAtIndex:0];
        if ([dic objectForKey:@"parentId"]) {
            if (is_noProblem) {
                //表示没有问题的上报
                [self.navigationController popViewControllerAnimated:YES];
                is_noProblem = NO;
                [SVProgressHUD dismiss];
            }else
            {
                [SVProgressHUD dismissWithSuccess:@"上传成功"];
                //删除本次拍照的照片
                for (int i=0; i<_imgArray.count; i++) {
                    [[NSFileManager defaultManager] removeItemAtPath:[_imgArray objectAtIndex:i] error:nil];
                }
            }
        }
    }else{
        [SVProgressHUD dismissWithError:@"上传失败"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"上传失败"];
}

//取消键盘
- (IBAction)tapBackgroundAction:(id)sender
{
    
    [self.machineTextField resignFirstResponder];
    [self.reasontextField resignFirstResponder];
    [self.resultTextView resignFirstResponder];
    [self.processTextView resignFirstResponder];
}

@end
