//
//  RepairViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-30.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "CustomIOS7AlertView.h"
#import "CustomTextField.h"
#import "TakePhotoViewController.h"
#import "SegtonInstance.h"

@interface RepairViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,ASIHTTPRequestDelegate,CustomIOS7AlertViewDelegate,UIAlertViewDelegate,takePhotoDelegate>
{
    int _clickIndex; //确定是哪一个时间
    NSMutableArray *_imgArray; //保存图片的数组
    BOOL _ischeck; //表示事前检查
    BOOL _isUpload;//上传服务
   // BOOL _isUpdate; //表示更新维护单
    NSString *_updateID;//更新上报的ID
    NSString *_updateImgUrl;//更新上报的imgUrl
   // BOOL _isUpdateStatus; //更新上报状态
    SegtonInstance *_instance;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgView;
@property (weak, nonatomic) IBOutlet CustomTextField *weatherField;

@property (weak, nonatomic) IBOutlet CustomTextField *machineNameField;
@property (weak, nonatomic) IBOutlet CustomTextField *parameterField;
@property (weak, nonatomic) IBOutlet UITextView *reasonField;
@property (weak, nonatomic) IBOutlet UITextView *contentField;
@property (weak, nonatomic) IBOutlet UITextView *processField;
@property (weak, nonatomic) IBOutlet UITextView *problemField;
@property (weak, nonatomic) IBOutlet CustomTextField *repairUnitField;
@property (weak, nonatomic) IBOutlet CustomTextField *acceptUnitField;

@property (weak, nonatomic) IBOutlet CustomTextField *repairPeronField;
@property (weak, nonatomic) IBOutlet CustomTextField *acceptPersonField;
@property (weak, nonatomic) IBOutlet CustomTextField *repairTimeField;
@property (weak, nonatomic) IBOutlet CustomTextField *acceptTimeField;
@property (weak, nonatomic) IBOutlet UITextView *otherTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;

@property (nonatomic, strong) NSString *common_id;


@end
