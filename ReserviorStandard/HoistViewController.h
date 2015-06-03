//
//  HoistViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-23.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "CustomIOS7AlertView.h"
#import "ASIHTTPRequest.h"
#import "CustomView.h"
#import "TakePhotoViewController.h"

@interface HoistViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NIDropDownDelegate,CustomIOS7AlertViewDelegate,ASIHTTPRequestDelegate,takePhotoDelegate,UITextViewDelegate>
{
    NIDropDown *_dropDown;
    NSMutableArray *_contentArray;
    NSMutableArray *listArray; // 选择部位的数据
    int selectedIndex; //被选中的number
    NSMutableArray *fileArray; //要被保存在本地的数组
    NSMutableArray *_imgArray;
}
@property  kHoistType type; //启闭机的类型
@property (weak, nonatomic) IBOutlet UITextField *numerIDTextField;
@property (weak, nonatomic) IBOutlet UITableView *myTableVIew;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) IBOutlet UIButton *partButoon;
@property (weak, nonatomic) IBOutlet CustomView *bgView;


- (IBAction)uploadProblemAction:(id)sender;

- (IBAction)tapBackground:(id)sender;

- (IBAction)selectedPartAction:(id)sender;

@end
