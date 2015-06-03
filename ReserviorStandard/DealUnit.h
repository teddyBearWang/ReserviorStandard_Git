//
//  DealUnit.h
//  ReserviorStandard
//  **********一个工具类************
//  Created by teddy on 14-11-26.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface DealUnit : NSObject<ASIHTTPRequestDelegate>

//纠正照片的方向
+ (UIImage *)fixOrientation:(UIImage *)img;

//检查版本更新
- (NSString *)checkVersionAction:(NSString *)message;
@end
