//
//  SteelGateController.m
//  ReserviorStandard
//  ***********大坝钢闸门**************
//  Created by teddy on 14-10-28.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "SteelGateController.h"
#import "ASIFormDataRequest.h"
#import "GateObject.h"
#import "AppDelegate.h"
#import "SegtonInstance.h"
#import "SVProgressHUD.h"
#import "ReportViewController.h"

@interface SteelGateController ()
{
    SegtonInstance *_instance;
}

@end

@implementation SteelGateController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //创建单列对象
        _instance = [SegtonInstance sharedTheme];
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
    
    //添加键盘取消的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardCancelAction:) name:UIKeyboardWillHideNotification object:nil];
    
    self.contentTextView.delegate = self;
    
    NSArray *arr = [NSArray array];
    if (self.gateType == kDamSteelGateType) {
        self.title = @"大坝钢闸门";
        _type = @"1";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DamSteelGate" ofType:@"plist"];
        arr = [[NSArray alloc] initWithContentsOfFile:path];
    } else if (self.gateType == kFirstPowerFlantType) {
        self.title = @"电厂一级";
        _type = @"2";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FirstPowerFlant" ofType:@"plist"];
        arr = [[NSArray alloc] initWithContentsOfFile:path];
    } else {
        self.title = @"电厂二级";
        _type = @"3";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SecondPowerFlant" ofType:@"plist"];
        arr = [[NSArray alloc] initWithContentsOfFile:path];
    }
    _listArray = [NSMutableArray arrayWithCapacity:arr.count];
    _valueArray = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSDictionary *dic in arr) {
        GateObject *gate = [[GateObject alloc] init];
        gate.name = [dic objectForKey:@"name"];
        gate.idNum = [dic objectForKey:@"id"];
        gate.state = [dic objectForKey:@"state"];
        [_listArray addObject:gate.name];
        [_valueArray addObject:gate];
    }
    
    [self initMainView];
    
    self.selectedBtn.titleLabel.text = [_listArray objectAtIndex:0];
    [self.uploadProblemAction setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    _selectedIndex = 0;
    self.contentTextView.scrollEnabled = YES;
    GateObject *gate = [_valueArray objectAtIndex:0];
    if (![gate.state isEqualToString:@"正常"]) {
        self.contentTextView.text = gate.state;
    }
    
    NSArray *array = @[@"拍照",@"已上报"];
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:array];
    segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    segCtrl.multipleTouchEnabled = NO;
    segCtrl.momentary = YES;
    segCtrl.apportionsSegmentWidthsByContent = YES;
    [segCtrl addTarget:self action:@selector(ReportedAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:segCtrl];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.wheatherTextField.text = _instance.weather;//初始化
    
    if (_instance.WaterLevel.length != 0) {
        self.capacityTextField.text = _instance.WaterLevel;
    }
}

- (void)initMainView
{
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0f];
    
    self.separateView1.backgroundColor = [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1.0f];
    self.separateView2.backgroundColor = [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1.0f];
    self.separateView.backgroundColor = [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1.0f];
}

//拍照
- (void)ReportedAction:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if (seg.selectedSegmentIndex == 0) {
        TakePhotoViewController *takeCtrl = [[TakePhotoViewController alloc] init];
        takeCtrl.delegate = self;
        [self.navigationController pushViewController:takeCtrl animated:YES];
    } else {
        ReportViewController *report = [[ReportViewController alloc] init];
        switch (self.gateType) {
            case kDamSteelGateType:
                report.reportedType = kDamGateReportedType;
                break;
            case kFirstPowerFlantType:
                report.reportedType = kFirstPowerGateReportedType;
                break;
            case kSecondPowerFlantType:
                report.reportedType = kSecondPowerGateReportedType;
                break;
        }
        [self.navigationController pushViewController:report animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - takePhotoDelegate
- (void)takePhotoWithArray:(NSMutableArray *)array
{
    _imgArray = [NSMutableArray arrayWithArray:array];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 80);
    [UIView commitAnimations];
}

#pragma mark - NSNotification method
- (void)keyBoardCancelAction:(NSNotification *)notification
{
    //键盘取消的通知
    if (self.contentTextView.text.length != 0) {
        GateObject *gete = [_valueArray objectAtIndex:_selectedIndex];
        gete.state = self.contentTextView.text;
        [_valueArray replaceObjectAtIndex:_selectedIndex withObject:gete]; //数组中替换掉原来的对象
    }
}

#pragma mark - private method
- (IBAction)selectedContentAction:(id)sender
{
    [self tapBackgroundAction:nil];//取消键盘
    self.contentTextView.userInteractionEnabled = NO; //出现选择的时候，textVIew是不可编辑的
    UIButton *btn = (UIButton *)sender;
    CGRect rect = [btn.superview convertRect:btn.frame toView:self.view];
    //btn.frame = rect;
    float height = rect.origin.y+rect.size.height;
    if (_dropDown == nil) {
        CGFloat f = 30*_listArray.count;
        //防止超出屏幕
        if ((f + height) > SCREEN_HEIGHT-height) {
            f = SCREEN_HEIGHT - height-100;
        }
        _dropDown = [[NIDropDown alloc]showDropDown:btn :&f :_listArray :(CGRect)rect];
        [self.view addSubview:_dropDown];
        _dropDown.delegate = self;
    }else{
        [_dropDown hideDropDown:btn];
        _dropDown.delegate = self;
        [self rel];
    }
}

- (void)rel
{
    _dropDown = nil;
}

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (int) sender
{
    self.contentTextView.userInteractionEnabled = YES;
    _selectedIndex = sender; //选择了第几个选项
    self.selectedBtn.titleLabel.text = [_listArray objectAtIndex:sender];
    GateObject *gate = [_valueArray objectAtIndex:sender];
    if ([gate.state rangeOfString:@"正常"].location == NSNotFound) {
        self.contentTextView.text = gate.state; //表示若已经标志则显示问题
    } else {
        self.contentTextView.text = @"正常"; //若是没有，则清空
    }
    [self rel];
}

- (IBAction)uploadPreoblemAction:(id)sender
{
    //将库水位保存在单例中
    _instance.WaterLevel = self.capacityTextField.text;
    if (self.numberIDTextField.text.length == 0 || self.capacityTextField.text.length == 0 || self.wheatherTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"要填的选项不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:_valueArray .count];
    for (GateObject *gate in _valueArray) {
        [arr addObject:gate.state];
    }
    //拼接字符串
    int total = (int)(19 - arr.count);
    for (int i=0; i<total; i++) {
        GateObject *gate = [[GateObject alloc] init];
        gate.state = @"正常";
        [arr addObject:gate.state];
    }
    
    NSString *str = [arr componentsJoinedByString:@"$"];
    NSString *dateString = [NSString stringWithFormat:@"%d-%.2d-%.2d",SHAREAPP.remYear,SHAREAPP.remMonth,SHAREAPP.remDay];
    NSString *valeStr = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@$%@$%@$%@$%@",dateString,_type,self.numberIDTextField.text,str,_instance.userName,_instance.userName,_instance.idNum,_instance.idNum,self.capacityTextField.text,self.wheatherTextField.text];
    
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"insertGateCheck" forKey:@"t"];
    [request setPostValue:valeStr forKey:@"results"];
    
    for (int i = 0; i < _imgArray.count; i++) {
        NSData *imgdata = [_imgArray objectAtIndex:i];
        [request addData:imgdata withFileName:@"image.jpg" andContentType:@"image/png" forKey:@"photo"];
    }
    [SVProgressHUD showWithStatus:@"上传中..."];
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
        if ([[dic objectForKey:@"success"] isEqualToString:@"True"]) {
            //上传成功
            [SVProgressHUD dismissWithSuccess:@"上传成功"];
            //删除本次拍照的照片
            for (int i=0; i<_imgArray.count; i++) {
                [[NSFileManager defaultManager] removeItemAtPath:[_imgArray objectAtIndex:i] error:nil];
            }
        } else {
            [SVProgressHUD dismissWithError:@"上传失败"];
        }
    } else {
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
    [self.numberIDTextField resignFirstResponder];
    [self.capacityTextField resignFirstResponder];
    [self.wheatherTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}
@end
