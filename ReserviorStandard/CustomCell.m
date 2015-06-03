//
//  CustomCell.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-23.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize areaLabel;
@synthesize contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame =  (CGRect){0,0,280, 44};
        [self addView];
    }
    return self;
}

- (void)addView
{
    self.backgroundColor = [UIColor colorWithRed:209/255.0 green:236/255.0 blue:255/255.0 alpha:1.0f];
    self.areaLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.areaLabel];
    
    self.contentLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.contentLabel];
    
}

- (void)layoutSubviews
{
    self.areaLabel.frame = (CGRect){7,12,80,20};
    self.contentLabel.frame = (CGRect){90,12,80,20};
}

@end
