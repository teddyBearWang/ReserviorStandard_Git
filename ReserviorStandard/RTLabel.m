//
//  RTLabel.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-23.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "RTLabel.h"

@implementation RTLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
