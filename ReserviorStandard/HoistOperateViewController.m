//
//  HoistOperateViewController.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-29.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "HoistOperateViewController.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "SegtonInstance.h"

@interface HoistOperateViewController ()
{
    SegtonInstance *_instance;
}

@end

@implementation HoistOperateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"闸门启闭操作记录";
        _instance = [SegtonInstance sharedTheme];
       
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.bgScrollView.frame = (CGRect){0,0 ,SCREEN_WIDTH,SCREEN_HEIGHT};
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.2);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0f];
    
    self.bgScrollView.userInteractionEnabled = YES;
    //添加单机手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackbroundAction:)];
    tap.numberOfTapsRequired = 1;
    [self.bgScrollView addGestureRecognizer:tap];
    
    self.startTimeTextField.delegate = self;
    self.endTimeTextField.delegate = self;
    self.orderTextField.delegate = self;
    self.operatetextField.delegate = self;
    self.reserviorLeveltextField.delegate = self;
    self.downStreamLevelField.delegate = self;
    self.trafficTextField.delegate = self;
    
    [self.stateBtn addTarget:self action:@selector(selectedMachineSituateAction:) forControlEvents:UIControlEventTouchUpInside];
    self.stateBtn.tag = 2001;
    [self.gateTypeBtn addTarget:self action:@selector(selectedMachineSituateAction:) forControlEvents:UIControlEventTouchUpInside];
    self.gateTypeBtn.tag = 2002;
    
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.frame = (CGRect){(SCREEN_WIDTH - self.trafficTextField.frame.size.width)/2,self.trafficTextField.frame.origin.y + 30 + self.trafficTextField.frame.size.height,self.trafficTextField.frame.size.width,self.trafficTextField.frame.size.height-10};
    uploadBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    uploadBtn.layer.borderWidth = 1.0f;
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    [uploadBtn setTitle:@"情况上传" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadStationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:uploadBtn];
    
    if (_instance.WaterLevel.length != 0) {
        self.reserviorLeveltextField.text = _instance.WaterLevel;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1002 || textField.tag == 1003) {
        [self keyBoardCancel];
        CustomDateActionSheet *action = [[CustomDateActionSheet alloc] initWithTitle:@"请选择时间" delegate:self];
        action.tag = 500;
        [action showInView:self.view];
        return YES;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag >= 1006) {
        //上移150个像素
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.bgScrollView.frame = (CGRect){0,-170,SCREEN_WIDTH,SCREEN_HEIGHT};
        [UIView commitAnimations];
    }
    if (textField.tag == 1002 || textField.tag == 1003) {
        [self.view endEditing:YES];//不弹出键盘
        _clickIndex = (int)textField.tag; //判断是哪个时间
    }
}
#pragma mark - actions
- (void)selectedMachineSituateAction:(id)sender
{
    [self tapBackbroundAction:nil];
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 2002) {
        listArr = @[@"大坝弧形钢闸门",@"一级电厂钢闸门",@"二级电厂钢闸门"];
        _isState = NO;
    } else {
        listArr = @[@"正常",@"不正常"];
        _isState = YES; //表示此事选择的时工作状态
    }
    CGRect rect = [btn.superview convertRect:btn.frame toView:self.view];
    float height = rect.origin.y+rect.size.height;
    if (_dropDown == nil) {
        CGFloat f = 30 * listArr.count;
        //防止超出屏幕
        /*
        if ((f + height) > SCREEN_HEIGHT - height ) {
            f = SCREEN_HEIGHT - height - 100;
        }
         */
        _dropDown = [[NIDropDown alloc] showDropDown:btn :&f :listArr :rect];
        [self.view addSubview:_dropDown];
        _dropDown.delegate = self;
    } else {
        [_dropDown hideDropDown:btn];
        _dropDown.delegate = self;
        [self rel];
    }
}

- (void)rel
{
    _dropDown = nil;
}

#pragma mark -DropDownDelegateMethod
- (void) niDropDownDelegateMethod: (int) sender
{
    [self rel];
    if (_isState) {
          self.stateBtn.titleLabel.text = [listArr objectAtIndex:sender];
    } else {
        self.gateTypeBtn.titleLabel.text = [listArr objectAtIndex:sender];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CustomDateActionSheet *custom = (CustomDateActionSheet *)actionSheet;
    if (custom.Index == 1) {
        switch (_clickIndex) {
            case 1002:
                //开启时间
                self.startTimeTextField.text = custom.selectedTime.time;
                break;
            case 1003:
                //关闭时间
                self.endTimeTextField.text = custom.selectedTime.time;
                break;
            default:
                break;
        }
    }
}

#pragma mark - private Action
- (void)tapBackbroundAction:(UIGestureRecognizer *)gesture
{
    //将scrollView下移
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.bgScrollView.frame = (CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT};
    [UIView commitAnimations];
    
    [self keyBoardCancel];
}

//点击背景取消键盘
- (void)keyBoardCancel
{
    CustomDateActionSheet *date = (CustomDateActionSheet *)[self.view viewWithTag:500];
    [date cancelAction:nil];
    [self.hoistNumtextField resignFirstResponder];
    [self.startTimeTextField resignFirstResponder];
    [self.endTimeTextField resignFirstResponder];
    [self.openIngTextField resignFirstResponder];
    [self.orderTextField resignFirstResponder];
    [self.operatetextField resignFirstResponder];
    [self.reserviorLeveltextField resignFirstResponder];
    [self.downStreamLevelField resignFirstResponder];
    [self.trafficTextField resignFirstResponder];
}
- (void)uploadStationAction:(UIButton *)btn
{
    if ([self checkTextIsEmupty]) {
        return;
    }
    _instance.WaterLevel = self.reserviorLeveltextField.text;
    NSString *state = nil;
    NSURL *URL = [NSURL URLWithString:WEB_SERVER];
    if ([[self.stateBtn currentTitle] isEqualToString:@"正常"]) {
        state = @"1";
    } else {
        state = @"0";
    }
    NSString *valueStr = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@$%@$%@$%@$%@",self.hoistNumtextField.text,self.startTimeTextField.text,self.endTimeTextField.text,self.openIngTextField.text,state,self.orderTextField.text,self.operatetextField.text,self.reserviorLeveltextField.text,self.downStreamLevelField.text,self.trafficTextField.text];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];\
    request.delegate = self;
    [request setPostValue:@"insertGateOperating" forKey:@"t"];
    [request setPostValue:valueStr forKey:@"results"];
    [SVProgressHUD showWithStatus:@"数据上传中.."];
    [request startAsynchronous];
}

- (BOOL)checkTextIsEmupty
{
    BOOL isempty;
    if (self.hoistNumtextField.text.length == 0 || self.startTimeTextField.text.length == 0 || self.endTimeTextField.text.length == 0 || self.openIngTextField.text.length == 0 || self.orderTextField.text.length == 0 || self.operatetextField.text.length == 0 || self.reserviorLeveltextField.text.length == 0 || self.downStreamLevelField.text.length == 0 || self.trafficTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"所填的选项不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        isempty = YES;
    }else{
        isempty = NO;
    }
    return isempty;
}

- (void)clearContentAction
{
    //清空
    self.hoistNumtextField.text = nil;
    self.startTimeTextField.text = nil;
    self.endTimeTextField.text = nil;
    self.openIngTextField.text = nil;
    self.orderTextField.text = nil;
    self.operatetextField.text = nil;
    self.reserviorLeveltextField.text = nil;
    self.downStreamLevelField.text = nil;
    self.trafficTextField.text = nil;
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
            [SVProgressHUD dismissWithSuccess:@"上传成功.."];
            [self clearContentAction];
        }else {
            [SVProgressHUD dismissWithError:@"上传失败"];
        }
    }else{
        [SVProgressHUD dismissWithError:@"上传失败"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"上传出错"];
}
@end
