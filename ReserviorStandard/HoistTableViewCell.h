//
//  HoistTableViewCell.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-28.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HoistTableViewCell : UITableViewCell
{
    UILabel *_contenLabel;
}

@property (nonatomic, strong) UILabel *contentLabel;

- (void)setIntroductionText:(NSString *)text;

@end
