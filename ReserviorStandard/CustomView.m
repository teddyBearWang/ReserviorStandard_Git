//
//  CustomView.m
//  ReserviorStandard
//
//  Created by teddy on 14-11-12.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.0f;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1.0f].CGColor;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
