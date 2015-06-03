//
//  RSButton.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-23.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "RSButton.h"

@implementation RSButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0f;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return self;
}

//从Xib文件进来初始化
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.backgroundColor = [UIColor lightGrayColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return self;
}

@end
