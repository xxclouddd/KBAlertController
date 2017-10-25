//
//  kbAlertController.m
//  kbAlertController
//
//  Created by 肖雄 on 16/2/19.
//  Copyright © 2016年 kuaibao. All rights reserved.
//

#import "kbAlertController.h"
#import "kbAlertTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface kbAlertController ()

@end

@implementation kbAlertController

#pragma mark - life circle
+ (instancetype)alertControllerWithController:(kbCustomAlertController *)controller
{
    kbAlertController *alertController = [[kbAlertController alloc] initWithSize:controller.view.frame.size viewController:controller];
    [KBTransition registerTransitionClass:[kbAlertTransition class] forTransitionStyle:KBFormSheetPresentationTransitionStyleCustom];
    alertController.transitionStyle = KBFormSheetPresentationTransitionStyleCustom;
    alertController.movementWhenKeyboardAppears = KBFormSheetWhenKeyboardAppearsCenterVertically;
    alertController.shouldDismissOnBackgroundViewTap = NO;
    return alertController;
}

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message actions:(nullable NSArray<kbAlertAction *> *)acions
{
    kbCustomAlertController *childCon = [[kbCustomAlertController alloc] initWithTitle:title message:message];
    for (kbAlertAction *action in acions) {
        [childCon addAction:action];
    }
    return [kbAlertController alertControllerWithController:childCon];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.    
}

#pragma mark - setter and getter
- (nullable UIViewController *)controller
{
    return self.presentedFSViewController;
}

@end

NS_ASSUME_NONNULL_END
