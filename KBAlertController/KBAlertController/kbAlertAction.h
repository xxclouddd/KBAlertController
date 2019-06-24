//
//  kbAlertAction.h
//  kbAlertController
//
//  Created by 肖雄 on 16/2/22.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class kbAlertAction;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, kbAlertActionStyle) {
    kbAlertActionStyleDefault = 0,
    kbAlertActionStyleCancel,
    kbAlertActionStyleDestructive
};

typedef void(^kbAlertActionHandler)(kbAlertAction *action);

@interface kbAlertAction : NSObject

+ (nullable kbAlertAction *)actionWithTitle:(nullable NSString *)title style:(kbAlertActionStyle)style handle:(nullable kbAlertActionHandler)handle;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) kbAlertActionStyle style;
@property (nonatomic, copy) kbAlertActionHandler handle;

@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

NS_ASSUME_NONNULL_END
