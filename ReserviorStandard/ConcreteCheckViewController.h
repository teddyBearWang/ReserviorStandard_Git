//
//  ConcreteCheckViewController.h
//  ReserviorStandard
// **********************混凝土坝检查记录表********************
//  Created by teddy on 14-10-22.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "RTLabel.h"
#import "RSButton.h"
#import "CustomDateActionSheet.h"
#import "TakePhotoViewController.h"

@interface ConcreteCheckViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate,UIActionSheetDelegate,takePhotoDelegate>
{
    NIDropDown *dropDown;
    NSArray *_areaArray; //检查部位
    NSArray *_contentArray;//检查内容
    UITableView *_tableView; //显示有问题的位置
    NSMutableArray *_problemArray; //  存放有问题的位置
    
    NSString *_lastArea;
    NSString *_lastContent;
    int _type; //；类型 1:表示部位；2:表示内容
    NSString *_ParentId; //主表ID
    int _partID; //部位ID
    int _itemID; //位置ID
    NSString *_weather; //天气
    NSString *_temperture; //温度
    UITextField *dateField; //时间选择
    NSMutableArray *_imgArray;//接受图片
    BOOL _isPhoto;
    
}

@property (nonatomic, strong) NSString *parentID;//主表

@property (nonatomic, strong)IBOutlet UITableView *tableView;
@property (nonatomic, strong)IBOutlet RTLabel *areaLable;
@property (nonatomic, strong)IBOutlet UIButton *areaBtn;
@property (nonatomic, strong)IBOutlet RTLabel *contentLabel;
@property (nonatomic, strong)IBOutlet UIButton *contentBtn;
@property (nonatomic, strong)IBOutlet RSButton *havaProblemBtn;

@property (weak, nonatomic) IBOutlet RSButton *comfirmBtn;

- (IBAction)tapBackgroundAction:(id)sender;

@end
