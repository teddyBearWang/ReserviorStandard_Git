//
//  CustomReportCell.m
//  ReserviorStandard
//
//  Created by teddy on 14-11-6.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "CustomReportCell.h"

#define ROW_WIDTH 280
@implementation CustomReportCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.stateLabel = [[RTLabel alloc] initWithFrame:(CGRect){(ROW_WIDTH - 80)-10, 10, 80, (44-10*2)}];
        [self.contentView addSubview:self.stateLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
