//
//  TakePhotoViewController.m
//  ReserviorStandard
//******************拍多张照片*****************
//  Created by teddy on 14-11-17.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "AppDelegate.h"
#import "DealUnit.h"
#define kSlectedImageNotification @"selectImageNotification"
#define kDeletedImageNotification @"deletedImageNotification"

@interface TakePhotoViewController ()

@end

@implementation TakePhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"拍照";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    instance = [SegtonInstance sharedTheme];
    self.filePathArray = [NSMutableArray arrayWithArray:instance.imageArr];
    
    /*
     for (int i=0; i<instance.imageArr.count; i++) {
     NSData *data = [[NSData alloc] initWithContentsOfFile:[instance.imageArr objectAtIndex:i]];
     UIImage *img = [UIImage imageWithData:data];
     [self.imageArray addObject:img];
     }
     */
    
     //[self refreshShowImgViewAction];
  
    self.showImageScrollView = [[DynamicScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 80) withImages:[self.filePathArray mutableCopy]];
    /*
    //self.showImageScrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //self.showImageScrollView.layer.borderWidth = 1.0f;
   // self.showImageScrollView.contentSize = CGSizeMake(320, 80);
     */
    [self.view addSubview:self.showImageScrollView];
    /*
    self.takePhotobtn = [RSButton buttonWithType:UIButtonTypeCustom];
    self.takePhotobtn.frame = (CGRect){20,10,60,60};
    totalWidth = self.takePhotobtn.frame.size.width + self.takePhotobtn.frame.origin.x;
    [self.takePhotobtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    [self.showImageScrollView addSubview:self.takePhotobtn];
    */
    [self.takePhotobtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    [self.takePhotobtn addTarget:self action:@selector(addView) forControlEvents:UIControlEventTouchUpInside];
    
    self.scranerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.scranerImageView.image = [UIImage imageNamed:@"NoPicture"];
    
    //[self.deleteImgBtn addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
    //self.deleteImgBtn.hidden = YES;
    [self.comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    [self.comfirmBtn addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImageAction:) name:kSlectedImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImageAction:) name:kDeletedImageNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private action

- (void)addView
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //检查是否支持拍照
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持拍照功能" delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.sourceType = UIImagePickerControllerSourceTypeCamera;
    pick.allowsEditing = YES;
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:NULL];
}

- (void)showImageAction:(NSNotification *)notification
{
    NSString *filePath = (NSString *)notification.object;
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    self.scranerImageView.image = [UIImage imageWithData:data];
}

- (void)deleteImageAction:(NSNotification *)notification
{
    instance.imageArr = (NSMutableArray *)notification.object;
    self.filePathArray = instance.imageArr;
    
}
//在scrollView上面添加一张缩略图
/*
- (void)addImageAction:(UIImage *)image
{
    CGRect rect = self.takePhotobtn.frame;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapImageViewAction:)];
    imgView.userInteractionEnabled = YES;
    tap.numberOfTapsRequired = 1;
    [imgView addGestureRecognizer:tap];
    //出现了问题
    count = count +1;
    imgView.tag = count;
    imgView.image = image;
    float w = rect.origin.x + 80;
    rect.origin.x = w;
    self.takePhotobtn.frame = rect;
    totalWidth = totalWidth + 80;
    if (totalWidth > 320 ) {
        [self.showImageScrollView setContentSize:CGSizeMake(totalWidth, 80)];
    }
    [self.showImageScrollView addSubview:imgView];
}
 */

//刷新显示图片的scrollView
/*
- (void)refreshShowImgViewAction
{
    
    for (UIView *view in self.showImageScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.imageArray.count != 0) {
        //存在图片
        for (int i =0; i<self.imageArray.count + 1; i++) {
            if (i == self.imageArray.count) {
                [self.showImageScrollView setContentSize:CGSizeMake((20*(i + 1) + 60 * i), 80)];
                //添加按钮
                self.takePhotobtn = [RSButton buttonWithType:UIButtonTypeCustom];
                [self.takePhotobtn addTarget:self action:@selector(addView) forControlEvents:UIControlEventTouchUpInside];
                [self.takePhotobtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
                self.takePhotobtn.frame = (CGRect){(20*(i + 1) + 60 * i),10,60,60};
                [self.showImageScrollView addSubview:self.takePhotobtn];
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){20*(i + 1) + 60 * i,10,60,60}];
                imageView.image = [UIImage imageWithData:[self.imageArray objectAtIndex:i]];
                imageView.tag = i + 1;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapImageViewAction:)];
                imageView.userInteractionEnabled = YES;
                tap.numberOfTapsRequired = 1;
                [imageView addGestureRecognizer:tap];
                [self.showImageScrollView addSubview:imageView];
            }
        }
    } else {
        //若是为空
        [self.showImageScrollView setContentSize:CGSizeMake(320, 80)];
        //添加按钮
        self.takePhotobtn = [RSButton buttonWithType:UIButtonTypeCustom];
        [self.takePhotobtn addTarget:self action:@selector(addView) forControlEvents:UIControlEventTouchUpInside];
        [self.takePhotobtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        self.takePhotobtn.frame = (CGRect){20,10,60,60};
        [self.showImageScrollView addSubview:self.takePhotobtn];
    }
}
*/

/*
//点击图片
- (void)TapImageViewAction:(UIGestureRecognizer *)gesture
{
    int number = (int)gesture.view.tag;
   // self.deleteImgBtn.tag = number-1; // 传递这个参数
   // self.deleteImgBtn.hidden = NO;
    self.scranerImageView.image = [UIImage imageWithData:[self.imageArray objectAtIndex:(number - 1)]];
}
*/

//删除照片
/*
- (void)deleteImageAction:(UIButton *)btn
{
 
    if (btn.tag == 0) {
        //删除的是第一张
        self.scranerImageView.image = [UIImage imageWithData:[self.imageArray objectAtIndex:1]];
    } else if (btn.tag == self.imageArray.count){
        //删除的时最后一张
        self.scranerImageView.image = [UIImage imageWithData:[self.imageArray objectAtIndex:(self.imageArray.count - 1-1)]];
    } else{
        //删除的时中间的
        self.scranerImageView.image = [UIImage imageWithData:[self.imageArray objectAtIndex:(btn.tag + 1)]];
    }
 
    //删除照片
    [self.imageArray removeObjectAtIndex:btn.tag];
    self.scranerImageView.image = [UIImage imageNamed:@"NoPicture"];
    self.deleteImgBtn.hidden = YES;
    //刷新
    [self refreshShowImgViewAction];
   
}
*/


//确定
- (void)comfirmAction
{
    [self.delegate takePhotoWithArray:self.filePathArray]; //传出的时保存图片的路劲数组
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getFilePath:(NSString *)fileName
{
    NSString *doucment = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath = [doucment stringByAppendingPathComponent:fileName];
    NSFileManager *fileMan = [NSFileManager defaultManager];
    BOOL isSecs = [fileMan fileExistsAtPath:fileName];
    if (isSecs) {
        [fileMan removeItemAtPath:fileName error:nil];
    }
    return filepath;
}

#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [DealUnit fixOrientation:img];
    self.scranerImageView.image = image;
    NSData *imgData = UIImagePNGRepresentation(image);
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [formatter stringFromDate:nowDate];
    NSString *filePath = [self getFilePath:[NSString stringWithFormat:@"%@.png",date]];
    if ([imgData writeToFile:filePath atomically:YES]) {
        [self.filePathArray addObject:filePath]; //存放的地址
        instance.imageArr = self.filePathArray; //保存起来
        [self.showImageScrollView addImageView:filePath];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
