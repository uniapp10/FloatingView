//
//  FloatingWindow.m
//  TestFloatingView
//
//  Created by ZD on 2020/7/3.
//  Copyright © 2020 ZD. All rights reserved.
//

#import "FloatingWindow.h"
#import "HomeWindow.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FloatingWindow ()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) CGFloat kEntryViewSize;
@end

@implementation FloatingWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.windowLevel = UIWindowLevelStatusBar + 1;
    self.backgroundColor = [UIColor orangeColor];
    self.layer.cornerRadius = 29;
    self.layer.masksToBounds = true;
    [self addSubview:self.btn];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.kEntryViewSize = 58;
    
    [self addGestureRecognizer:pan];
}


- (void)pan: (UIPanGestureRecognizer *)panGestureRecognizer {
    //1、获得拖动位移
    CGPoint offsetPoint = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    //2、清空拖动位移
    [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
    //3、重新设置控件位置
    UIView *panView = panGestureRecognizer.view;
    CGFloat newX = panView.center.x+offsetPoint.x;
    CGFloat newY = panView.center.y+offsetPoint.y;
    if (newX < _kEntryViewSize/2) {
        newX = _kEntryViewSize/2;
    }
    if (newX > ScreenWidth - _kEntryViewSize/2) {
        newX = ScreenWidth - _kEntryViewSize/2;
    }
    if (newY < _kEntryViewSize/2) {
        newY = _kEntryViewSize/2;
    }
    if (newY > ScreenHeight - _kEntryViewSize/2) {
        newY = ScreenHeight - _kEntryViewSize/2;
    }
    panView.center = CGPointMake(newX, newY);
}

- (void)btnClick:(UIButton *)btn {
    if ([HomeWindow shareInstance].hidden) {
        [[HomeWindow shareInstance] show];
    } else {
        [[HomeWindow shareInstance] hide];
    }
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton new];
        _btn.frame = self.bounds;
        _btn.backgroundColor = [UIColor greenColor];
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btn;
}

@end
