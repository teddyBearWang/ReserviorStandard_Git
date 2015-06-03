//
//  ReportedCell.h
//  ReserviorStandard
//
//  Created by teddy on 14-11-20.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface ReportedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RTLabel *timeLabel;
@property (weak, nonatomic) IBOutlet RTLabel *areaLabel;
@property (weak, nonatomic) IBOutlet RTLabel *hoistNumlabel;
@property (weak, nonatomic) IBOutlet UILabel *checkpersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordPersonlabel;

@property (weak, nonatomic) IBOutlet UITextView *contentLabel;
@property (weak, nonatomic) IBOutlet UITextView *dangerLabel;

@end
