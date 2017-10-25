//
//  kbCustomAlertController.h
//  kbAlertController
//
//  Created by 肖雄 on 16/2/19.
//  Copyright © 2016年 kuaibao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kbAlertAction.h"
#import <KBFormSheetController/KBFormSheetController.h>
@class kbCustomAlertController;

NS_ASSUME_NONNULL_BEGIN

@protocol kbCustomAlertControllerDelegate;
@interface kbCustomAlertController : UIViewController<KBAppearance>

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message;

- (void)addAction:(kbAlertAction *)action;

- (void)addString:(NSString *)string;
- (void)addAttributedString:(NSAttributedString *)attributedString;  // must be set NSFontAttributeName.

- (void)addView:(UIView *)view;
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

@property (nullable, nonatomic, copy) NSString *aTitle;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, assign) id<kbCustomAlertControllerDelegate> delegate;

@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nonatomic, assign) CGFloat width UI_APPEARANCE_SELECTOR;                // Default is 275.
@property (nonatomic, assign) CGFloat buttonHeight UI_APPEARANCE_SELECTOR;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin UI_APPEARANCE_SELECTOR;          // Default is 25.
@property (nonatomic, assign) CGFloat inputFieldHeight UI_APPEARANCE_SELECTOR;     // Default is 50.
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;         // Default is 5.

@property (nonatomic, assign) CGFloat titleFontSize UI_APPEARANCE_SELECTOR;        // Default is 18.
@property (nonatomic, assign) CGFloat detailFontSize UI_APPEARANCE_SELECTOR;       // Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize UI_APPEARANCE_SELECTOR;       // Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *detailColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *splitColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *actionBackgroundNormalColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *actionBackgroundHighlightColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *actionTitleNormalColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *actionTitleDestructiveColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *actionTitleDisableColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) UIEdgeInsets titleInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets buttonInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets contentInsets UI_APPEARANCE_SELECTOR;
@property (nullable, nonatomic, strong) NSArray <NSValue *> *contentViewSubInsets;

@property (nonatomic, strong) NSString *defaultTitle UI_APPEARANCE_SELECTOR;

@property (nullable, nonatomic, copy) NSString *identifier;

@end

@protocol kbCustomAlertControllerDelegate <NSObject>
@optional
- (void)customAlertController:(kbCustomAlertController *)controller clickedButtonAtIndex:(NSInteger)buttonIndex;
- (BOOL)customAlertController:(kbCustomAlertController *)controller willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)customAlertController:(kbCustomAlertController *)controller didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end


NS_ASSUME_NONNULL_END
