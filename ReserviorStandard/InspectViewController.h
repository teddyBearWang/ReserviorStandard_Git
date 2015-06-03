//
//  InspectViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-30.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "TakePhotoViewController.h"

@interface InspectViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate,ASIHTTPRequestDelegate,takePhotoDelegate>
{
    BOOL is_noProblem;
    NSMutableArray *_imgArray;//结束图片数据
    BOOL _isMoved; //是否移动过
}

@property (weak, nonatomic) IBOutlet UITextField *machineTextField;
@property (weak, nonatomic) IBOutlet UITextField *reasontextField;
@property (weak, nonatomic) IBOutlet UITextView *processTextView; //问题处理

@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *OKBtn;

- (IBAction)uploadProblemAction:(id)sender;
- (IBAction)noproblemAction:(id)sender;

- (IBAction)tapBackgroundAction:(id)sender;

@end
