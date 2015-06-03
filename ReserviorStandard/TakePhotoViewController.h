//
//  TakePhotoViewController.h
//  ReserviorStandard
//
//  Created by teddy on 14-11-17.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicScrollView.h"
#import "SegtonInstance.h"

@protocol takePhotoDelegate <NSObject>

- (void)takePhotoWithArray:(NSMutableArray *)array;

@end

@interface TakePhotoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    int totalWidth;
  //  NSMutableArray *_imageArray; //储存图片
    NSMutableArray *_filePathArray; //储存图片地址
    SegtonInstance *instance;
}

@property (nonatomic, strong) id<takePhotoDelegate>delegate;
//@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSMutableArray *filePathArray;
@property (strong, nonatomic)  IBOutlet UIButton *takePhotobtn;
//@property (weak, nonatomic) IBOutlet UIButton *deleteImgBtn;

@property (strong, nonatomic)  DynamicScrollView *showImageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *scranerImageView;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;

@end
