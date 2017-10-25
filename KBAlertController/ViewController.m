//
//  ViewController.m
//  KBAlertController
//
//  Created by 肖雄 on 17/3/2.
//  Copyright © 2017年 kuaibao. All rights reserved.
//

#import "ViewController.h"
#import "kbAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    kbCustomAlertController *con = [[kbCustomAlertController alloc] initWithTitle:@"title" message:nil];
    
    [con addAttributedString:[[NSAttributedString alloc] initWithString:@"abc" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor redColor]}]];
    
    [con addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"placeholder";
    }];

    [con addAttributedString:[[NSAttributedString alloc] initWithString:@"shdkjfjalsdwerqwrqwerqwekfjkasfasldfajsfasdkf" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor redColor]}]];

    kbAlertAction *cancel = [kbAlertAction actionWithTitle:@"取消" style:kbAlertActionStyleDefault handle:nil];
    kbAlertAction *confirm = [kbAlertAction actionWithTitle:@"取消" style:kbAlertActionStyleDefault handle:nil];
    [con addAction:cancel];
    [con addAction:confirm];

    NSArray *array = @[[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, -15, 0)], [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero], [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, -10, 0)]];
    con.contentViewSubInsets = array;
    
    kbAlertController *alert =[kbAlertController alertControllerWithController:con];
    
    [self kb_presentFormSheetController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
