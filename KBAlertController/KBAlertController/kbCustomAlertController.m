//
//  kbCustomAlertController.m
//  kbAlertController
//
//  Created by 肖雄 on 16/2/19.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import "kbCustomAlertController.h"
#import <objc/runtime.h>
#import "kbAlertCategory.h"

#define kb_button_split_width  (1/[UIScreen mainScreen].scale)

NS_ASSUME_NONNULL_BEGIN

static const char* kb_alertController_actionAssociateButton = "kb_alertController_actionAssociateButton";
static const char* kb_alertController_inputFieldDefaultStyle = "kb_alertController_inputFieldDefaultStyle";
static const char* kb_alertController_detailLabelDefaultStyle = "kb_alertController_detailLabelDefaultStyle";

CGFloat const kbCustomAlertControllerDefaultWidth = 275;
CGFloat const kbCustomAlertControllerDefaultButtonHeight = 44;
CGFloat const kbCustomAlertControllerDefaultInnerMargin = 20;
CGFloat const kbCustomAlertControllerDefaultInputFieldHeight = 44;
CGFloat const kbCustomAlertControllerDefaultCornerRadius = 4.0;

CGFloat const kbCustomAlertControllerDefaultTitleFontSize = 18;
CGFloat const kbCustomAlertControllerDefaultDetailFontSize = 15;
CGFloat const kbCustomAlertControllerDefaultButtonFontSize = 16;


@interface kbCustomAlertController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *contentView;

@property (nullable, nonatomic, strong) NSAttributedString *attributedTitle;
@property (nullable, nonatomic, strong) NSAttributedString *attributedDetail;

@property (nonatomic, strong) NSMutableArray <kbAlertAction *> *actions;
@property (nonatomic, strong) NSMutableArray <UIView *> *views;
@property (nonatomic, strong) NSMutableArray <UITextField *> *p_textFields;

@end

@implementation kbCustomAlertController

#pragma mark - Appearance
+ (instancetype)appearance
{
    return [KBAppearance appearanceForClass:[self class]];
}

#pragma mark - life circle
+ (void)load
{
    @autoreleasepool {
        kbCustomAlertController *appearance = [self appearance];
        [appearance setWidth:kbCustomAlertControllerDefaultWidth];
        [appearance setButtonHeight:kbCustomAlertControllerDefaultButtonHeight];
        [appearance setInnerMargin:kbCustomAlertControllerDefaultInnerMargin];
        [appearance setInputFieldHeight:kbCustomAlertControllerDefaultInputFieldHeight];
        [appearance setCornerRadius:kbCustomAlertControllerDefaultCornerRadius];
        
        [appearance setTitleFontSize:kbCustomAlertControllerDefaultTitleFontSize];
        [appearance setDetailFontSize:kbCustomAlertControllerDefaultDetailFontSize];
        [appearance setButtonFontSize:kbCustomAlertControllerDefaultButtonFontSize];
        
        [appearance setBackgroundColor:[UIColor whiteColor]];
        [appearance setTitleColor:[UIColor colorWithRed:12/255.0 green:186/255.0 blue:160/255.0 alpha:1.0]];
        [appearance setDetailColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
        [appearance setSplitColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]];
        
        [appearance setActionBackgroundNormalColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
        [appearance setActionBackgroundHighlightColor:[UIColor whiteColor]];
        [appearance setActionTitleNormalColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        [appearance setActionTitleDestructiveColor:[UIColor redColor]];
        [appearance setActionTitleDisableColor:[UIColor lightGrayColor]];
        
        [appearance setTitleInsets:UIEdgeInsetsZero];
        [appearance setContentInsets:UIEdgeInsetsZero];
        [appearance setButtonInsets:UIEdgeInsetsZero];
        
        [appearance setDefaultTitle:@"提示"];
    }
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message
{
    self = [super init];
    if (self) {
        id appearance = [[self class] appearance];
        [appearance applyInvocationRecursivelyTo:self upToSuperClass:[kbCustomAlertController class]];
        
        self.aTitle = title ?: self.defaultTitle;
        self.message = message;
    }
    return self;
}

- (void)loadView
{
    UIView *view = [UIView new];
    view.backgroundColor = self.backgroundColor;
    
    if (self.aTitle) {
        self.titleLabel.text = self.aTitle;
        [view addSubview:self.titleLabel];
    }
    
    if (self.message) {
        [self addString:self.message];
    }
    
    [view addSubview:self.contentView];
    [view addSubview:self.buttonView];
    
    self.view = view;
    
    [self setupFrame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    for (kbAlertAction *action in self.actions) {
        [action removeObserver:self forKeyPath:@"enabled"];
    }
}

#pragma mark - response methods
- (void)actionButton:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(customAlertController:clickedButtonAtIndex:)]) {
        [self.delegate customAlertController:self clickedButtonAtIndex:index];
    }
    
    BOOL responseSelector = [self.delegate respondsToSelector:@selector(customAlertController:willDismissWithButtonIndex:)];
    if (!responseSelector || (responseSelector && [self.delegate customAlertController:self willDismissWithButtonIndex:index])) {
        if ([self.delegate respondsToSelector:@selector(customAlertController:didDismissWithButtonIndex:)]) {
            [self.delegate customAlertController:self didDismissWithButtonIndex:index];
        }
        
        [self.formSheetController.presentingFSViewController kb_dismissFormSheetControllerAnimated:YES completion:^{}];
    }
    
    if (index >= 0 && index < self.actions.count) {
        kbAlertAction *action = self.actions[index];
        if (action.handle) {
            action.handle(action);
        }
    }
}

#pragma mark - public mehtods
- (void)addAction:(kbAlertAction *)action
{
    NSParameterAssert(action);
    
    [self.actions addObject:action];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = [self.actions indexOfObject:action];
    [btn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:btn];
    
    objc_setAssociatedObject(action, kb_alertController_actionAssociateButton, btn, OBJC_ASSOCIATION_ASSIGN);
    [action addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self configureActionButtonWithAction:action];
    [self reloadFrameIfViewIsLoaded];
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField * _Nonnull))configurationHandler
{
    UITextField *field = [UITextField new];
    field.backgroundColor = self.backgroundColor;
    field.layer.borderWidth = kb_button_split_width;
    field.layer.borderColor = self.splitColor.CGColor;
    field.layer.cornerRadius = self.cornerRadius;
    field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    field.leftViewMode = UITextFieldViewModeAlways;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:field];
    
    objc_setAssociatedObject(field, kb_alertController_inputFieldDefaultStyle, @"kb_alertController_inputFieldDefaultStyle", OBJC_ASSOCIATION_ASSIGN);
    
    [self.views addObject:field];
    [self reloadFrameIfViewIsLoaded];
    
    [self.p_textFields addObject:field];
    
    configurationHandler ? configurationHandler(field) : nil;
}

- (void)addView:(UIView *)view
{
    NSParameterAssert(view);
    
    [self.contentView addSubview:view];
    
    [self.views addObject:view];
    [self reloadFrameIfViewIsLoaded];
}

- (void)addAttributedString:(NSAttributedString *)attributedString
{
    NSParameterAssert(attributedString);
    
    UILabel *label = [UILabel new];
    label.attributedText = attributedString;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    
    objc_setAssociatedObject(label, kb_alertController_detailLabelDefaultStyle, @"kb_alertController_detailLabelDefaultStyle", OBJC_ASSOCIATION_ASSIGN);
    
    [self.views addObject:label];
    [self reloadFrameIfViewIsLoaded];
}

- (void)addString:(NSString *)string
{
    NSParameterAssert(string);
    
    UILabel *label = [UILabel new];
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = self.detailColor;
    label.font = [UIFont systemFontOfSize:self.detailFontSize];
    [self.contentView addSubview:label];
    
    objc_setAssociatedObject(label, kb_alertController_detailLabelDefaultStyle, @"kb_alertController_detailLabelDefaultStyle", OBJC_ASSOCIATION_ASSIGN);
    
    [self.views addObject:label];
    [self reloadFrameIfViewIsLoaded];
}

#pragma mark - private methods
- (void)reloadFrameIfViewIsLoaded
{
    if ([self isViewLoaded]) {
        [self setupFrame];
    }
}

- (void)reloadActions
{
    for (kbAlertAction *action in self.actions) {
        [self configureActionButtonWithAction:action];
    }
}

- (void)reloadInputFields
{
    for (UIView *view in self.views) {
        if (![view isKindOfClass:[UITextField class]]) continue;
        id result = objc_getAssociatedObject(view, kb_alertController_inputFieldDefaultStyle);
        if (result) {
            view.layer.cornerRadius = self.cornerRadius;
            view.layer.borderColor = self.splitColor.CGColor;
        }
    }
}

- (void)reloadDetailLabels
{
    for (UIView *view in self.views) {
        if (![view isKindOfClass:[UILabel class]]) continue;
        id result = objc_getAssociatedObject(view, kb_alertController_detailLabelDefaultStyle);
        if (result) {
            UILabel *label = (UILabel *)view;
            label.textColor = self.detailColor;
        }
    }
}

- (void)setupFrame
{
    CGFloat top = self.innerMargin;
    
    // title
    if (self.aTitle) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:self.titleFontSize];
        self.titleLabel.frame = CGRectMake(0, 0, self.width-self.innerMargin*2, 0);
        [self.titleLabel sizeToFit];
        self.titleLabel.center = CGPointMake(self.width/2.0 + self.titleInsets.right - self.titleInsets.left,
                                             top + 5 + CGRectGetHeight(self.titleLabel.frame)/2.0 + self.titleInsets.bottom - self.titleInsets.top);
        
        top = CGRectGetMaxY(self.titleLabel.frame);
    }
    
    // content view
    UIView *lastView = nil;
    CGFloat contentViewHeight = 0;
    for (NSInteger i = 0; i < self.views.count; i ++) {
        UIView *view = self.views[i];
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if (i < self.contentViewSubInsets.count) {
            insets = [self.contentViewSubInsets[i] UIEdgeInsetsValue];
        }
        
        if ([view isKindOfClass:[UITextField class]]) {
            id result = objc_getAssociatedObject(view, kb_alertController_inputFieldDefaultStyle);
            if (result) {
                view.frame = CGRectMake(0, 0, self.width - 2*self.innerMargin, self.inputFieldHeight);
            }
        }
        else if ([view isKindOfClass:[UILabel class]]) {
            id result = objc_getAssociatedObject(view, kb_alertController_detailLabelDefaultStyle);
            if (result) {
                UILabel *label = (UILabel *)view;
                label.font = [UIFont systemFontOfSize:self.detailFontSize];
                label.frame = CGRectMake(0, 0, self.width-self.innerMargin*2 - 30, 0);
                [label sizeToFit];
            }
        }
        
        if (!lastView) {
            view.center = CGPointMake(self.width/2.0 + insets.right - insets.left,
                                      CGRectGetHeight(view.frame)/2.0 + insets.bottom - insets.top);
        } else {
            view.center = CGPointMake(self.width/2.0 + insets.right - insets.left,
                                      CGRectGetMaxY(lastView.frame) + CGRectGetHeight(view.frame)/2.0 + 15 + insets.bottom - insets.top);
        }
        
        lastView = view;
        contentViewHeight = CGRectGetMaxY(view.frame);
    }
    
    
    self.contentView.frame = CGRectMake(0, self.innerMargin + top - 5, self.width, contentViewHeight);
    top = CGRectGetMaxY(self.contentView.frame);
    
    
    // button view
    UIButton *lastButton = nil;
    CGFloat buttonViewHeight = 0;
    for ( NSInteger i = 0 ; i < self.actions.count; ++i )
    {
        kbAlertAction *item = self.actions[i];
        UIButton *btn = objc_getAssociatedObject(item, kb_alertController_actionAssociateButton);
        if (!btn) continue;
        
        if (self.actions.count == 2) {
            if (!lastButton) {
                btn.frame = CGRectMake(-kb_button_split_width, 0,
                                       (self.width)/2.0+1.5*kb_button_split_width, self.buttonHeight);
            } else {
                btn.frame = CGRectMake(CGRectGetMaxX(lastButton.frame)-kb_button_split_width, 0,
                                       CGRectGetWidth(lastButton.frame), self.buttonHeight);
            }
        } else {
            if (!lastButton) {
                btn.frame = CGRectMake(-kb_button_split_width, 0,
                                       self.width+2*kb_button_split_width, self.buttonHeight);
            } else {
                btn.frame = CGRectMake(-kb_button_split_width, CGRectGetMaxY(lastButton.frame)-kb_button_split_width,
                                       CGRectGetWidth(lastButton.frame), self.buttonHeight);
            }
        }
        
        lastButton = btn;
        buttonViewHeight = CGRectGetMaxY(lastButton.frame);
    }
    
    self.buttonView.frame = CGRectMake(0, self.innerMargin + top + self.buttonInsets.bottom - self.buttonInsets.top,
                                       self.width, buttonViewHeight);
    top = CGRectGetMaxY(self.buttonView.frame);
    
    self.view.frame = (CGRect) {self.view.frame.origin, CGSizeMake(self.width, top)};
}

- (void)configureActionButtonWithAction:(kbAlertAction *)action
{
    UIButton *btn = objc_getAssociatedObject(action, kb_alertController_actionAssociateButton);
    if (!btn) return;
    
    [btn setExclusiveTouch:YES];
    [btn setTitle:action.title forState:UIControlStateNormal];
    [btn setTitleColor:self.actionTitleNormalColor forState:UIControlStateNormal];
    [btn setTitleColor:self.actionTitleDisableColor forState:UIControlStateDisabled];
    if (action.style == kbAlertActionStyleDestructive) {
        [btn setTitleColor:self.actionTitleDestructiveColor forState:UIControlStateNormal];
    }
    [btn setBackgroundImage:[UIImage kb_imageWithColor:self.actionBackgroundNormalColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage kb_imageWithColor:self.actionBackgroundHighlightColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:self.buttonFontSize];
    btn.layer.borderWidth = kb_button_split_width;
    btn.layer.borderColor = self.splitColor.CGColor;
}

#pragma mark - observe
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context
{
    if ([object isKindOfClass:[kbAlertAction class]] && [keyPath isEqualToString:@"enabled"]) {
        UIButton *button = objc_getAssociatedObject(object, kb_alertController_actionAssociateButton);
        if (button) {
            button.enabled = [change[NSKeyValueChangeNewKey] boolValue];
        }
    }
}

#pragma mark - setter and getter
- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = self.titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)buttonView
{
    if (_buttonView == nil) {
        _buttonView = [UIView new];
    }
    return _buttonView;
}

- (NSMutableArray<kbAlertAction *> *)actions
{
    if (_actions == nil) {
        _actions = [NSMutableArray array];
    }
    return _actions;
}

- (NSMutableArray<UIView *> *)views
{
    if (_views == nil) {
        _views = [NSMutableArray array];
    }
    return _views;
}

- (NSMutableArray<UITextField *> *)p_textFields
{
    if (_p_textFields == nil) {
        _p_textFields = [NSMutableArray array];
    }
    return _p_textFields;
}

- (nullable NSArray<UITextField *> *)textFields
{
    if (_p_textFields) {
        return [_p_textFields copy];
    }
    return nil;
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    [self reloadFrameIfViewIsLoaded];
}

- (void)setButtonHeight:(CGFloat)buttonHeight
{
    _buttonHeight = buttonHeight;
    [self reloadFrameIfViewIsLoaded];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize
{
    _titleFontSize = titleFontSize;
    [self reloadFrameIfViewIsLoaded];
}

- (void)setDetailFontSize:(CGFloat)detailFontSize
{
    _detailFontSize = detailFontSize;
    [self reloadFrameIfViewIsLoaded];
}

- (void)setButtonFontSize:(CGFloat)buttonFontSize
{
    _buttonFontSize = buttonFontSize;
    [self reloadActions];
}

- (void)setInnerMargin:(CGFloat)innerMargin
{
    _innerMargin = innerMargin;
    [self reloadFrameIfViewIsLoaded];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    if ([self isViewLoaded]) {
        self.view.backgroundColor = backgroundColor;
    }
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    if (_titleLabel) {
        self.titleLabel.textColor = titleColor;
    }
}

- (void)setDetailColor:(UIColor *)detailColor
{
    _detailColor = detailColor;
    [self reloadDetailLabels];
}

- (void)setSplitColor:(UIColor *)splitColor
{
    _splitColor = splitColor;
    
    [self reloadInputFields];
    [self reloadActions];
}

- (void)setActionBackgroundHighlightColor:(UIColor *)actionBackgroundHighlightColor
{
    _actionBackgroundHighlightColor = actionBackgroundHighlightColor;
    [self reloadActions];
}

- (void)setActionBackgroundNormalColor:(UIColor *)actionBackgroundNormalColor
{
    _actionBackgroundNormalColor = actionBackgroundNormalColor;
    [self reloadActions];
}

- (void)setActionTitleNormalColor:(UIColor *)actionTitleNormalColor
{
    _actionTitleNormalColor = actionTitleNormalColor;
    [self reloadActions];
}

- (void)setActionTitleDestructiveColor:(UIColor *)actionTitleDestructiveColor
{
    _actionTitleDestructiveColor = actionTitleDestructiveColor;
    [self reloadActions];
}

- (void)setActionTitleDisableColor:(UIColor *)actionTitleDisableColor
{
    _actionTitleDisableColor = actionTitleDisableColor;
    [self reloadActions];
}

- (void)setTitleInsets:(UIEdgeInsets)titleInsets
{
    _titleInsets = titleInsets;
    [self reloadFrameIfViewIsLoaded];
}

- (void)setButtonInsets:(UIEdgeInsets)buttonInsets
{
    _buttonInsets = buttonInsets;
    [self reloadFrameIfViewIsLoaded];
}

- (void)setContentViewSubInsets:(nullable NSArray<NSValue *> *)contentViewSubInsets
{
    _contentViewSubInsets = contentViewSubInsets;
    [self reloadFrameIfViewIsLoaded];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    _contentInsets = contentInsets;
    [self reloadFrameIfViewIsLoaded];
}

- (void)setInputFieldHeight:(CGFloat)inputFieldHeight
{
    _inputFieldHeight = inputFieldHeight;
    [self reloadFrameIfViewIsLoaded];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self reloadInputFields];
}


@end

NS_ASSUME_NONNULL_END
