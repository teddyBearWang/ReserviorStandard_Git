//
//  LoginViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-24.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"


@interface LoginViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UITextField *_userField;
    UITextField *_passwordField;
    UIButton *_loginBtn;
    BOOL _isChecked;  //检查更新
    NSString *_downloadUrl; //下载地址

}

@property (weak, nonatomic) IBOutlet UIImageView *logImageView;
@property (nonatomic, strong) IBOutlet UITextField *userField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *rememberbtn;
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet UIImageView *separateView;


- (IBAction)forgotPwdAction:(id)sender;
- (IBAction)tapBackgroundAction:(id)sender;
@end
