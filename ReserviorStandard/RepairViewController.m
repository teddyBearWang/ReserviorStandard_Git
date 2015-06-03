//
//  RepairViewController.m
//  ReserviorStandard
// ********************维修表单**********************
//  Created by teddy on 14-10-30.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "RepairViewController.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "ReportedListViewController.h"

@interface RepairViewController ()

@end

@implementation RepairViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"维修表";
        _instance = [SegtonInstance sharedTheme];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //隐藏返回按钮
    [self.navigationController.navigationItem setHidesBackButton:YES];
    if (!_instance.isFirst) {
        //获取已有的信息
        [self getPreviousInfoAction];
        _ischeck = YES;
    }
}

- (void)getPreviousInfoAction{
    
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"GetCommonMaintenance" forKey:@"t"];
    [request setPostValue:self.common_id forKey:@"results"];
    request.delegate = self;
    [SVProgressHUD showWithStatus:@"加载中.."];
    [request startAsynchronous];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    //在Xib文件中使用autoLayout之后，ScrollView的contentSize需要在此方法中修改
    [self setViewFrame];
    self.bgView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
}

- (void)setViewFrame
{
    self.bgView.frame = (CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT};
    self.bgView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.8);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib

    UIBarButtonItem *takePhoto = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhotoAction)];
    self.navigationItem.rightBarButtonItem = takePhoto;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgViewAction:)];
    tap.numberOfTapsRequired = 1;
    [self.bgView addGestureRecognizer:tap];
    
    [self.comfirmBtn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    self.otherTextField.delegate = self;
    self.acceptTimeField.delegate = self;
    self.acceptTimeField.tag = 202;
    self.repairTimeField.delegate = self;
    self.repairTimeField.tag = 201;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)takePhotoAction
{
    TakePhotoViewController *takePhotoCtrl = [[TakePhotoViewController alloc] init];
    takePhotoCtrl.delegate = self;
    [self.navigationController pushViewController:takePhotoCtrl animated:YES];
}
#pragma mark - TakePhotoDelegate
- (void)takePhotoWithArray:(NSMutableArray *)array
{
    _imgArray = [NSMutableArray arrayWithArray:array];
}

#pragma mark - UItextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self viewUpMoveAction];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self viewDownMoveAction];
}

#pragma mark - UItextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 201 || textField.tag == 202) {
        [self createTimeAction];
        _clickIndex = textField.tag;
    }
    return YES;
}

- (void)createTimeAction
{
    [self tapBgViewAction:nil];
    CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc] init];
    [alert setContainerView:[self createView]];
    alert.delegate = self;
    [alert setButtonTitles:@[@"确定",@"取消"]];
    [alert show];
}

- (UIView *)createView
{
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    picker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*10];
    picker.maximumDate = [NSDate date];
    picker.date = [NSDate dateWithTimeIntervalSinceNow:0];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    picker.locale = locale;
    return picker;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   // [self viewUpMoveAction];
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    //[self viewDownMoveAction];
}

- (void)viewUpMoveAction
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.bgView.frame = (CGRect){0,-150,SCREEN_WIDTH,SCREEN_HEIGHT};
    [UIView commitAnimations];
}

- (void)viewDownMoveAction
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.bgView.frame = (CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT};
    [UIView commitAnimations];
}

#pragma mark - CustomIOS7AlertViewDelegate
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CustomIOS7AlertView *alert = (CustomIOS7AlertView *)alertView;
        UIDatePicker *picker = (UIDatePicker *)alert.containerView;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        NSDate *date = picker.date;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *enddate = [NSString stringWithFormat:@"%d-%.2d-%.2d %.2d:%.2d",[components year],[components month],[components day],[components hour],[components minute]];
        switch (_clickIndex) {
            case 201:
                self.repairTimeField.text = enddate;
                break;
            case 202:
                self.acceptTimeField.text = enddate;
                break;
            default:
                break;
        }
    }
    [alertView close];
}

#pragma mark - private Method
//维护单更新
- (void)updateAction:(id)sender
{
    //更新维护单
    if (_instance.isFirst) {
        [self uploadDateToWebServerAction:@"insertCommonMaintenance"];
    } else {
        [self uploadDateToWebServerAction:@"updateCommonMaintenance"];
    }
    _isUpload = YES;
}

//完成维护
- (void)comfirmAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您是否已经解决了所有隐患,完成维护" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self uploadDateToWebServerAction:@"updateCommonMaintenance2"];

    }
}

//网络服务
- (void)uploadDateToWebServerAction:(NSString *)status
{
    //上传维修记录
    NSString *dateStr = [NSString stringWithFormat:@"%d-%.2d-%.2d",SHAREAPP.remYear,SHAREAPP.remMonth,SHAREAPP.remDay];
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:status forKey:@"t"];
    request.delegate = self;
    NSString *valueStr = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@$%@",self.common_id,dateStr,self.weatherField.text,self.machineNameField.text,self.parameterField.text,self.reasonField.text,self.contentField.text,self.processField.text,self.problemField.text,self.repairUnitField.text,self.repairPeronField.text,self.repairTimeField.text,self.acceptUnitField.text,self.acceptPersonField.text,self.acceptTimeField.text,self.otherTextField.text];;
    if (!_instance.isFirst) {
        //更新
       valueStr = [NSString stringWithFormat:@"%@$%@$%@",_updateID,valueStr,_updateImgUrl];
    } 
    //图片
    for (int i = 0; i < _imgArray.count; i++) {
        NSData *imgData = [[NSData alloc] initWithContentsOfFile:[_imgArray objectAtIndex:i]];
        [request addData:imgData withFileName:@"image.jpg" andContentType:@"image/png" forKey:@"photo"];
    }
    [request setPostValue:valueStr forKey:@"results"];
    [SVProgressHUD showWithStatus:@"数据上传中.."];
    [request startAsynchronous];
}

//取消键盘
- (void)tapBgViewAction:(UIGestureRecognizer *)gesture
{
    [self.machineNameField resignFirstResponder];
    [self.parameterField resignFirstResponder];
    [self.reasonField resignFirstResponder];
    [self.contentField resignFirstResponder];
    [self.processField resignFirstResponder];
    [self.problemField resignFirstResponder];
    [self.repairPeronField resignFirstResponder];
    [self.repairTimeField resignFirstResponder];
    [self.repairUnitField resignFirstResponder];
    [self.acceptPersonField resignFirstResponder];
    [self.acceptTimeField resignFirstResponder];
    [self.acceptUnitField resignFirstResponder];
    [self.otherTextField resignFirstResponder];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        NSString *resString = request.responseString;
        NSData *data = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dic = [arr objectAtIndex:0];
        //加载
        if (_ischeck) {
            [SVProgressHUD dismiss];
            _updateID = [dic objectForKey:@"Id"];
            _updateImgUrl = [dic objectForKey:@"imgurl"];
            self.weatherField.text = [dic objectForKey:@"Weather"];
            self.machineNameField.text = [dic objectForKey:@"EquipmentName"];
            self.parameterField.text = [dic objectForKey:@"MainParameter"];
            self.reasonField.text = [dic objectForKey:@"MaintenanceReason"];
            self.contentField.text = [dic objectForKey:@"WorkContent"];
            self.processField.text = [dic objectForKey:@"WorkPerformance"];
            self.problemField.text = [dic objectForKey:@"LeftoverProblem"];
            self.repairUnitField.text = [dic objectForKey:@"MaintenanceUnit"];
            self.repairPeronField.text = [dic objectForKey:@"MaintenanceUserName"];
            self.repairTimeField.text = [dic objectForKey:@"MaintenanceTime"];
            self.acceptUnitField.text = [dic objectForKey:@"AcceptanceUnit"];
            self.acceptPersonField.text = [dic objectForKey:@"AcceptanceUserName"];
            self.acceptTimeField.text = [dic objectForKey:@"AcceptanceTime"];
            self.otherTextField.text = [dic objectForKey:@"Content"];
            _ischeck = NO;
            return;
        }
        
        if ([[dic objectForKey:@"success"] isEqualToString:@"True"]) {
           // 删除照片
            for (int i=0; i<_imgArray.count; i++) {
                [[NSFileManager defaultManager] removeItemAtPath:[_imgArray objectAtIndex:i] error:nil];
            }
            [SVProgressHUD dismissWithError:@"上传成功"];
            [self popAction];
        } else {
            [SVProgressHUD dismissWithError:@"上传失败"];
        }
    } else {
        [SVProgressHUD dismissWithError:@"上传失败"];
    }
}

- (void)popAction
{
    //返回到上报列表
    NSArray *arr = self.navigationController.viewControllers;
    for (UIViewController *temVc in arr) {
        if ([temVc isKindOfClass:[ReportedListViewController class]]) {
            [[self.navigationController popToViewController:temVc animated:YES] lastObject];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"上传失败"];
}
@end
