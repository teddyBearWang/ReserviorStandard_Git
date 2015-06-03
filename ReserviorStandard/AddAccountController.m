//
//  AddAccountController.m
//  ReserviorStandard
//
//  Created by teddy on 14-11-19.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "AddAccountController.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "UserObject.h"
#import "SegtonInstance.h"

@interface AddAccountController ()

@end

@implementation AddAccountController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgView.layer.borderWidth = 1.0f;
    self.bgView.layer.borderColor = [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1.0f].CGColor;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.myNavigationBar.barTintColor = [UIColor colorWithRed:103/255.0 green:188/255.0 blue:223/255.0 alpha:1.0];
        self.myNavigationBar.tintColor = [UIColor whiteColor];
        self.myNavigationBar.translucent = NO;
    } else {
        self.myNavigationBar.tintColor = [UIColor colorWithRed:103/255.0 green:188/255.0 blue:223/255.0 alpha:1.0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addAccountAction:(id)sender
{
    if (self.loginPswField.text.length == 0 || self.loginIDField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"账号或者密码不能为空" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //添加拍照
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        imgPicker.cameraDevice =UIImagePickerControllerCameraDeviceFront;
    }
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    [self presentViewController:imgPicker animated:YES completion:NULL];
}

- (void)AddLoginUserAction:(NSString *)image
{
    //添加
    NSString *value = [NSString stringWithFormat:@"%@$%@$iphone$%@",self.loginIDField.text,self.loginPswField.text,image];
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"Login" forKey:@"t"];
    [request setPostValue:value forKey:@"results"];
    [request setTimeOutSeconds:60];
    [SVProgressHUD show];
    [request startAsynchronous];
}

- (IBAction)tapBackGroundAction:(id)sender
{
    [self.loginIDField resignFirstResponder];
    [self.loginPswField resignFirstResponder];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *file = [self getImageFilePath];
    [data writeToFile:file atomically:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        //调用登陆服务
        [self AddLoginUserAction:file];
    }];
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
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        NSString *resString = request.responseString;
        NSData *data = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dic = [jsonArr objectAtIndex:0];
        SegtonInstance *instance = [SegtonInstance sharedTheme];
        if ([[dic objectForKey:@"success"] isEqualToString:@"true"]) {
            [SVProgressHUD dismissWithSuccess:@"添加成功"];
            UserObject *user = [[UserObject alloc] init];
            user.userName = [dic objectForKey:@"truename"];
            user.psw = [dic objectForKey:@"userid"];
            user.phoneNumber = [dic objectForKey:@"mobile"];
            user.isMark = NO;
            [instance.userArray addObject:user];
        } else {
            [SVProgressHUD dismissWithError:@"添加失败"];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            //删除照片
            NSString *file = [self getImageFilePath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
                [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
            }
        }];
    } else {
         [SVProgressHUD dismissWithError:@"添加失败"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"添加失败"];
}
@end
