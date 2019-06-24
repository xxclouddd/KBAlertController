//
//  kbAlertTransition.m
//  kbAlertController
//
//  Created by 肖雄 on 16/2/22.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "kbAlertTransition.h"

@implementation kbAlertTransition

- (void)entryFormSheetControllerTransition:(UIViewController *)formSheetController
                         completionHandler:(void(^)())completionHandler
{
    formSheetController.view.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
    formSheetController.view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         formSheetController.view.layer.transform = CATransform3DIdentity;
                         formSheetController.view.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         completionHandler();
                     }];
}

- (void)exitFormSheetControllerTransition:(UIViewController *)formSheetController
                        completionHandler:(void(^)())completionHandler
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         formSheetController.view.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         completionHandler();
                     }];
}

@end
