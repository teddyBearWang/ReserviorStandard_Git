//
//  DynamicScrollView.h
//  MeltaDemo
//
//  Created by hejiangshan on 14-8-27.
//  Copyright (c) 2014年 hejiangshan. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface DynamicScrollView : UIView

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images;

@property(nonatomic,retain)UIScrollView *scrollView;

//@property(nonatomic,retain)NSMutableArray *images; //存放图片的数组

@property(nonatomic,retain)NSMutableArray *imageViews; //存放ImageView的数组
@property (nonatomic,strong) NSMutableArray *filePathArray; //存在image文件地址数组

@property(nonatomic,assign)BOOL isDeleting;

//添加一个新图片
- (void)addImageView:(NSString *)imagePath;

@end
