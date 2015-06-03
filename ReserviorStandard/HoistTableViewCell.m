//
//  HoistTableViewCell.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-28.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "HoistTableViewCell.h"

@implementation HoistTableViewCell
@synthesize contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initlayout];
    }
    return self;
}

- (void)initlayout
{
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 260, 40)];
    self.contentLabel.backgroundColor = [UIColor clearColor]; ;
    self.contentLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.contentLabel];
}

- (void)setIntroductionText:(NSString *)text
{
    CGRect frame = self.frame;
    
    self.contentLabel.text = text;
    //设置最大行数
    self.contentLabel.numberOfLines = 0;
    CGSize size = CGSizeMake(260, 1000);
    CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, labelSize.width, labelSize.height);
    frame.size.height = labelSize.height;
    self.frame = frame;
    
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
*/
@end
