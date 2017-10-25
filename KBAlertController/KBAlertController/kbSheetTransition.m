//
//  kbSheetTransition.m
//  KuaiDiYuan_S
//
//  Created by 肖雄 on 16/4/13.
//  Copyright © 2016年 KuaidiHelp. All rights reserved.
//

#import "kbSheetTransition.h"
#import <KBFormSheetController/KBFormSheetController.h>

@implementation kbSheetTransition

- (void)entryFormSheetControllerTransition:(KBFormSheetController *)formSheetController completionHandler:(void (^)())completionHandler
{
    CGRect formSheetRect = formSheetController.presentedFSViewController.view.frame;
    formSheetRect.origin.y = [UIScreen mainScreen].bounds.size.height;
    formSheetController.presentedFSViewController.view.frame = formSheetRect;
    CGRect toRect = CGRectMake(formSheetRect.origin.x,
                               [UIScreen mainScreen].bounds.size.height - formSheetRect.size.height,
                               formSheetRect.size.width,
                               formSheetRect.size.height);
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         formSheetController.presentedFSViewController.view.frame = toRect;
                     } completion:^(BOOL finished) {
                         completionHandler();
                     }];
}

- (void)exitFormSheetControllerTransition:(KBFormSheetController *)formSheetController completionHandler:(void (^)())completionHandler
{
    CGRect formSheetRect = formSheetController.presentedFSViewController.view.frame;
    formSheetRect.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         formSheetController.presentedFSViewController.view.frame = formSheetRect;
                     }
                     completion:^(BOOL finished) {
                         completionHandler();
                     }];
}


@end
