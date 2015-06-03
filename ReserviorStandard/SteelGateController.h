//
//  SteelGateController.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-28.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "ASIHTTPRequest.h"
#import "CustomView.h"
#import "TakePhotoViewController.h"


@interface SteelGateController : UIViewController<NIDropDownDelegate,ASIHTTPRequestDelegate,UITextViewDelegate,takePhotoDelegate>
{
    NIDropDown *_dropDown;
    NSMutableArray *_listArray;
    NSMutableArray *_valueArray;
    NSString *_type; //表示不同的闸门
    int _selectedIndex; //表示选择的index
    NSMutableArray * _imgArray;
}

@property enum kGateType gateType;
@property (strong, nonatomic) IBOutlet UITextField *capacityTextField;
@property (strong, nonatomic) IBOutlet UITextField *wheatherTextField;

@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@property (strong, nonatomic) IBOutlet UITextField *numberIDTextField;

@property (strong, nonatomic) IBOutlet UIButton *selectedBtn;

@property (strong, nonatomic) IBOutlet UIButton *uploadProblemAction;
@property (weak, nonatomic) IBOutlet CustomView *bgView1;
@property (weak, nonatomic) IBOutlet UIImageView *separateView1;
@property (weak, nonatomic) IBOutlet UIImageView *separateView2;
@property (weak, nonatomic) IBOutlet UIImageView *separateView;
@property (weak, nonatomic) IBOutlet CustomView *bgView2;



- (IBAction)selectedContentAction:(id)sender;
- (IBAction)tapBackgroundAction:(id)sender;
- (IBAction)uploadPreoblemAction:(id)sender;

@end
