//
//  PrePareViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-11-13.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "ASIHTTPRequest.h"


@interface PrePareViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate,UIActionSheetDelegate>
{
    NSString *_ParentId; //主表ID

}
@property (weak, nonatomic) IBOutlet CustomTextField *dateTimeField;
@property (weak, nonatomic) IBOutlet CustomTextField *weatherField;
@property (weak, nonatomic) IBOutlet CustomTextField *tempertureField;
@property (weak, nonatomic) IBOutlet CustomTextField *checkField;
@property (weak, nonatomic) IBOutlet CustomTextField *orderField;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

- (IBAction)tapBgView:(id)sender;

@end
