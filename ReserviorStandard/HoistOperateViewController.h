//
//  HoistOperateViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-29.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "CustomDateActionSheet.h"
#import "CustomTextField.h"
#import "NIDropDown.h"

@interface HoistOperateViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate,UIActionSheetDelegate,NIDropDownDelegate>
{
    int _clickIndex;
    NIDropDown *_dropDown;
    NSArray *listArr;
    BOOL _isState; //检查是否为正常的判断
}
@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView; //背景滑动视图
@property (strong, nonatomic) IBOutlet CustomTextField *hoistNumtextField; //闸门编号

@property (strong, nonatomic) IBOutlet CustomTextField *startTimeTextField; //开启时间
@property (strong, nonatomic) IBOutlet CustomTextField *endTimeTextField; //关闭时间
@property (weak, nonatomic) IBOutlet UIButton *stateBtn; //是否正常
@property (weak, nonatomic) IBOutlet UIButton *gateTypeBtn; //闸门类型


@property (strong, nonatomic) IBOutlet CustomTextField *openIngTextField; //启闭开度

@property (strong, nonatomic) IBOutlet CustomTextField *orderTextField; //发令人

@property (strong, nonatomic) IBOutlet CustomTextField *operatetextField; //操作员

@property (strong, nonatomic) IBOutlet CustomTextField *reserviorLeveltextField; //水库水位
@property (strong, nonatomic) IBOutlet CustomTextField *downStreamLevelField; //下游水位
@property (strong, nonatomic) IBOutlet CustomTextField *trafficTextField; //出闸流量
@end
