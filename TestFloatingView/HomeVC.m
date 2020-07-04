//
//  HomeVC.m
//  TestFloatingView
//
//  Created by ZD on 2020/7/3.
//  Copyright © 2020 ZD. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnOne = [self getBtnWithTitle:@"HomeVC" positionY:100 withAction:@selector(btnClick)];
    [self.view addSubview:btnOne];
}

- (UIButton *)getBtnWithTitle: (NSString *)title positionY: (CGFloat) positionY withAction:(SEL)selector {
    CGRect ScreenFrame = [UIScreen mainScreen].bounds;
    CGFloat ScreenWidth = ScreenFrame.size.width;
    CGFloat ScreenHeight = ScreenFrame.size.height;
    CGFloat margin = 10;
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(10, positionY, ScreenWidth - 2 * margin, 40);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:(UIControlEventTouchUpInside)];
    btn.backgroundColor = [UIColor orangeColor];
    return btn;
}

- (void)btnClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSLog(@"keyWindow:\n%@",window);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%s: %s", __FILE__, __func__);
    [self.view becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"%s: %s", __FILE__, __func__);
    [self.view resignFirstResponder];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (UIEventSubtypeMotionShake ==motion) {
        NSLog(@"The view is shake.");
    }
}

@end
