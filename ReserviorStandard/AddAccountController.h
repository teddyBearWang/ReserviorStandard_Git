//
//  AddAccountController.h
//  ReserviorStandard
//
//  Created by teddy on 14-11-19.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "ASIHTTPRequest.h"


@interface AddAccountController : UIViewController<ASIHTTPRequestDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *loginIDField;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet CustomTextField *loginPswField;
@property (weak, nonatomic) IBOutlet UINavigationBar *myNavigationBar;
- (IBAction)cancelAction:(id)sender;
- (IBAction)addAccountAction:(id)sender;

- (IBAction)tapBackGroundAction:(id)sender;
@end
