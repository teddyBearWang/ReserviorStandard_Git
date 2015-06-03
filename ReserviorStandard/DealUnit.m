//
//  DealUnit.m
//  ReserviorStandard
//
//  Created by teddy on 14-11-26.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "DealUnit.h"

@implementation DealUnit



//照片方向纠正
+ (UIImage *)fixOrientation:(UIImage *)img
{
    if (img.imageOrientation == UIImageOrientationUp) {
        return img;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (img.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, img.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (img.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformScale(transform,-1,1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, img.size.height, 0);
            transform = CGAffineTransformScale(transform,1,-1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationLeft:
        case UIImageOrientationDown:
        case UIImageOrientationRight:
            break;
    }
    
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, img.size.width, img.size.height, CGImageGetBitsPerComponent(img.CGImage), 0, CGImageGetColorSpace(img.CGImage), CGImageGetBitmapInfo(img.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (img.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, img.size.height, img.size.width), img.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, img.size.width, img.size.height), img.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return image;
}

//检查版本更新
- (NSString *)checkVersionAction:(NSString *)message
{
    
    return nil;
}


@end
