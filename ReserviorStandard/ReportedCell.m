//
//  ReportedCell.m
//  ReserviorStandard
//
//  Created by teddy on 14-11-20.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "ReportedCell.h"

@implementation ReportedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.dangerLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.dangerLabel.layer.borderWidth = 0.5f;
        self.dangerLabel.layer.borderColor = [UIColor blackColor].CGColor;
        self.contentLabel.layer.borderWidth = 0.5f;
        self.contentLabel.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return self;
}

//- (void)awakeFromNib
//{
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
