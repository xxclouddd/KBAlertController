//
//  kbAlertAction.m
//  kbAlertController
//
//  Created by 肖雄 on 16/2/22.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "kbAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface kbAlertAction ()

@property (nullable, nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) kbAlertActionStyle style;

@end

@implementation kbAlertAction

+ (nullable kbAlertAction *)actionWithTitle:(nullable NSString *)title style:(kbAlertActionStyle)style handle:(nullable kbAlertActionHandler)handle
{
    kbAlertAction *instance = [[kbAlertAction alloc] init];
    if (instance) {
        instance.title = title;
        instance.style = style;
        instance.handle = handle;
    }
    return instance;
}

@end

NS_ASSUME_NONNULL_END
