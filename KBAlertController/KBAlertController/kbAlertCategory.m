//
//  kbAlertCategory.m
//  kbAlertController
//
//  Created by 肖雄 on 16/2/22.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "kbAlertCategory.h"

@implementation UIImage (kbAlertCategory)

+ (UIImage *) kb_imageWithColor:(UIColor *)color {
    return [UIImage kb_imageWithColor:color Size:CGSizeMake(1, 1)];
}

+ (UIImage *) kb_imageWithColor:(UIColor *)color Size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
