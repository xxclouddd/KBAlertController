//
//  kbAlertController.h
//  kbAlertController
//
//  Created by 肖雄 on 16/2/19.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <KBFormSheetController/KBFormSheetController.h>
#import "kbCustomAlertController.h"
@protocol kbAlertControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface kbAlertController : KBFormSheetController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                                 actions:(nullable NSArray <kbAlertAction *> *)acions;

+ (instancetype)alertControllerWithController:(kbCustomAlertController *)controller;

@property (nullable, nonatomic, readonly) UIViewController *controller;

@end

@protocol kbAlertControllerDelegate <NSObject>
@optional
- (BOOL)alertController:(kbAlertController *)controller willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)aAlertController:(kbAlertController *)controller didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END
