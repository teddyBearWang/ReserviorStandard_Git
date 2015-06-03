//
//  CustomCell.h
//  ReserviorStandard
//
//  Created by teddy on 14-10-23.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface CustomCell : UITableViewCell
{
    RTLabel *_areaLabel;
    RTLabel *_contentLabel;
}
@property (strong, nonatomic)  RTLabel *areaLabel;
@property (strong, nonatomic)  RTLabel *contentLabel;

@end
