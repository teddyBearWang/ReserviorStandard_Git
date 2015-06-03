//
//  DynamicScrollView.m
//  MeltaDemo
//
//  Created by hejiangshan on 14-8-27.
//  Copyright (c) 2014年 hejiangshan. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "DynamicScrollView.h"

#define kSlectedImageNotification @"selectImageNotification"
#define kDeletedImageNotification @"deletedImageNotification"

@implementation DynamicScrollView
{
    float width;
    float height;
    NSMutableArray *imageViews;
    float singleWidth;
    BOOL isDeleting;
    CGPoint startPoint;
    CGPoint originPoint;
    BOOL isContain;
}

@synthesize scrollView,imageViews,isDeleting;

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        UIScreen *screen = [UIScreen mainScreen];
        width = screen.bounds.size.width;
        height = screen.bounds.size.height;
        imageViews = [NSMutableArray arrayWithCapacity:images.count];//存放文件地址
        self.filePathArray = images; //存放image文件地址数组
        singleWidth = width/4; //每张图片的宽度
        //创建底部滑动视图
        [self _initScrollView];
        [self _initViews];
    }
    return self;
}

- (void)_initScrollView
{
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
    }
}

- (void)_initViews
{
    for (int i = 0; i < self.filePathArray.count; i++) {
         UIImage *img = [self fileDataChangeImage:self.filePathArray[i]];
        [self createImageViews:i withImageName:img];
    }
    self.scrollView.contentSize = CGSizeMake(self.filePathArray.count * singleWidth, self.scrollView.frame.size.height);
}

//创建ImageVIew
- (void)createImageViews:(int)i withImageName:(UIImage *)image
{
    //[self.images addObject:imageName];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.frame = CGRectMake(singleWidth*i, 0, singleWidth, self.scrollView.frame.size.height);
    imgView.userInteractionEnabled = YES;
    [self.scrollView addSubview:imgView];
    [imageViews addObject:imgView];
    
  //  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
   // [imgView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedImageViewAction:)];
    tap.numberOfTapsRequired = 1;
    [imgView addGestureRecognizer:tap];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    /*
    if (isDeleting) {
        [deleteButton setHidden:NO];
    } else {
        [deleteButton setHidden:YES];
    }
     */
    deleteButton.frame = CGRectMake(0, 0, 25, 25);
    deleteButton.backgroundColor = [UIColor clearColor];
    [imgView addSubview:deleteButton];
}

//长按调用的方法
/*
- (void)longAction:(UILongPressGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {//长按开始
        startPoint = [recognizer locationInView:recognizer.view];
        originPoint = imageView.center;
        isDeleting = !isDeleting;
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
        for (UIImageView *imageView in imageViews) {
            UIButton *deleteButton = (UIButton *)imageView.subviews[0];
            if (isDeleting) {
                deleteButton.hidden = NO;
            } else {
                deleteButton.hidden = YES;
            }
        }
    }
 
    else if (recognizer.state == UIGestureRecognizerStateChanged) {//长按移动
        CGPoint newPoint = [recognizer locationInView:recognizer.view];
        CGFloat deltaX = newPoint.x - startPoint.x;
        CGFloat deltaY = newPoint.y - startPoint.y;
        imageView.center = CGPointMake(imageView.center.x + deltaX, imageView.center.y + deltaY);
        NSInteger index = [self indexOfPoint:imageView.center withView:imageView];
        if (index < 0) {
            isContain = NO;
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint temp = CGPointZero;
                UIImageView *currentImagView = imageViews[index];
                int idx = [imageViews indexOfObject:imageView];
                temp = currentImagView.center;
                currentImagView.center = originPoint;
                imageView.center = temp;
                originPoint = imageView.center;
                isContain = YES;
                [imageViews exchangeObjectAtIndex:idx withObjectAtIndex:index];
            } completion:^(BOOL finished) {
            }];
        }
    }
     else if (recognizer.state == UIGestureRecognizerStateEnded) {//长按结束
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformIdentity;
            if (!isContain) {
                imageView.center = originPoint;
            }
        }];
    }
}
*/
//获取view在imageViews中的位置
- (NSInteger)indexOfPoint:(CGPoint)point withView:(UIView *)view
{
    UIImageView *originImageView = (UIImageView *)view;
    for (int i = 0; i < imageViews.count; i++) {
        UIImageView *otherImageView = imageViews[i];
        if (otherImageView != originImageView) {
            if (CGRectContainsPoint(otherImageView.frame, point)) {
                return i;
                NSLog(@"这个是第%d个位置",i);
            }
        }
    }
    return -1;
}

- (void)selectedImageViewAction:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    int index = [imageViews indexOfObject:imageView];
    
    NSString *filePath = [self.filePathArray objectAtIndex:index];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSlectedImageNotification object:filePath userInfo:nil];
}

- (void)deleteAction:(UIButton *)button
{
    UIImageView *imageView = (UIImageView *)button.superview;
    __block int index = [imageViews indexOfObject:imageView];
    __block CGRect rect = imageView.frame;
    __weak UIScrollView *weakScroll = scrollView;
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = index + 1; i < imageViews.count; i++) {
                UIImageView *otherImageView = imageViews[i];
                CGRect originRect = otherImageView.frame;
                otherImageView.frame = rect;
                rect = originRect;
            }
        } completion:^(BOOL finished) {
            [imageViews removeObject:imageView];
            if (imageViews.count > 4) {
                weakScroll.contentSize = CGSizeMake(singleWidth*imageViews.count, scrollView.frame.size.height);
            }
        }];
    }];
    NSString *filepath = [self.filePathArray objectAtIndex:index];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filepath]) {
        //删除本地
        BOOL isOk = [fileManager removeItemAtPath:filepath error:nil];
        if (isOk) {
             [self.filePathArray removeObjectAtIndex:index];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeletedImageNotification object:self.filePathArray];
        }
    }
}

//添加一个新图片
- (void)addImageView:(NSString *)imagePath
{
    [self.filePathArray addObject:imagePath];
    UIImage *image = [self fileDataChangeImage:imagePath]; //获取图片
    [self createImageViews:(int)imageViews.count withImageName:image];
    
    self.scrollView.contentSize = CGSizeMake(singleWidth*imageViews.count, self.scrollView.frame.size.height);
    if (imageViews.count > 4) {
        [self.scrollView setContentOffset:CGPointMake((imageViews.count-4)*singleWidth, 0) animated:YES];
    }
}

- (UIImage *)fileDataChangeImage:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:data];
        return image;
    } else {
        return nil;
    }
}

@end
