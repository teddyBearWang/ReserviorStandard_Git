//
//  LoginViewController.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-24.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "SegtonInstance.h"
#import "UserObject.h"
#import "DealUnit.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = @"登陆";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0f];
    self.separateView.backgroundColor = [UIColor colorWithRed:189/255.0 green:188/255.0 blue:189/255.0 alpha:1.0f];
    [self initMainView];
    
    [self checkVersionsAction];
}

//检查版本更新
- (void)checkVersionsAction
{
    _isChecked = YES;
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"selectVersion" forKey:@"t"];
    [request setPostValue:@"iphone" forKey:@"results"];
    [SVProgressHUD show];
    [request startAsynchronous];
}

- (void)initMainView
{
    self.logImageView.layer.cornerRadius = 50;
    self.logImageView.layer.masksToBounds = YES;
    self.logImageView.image = [UIImage imageNamed:@"icon_logo6"];
    self.userField.delegate = self;
    self.userField.font = [UIFont boldSystemFontOfSize:20];
    self.userField.layer.borderWidth = 0.1f;
    self.userField.layer.borderColor = [UIColor colorWithRed:189/255.0 green:188/255.0 blue:189/255.0 alpha:1.0f].CGColor;
    self.userField.autocapitalizationType = UITextAutocapitalizationTypeNone; //首字母不自动大写
    self.userField.placeholder = @"用户名";
    self.userField.leftViewMode = UITextFieldViewModeAlways;
    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0,0,40,40}];
    bgView.backgroundColor = [UIColor clearColor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:(CGRect){0,(40-30)/2,26,30}];
    imgView.image = [UIImage imageNamed:@"icon_id"];
    [bgView addSubview:imgView];
    self.userField.leftView = bgView;
    
    self.passwordField.delegate = self;
    self.passwordField.font = [UIFont boldSystemFontOfSize:20];
    self.passwordField.layer.borderWidth = 0.1f;
    self.passwordField.layer.borderColor = [UIColor colorWithRed:189/255.0 green:188/255.0 blue:189/255.0 alpha:1.0f].CGColor;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.placeholder = @"密码";
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    UIView *bgView2 = [[UIView alloc] initWithFrame:(CGRect){0,0,40,40}];
    bgView2.backgroundColor = [UIColor clearColor];
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:(CGRect){0,5,26,30}];
    imgView2.image = [UIImage imageNamed:@"icon_password"];
    [bgView2 addSubview:imgView2];
    self.passwordField.leftView = bgView2;
    
    NSArray *arr = [self readInfo];
    if (arr.count != 0) {
        self.userField.text = [arr objectAtIndex:0];
        self.passwordField.text = [arr objectAtIndex:1];
    }
    
    self.textBgView.layer.cornerRadius = 10.0f;
    self.textBgView.layer.masksToBounds = YES;
    self.textBgView.layer.borderColor = [UIColor colorWithRed:189/255.0 green:188/255.0 blue:189/255.0 alpha:1.0f].CGColor;
    self.textBgView.layer.borderWidth = 1.0f;
    
    self.loginBtn.layer.borderWidth = 1.0f;
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button_green_big"] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    
    self.rememberbtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.rememberbtn.layer.borderWidth = 0.8f;
    [self.rememberbtn setBackgroundImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
    [self.rememberbtn addTarget:self action:@selector(rememberPswAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginAction:(UIButton *)btn
{
    if (self.userField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.passwordField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"登录密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront; //调用前置摄像头
    }
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}

- (void)startWebServerAvtion:(NSString *)image
{
    NSURL *webUrl = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:webUrl];
    request.delegate = self;

    [request setPostValue:@"Login" forKey:@"t"];
    NSString *value = [NSString stringWithFormat:@"%@$%@$iphone$%@",self.userField.text,self.passwordField.text,image];
    [request setPostValue:value forKey:@"results"];
    [request setTimeOutSeconds:60];
    [SVProgressHUD showWithStatus:@"登录中..."];
    [request startAsynchronous];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [DealUnit fixOrientation:img];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *file = [self getImageFilePath];
    [data writeToFile:file atomically:YES];
    //确定之后开始调用服务
    [self startWebServerAvtion:file];

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)getImageFilePath
{
    NSString *filepaths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [filepaths stringByAppendingPathComponent:@"loginImg.jpg"];
    return file;
}

#pragma mark - ASIHTTPRequestDelegate Method
- (void)requestFinished:(ASIHTTPRequest *)request
{
   // NSString *resString1 = request.responseString;
    if (request.responseStatusCode == 200) {

        NSString *resString = request.responseString;
        NSData *jsondata = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *resDic = [jsonArray objectAtIndex:0];
        
        if (_isChecked) {
            [SVProgressHUD dismiss];
            //检查版本
            [self checkingVersionAction:jsonArray];
            _isChecked = NO;
            
        }else{
            
            [self loginingAction:resDic];
        }
    }
    else {
         [SVProgressHUD dismissWithError:@"登录失败"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"登录超时"];
}

//登陆过程
- (void)loginingAction:(NSDictionary *)resDic
{
    SegtonInstance *seg = [SegtonInstance sharedTheme];
    seg.userArray = [NSMutableArray array];
    if ([[resDic objectForKey:@"success"] isEqualToString:@"true"]) {
        [SVProgressHUD dismissWithSuccess:@"登录成功"];
        //处理数据的代码
        UserObject *user = [[UserObject alloc] init];
        user.userName = [resDic objectForKey:@"truename"]; //保存
        user.idNum = [resDic objectForKey:@"userid"];
        user.phoneNumber = [resDic objectForKey:@"mobile"];
        user.isMark = NO;
        //给单例初始化赋值
        seg.userName = user.userName;
        seg.idNum = user.idNum;
        seg.phoneNum = user.phoneNumber;
        //添加当前登陆的用户账号信息
        [seg.userArray addObject:user];
        
        //删除照片
        NSString *file = [self getImageFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
            [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        }
        
        MainViewController *mainctrl = [[MainViewController alloc] init];
        [self.navigationController pushViewController:mainctrl animated:YES];
        if (isRember) {
            [self saveInfoWithName:self.userField.text withPsw:self.passwordField.text];
        }
    } else {
        [SVProgressHUD dismissWithError:@"登录失败"];
        
    }
}

- (void)checkingVersionAction:(NSArray *)arr
{
    float getAppVer = 0;
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        getAppVer = [[dic objectForKey:@"AppVer"] floatValue];
        _downloadUrl = [dic objectForKey:@"DownloadUrl"];
    }
    if (getAppVer > [_AppVer floatValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您的软件有新的版本，是否要更新" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"不更新", nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //打开页面
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadUrl]];
    }
}

//记住密码
 BOOL isRember = YES;
- (void)rememberPswAction
{
    if (!isRember) {
        //表示记住密码
        [self.rememberbtn setBackgroundImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        isRember = YES;
    } else {
        //表示取消记住密码
        [self.rememberbtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        isRember = NO;
    }
}

//忘记密码
- (IBAction)forgotPwdAction:(id)sender
{
    
}

//取消记住密码
- (void)cancelInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:@"loginName"];
    [user setObject:nil forKey:@"loginPsw"];
    [user synchronize];
}

//本地同步
- (void)saveInfoWithName:(NSString *)name withPsw:(NSString *)psw
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:name forKey:@"loginName"];
    [user setObject:psw forKey:@"loginPsw"];
    [user synchronize];
}

//本地存取
- (NSArray *)readInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *name = [user objectForKey:@"loginName"];
    NSString *psw = [user objectForKey:@"loginPsw"];
    NSArray *arr = [NSArray arrayWithObjects:name,psw, nil];
    return arr;
}

- (IBAction)tapBackgroundAction:(id)sender
{
    [self.userField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
@end
