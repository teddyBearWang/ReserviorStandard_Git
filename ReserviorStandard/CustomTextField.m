//
//  CustomTextField.m
//  ReserviorStandard
//
//  Created by teddy on 14-11-12.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.borderStyle = UITextBorderStyleNone;
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.clearsOnBeginEditing = YES;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//垂直居中
        self.font = [UIFont boldSystemFontOfSize:17];
        self.keyboardAppearance = UIKeyboardAppearanceLight;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.borderStyle = UITextBorderStyleNone;
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.clearsOnBeginEditing = YES;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//垂直居中
        self.font = [UIFont boldSystemFontOfSize:17];
        self.keyboardAppearance = UIKeyboardAppearanceLight;
    }
    return self;
}
@end
