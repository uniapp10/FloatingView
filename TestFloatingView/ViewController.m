//
//  ViewController.m
//  TestFloatingView
//
//  Created by ZD on 2020/7/2.
//  Copyright © 2020 ZD. All rights reserved.
//

#import "ViewController.h"
#import "FloatingWindow.h"
#import "AlertVC.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, strong) FloatingWindow *floatingWindow;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWindow *dwindow = [UIApplication sharedApplication].delegate.window;
    NSLog(@"delegateWindow:\n%@", dwindow);
    
    [self getBtnWithTitle:@"Floating" positionY:100 withAction:@selector(btnClick)];
    
    [self getBtnWithTitle:@"CustomAlert" positionY:200 withAction:@selector(btnClick2)];
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
    [self.view addSubview:btn];
    return btn;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (UIEventSubtypeMotionShake ==motion) {
        NSLog(@"The view is shake.");
    }
}

- (void)btnClick {
    self.floatingWindow.hidden = false;
}

- (void)btnClick2 {
    AlertVC *alertVC = [AlertVC new];
    [alertVC show];
}

- (FloatingWindow *)floatingWindow {
    if (!_floatingWindow) {
        _floatingWindow = [[FloatingWindow alloc] initWithFrame:CGRectMake(100, 300, 58, 58)];
    }
    return _floatingWindow;
}

@end
