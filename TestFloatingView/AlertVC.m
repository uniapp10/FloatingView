//
//  AlertVC.m
//  TestFloatingView
//
//  Created by ZD on 2020/7/3.
//  Copyright © 2020 ZD. All rights reserved.
//

#import "AlertVC.h"
#import "AlertWindow.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AlertVC ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) AlertWindow *window;

@property (nonatomic, strong) UITextField *textF;

@end

@implementation AlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        //初始为透明
        _maskView.alpha = 0.0;
    }
    CGFloat containerH = 200;
    CGFloat containerW = 300;
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerW, containerH)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 10;
        _containerView.center = CGPointMake(self.view.center.x, self.view.center.y);
        _containerView.layer.masksToBounds = true;
    }
    CGFloat btnH = 50;
    if (!_cancleBtn) {
        _cancleBtn = [UIButton new];
        _cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(_containerView.bounds) - btnH, containerW * 0.5, btnH);
        [_cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_cancleBtn setBackgroundColor:[UIColor orangeColor]];
    }
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        _sureBtn.frame = CGRectMake(containerW * 0.5, CGRectGetMaxY(_containerView.bounds) - btnH, containerW * 0.5, btnH);
        [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_sureBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_sureBtn setBackgroundColor:[UIColor orangeColor]];
    }
    
    if (!_textF) {
        _textF = [UITextField new];
        _textF.frame = CGRectMake(0, 20, containerW, btnH);
        _textF.backgroundColor = [UIColor orangeColor];
    }
    
    [_containerView addSubview:_textF];
    [_containerView addSubview:_cancleBtn];
    [_containerView addSubview:_sureBtn];

    [self.view addSubview:_maskView];
    [self.view addSubview:_containerView];
        
}
/**
 
 typedef NS_ENUM(NSInteger, UIEventType) {
 UIEventTypeTouches,
 UIEventTypeMotion,
 UIEventTypeRemoteControl,
 UIEventTypePresses API_AVAILABLE(ios(9.0)),
 UIEventTypeScroll      API_AVAILABLE(ios(13.4), tvos(13.4)) API_UNAVAILABLE(watchos) = 10,
 UIEventTypeHover       API_AVAILABLE(ios(13.4), tvos(13.4)) API_UNAVAILABLE(watchos) = 11,
 UIEventTypeTransform   API_AVAILABLE(ios(13.4), tvos(13.4)) API_UNAVAILABLE(watchos) = 14,
 };
 */


- (void)dealloc {
    self.window.rootViewController = nil;
}

- (void)btnClick: (UIButton *)btn {
    [self hide];
}

- (void)show {
//    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    
    self.window.hidden = false;
    self.containerView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 1.0;
        self.containerView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.alpha = 0.0;
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.window.hidden = true;
        //解决循环引用
        self.window.rootViewController = nil;
    }];
}

- (AlertWindow *)window {
    if (!_window) {
        _window = [[AlertWindow alloc] init];
        _window.rootViewController = self;
        _window.windowLevel = UIWindowLevelStatusBar + 1;
        _window.backgroundColor = [UIColor clearColor];
    }
    return _window;
}

@end
