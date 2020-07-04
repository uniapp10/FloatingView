//
//  HomeWindow.m
//  TestFloatingView
//
//  Created by ZD on 2020/7/3.
//  Copyright © 2020 ZD. All rights reserved.
//

#import "HomeWindow.h"
#import "FloatingDefines.h"
#import "HomeVC.h"

@implementation HomeWindow

+ (instancetype)shareInstance {
    static HomeWindow *window;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [self new];
    });
    return window;
}

- (void)show {
    [self setupUI];
    self.hidden = false;
//    [self makeKeyWindow];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChangeNotification:)name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];    
    [self makeKeyAndVisible];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSLog(@"keyWindow1:\n%@",window);
}

- (void)volumeChangeNotification:(NSNotification *)notify {
    NSLog(@"HomeWindow音量变化:%@", notify.name);
}

- (void)hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.rootViewController = nil;
    self.hidden = true;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSLog(@"keyWindow2:\n%@",window);
    
    UIWindow *dwindow = [UIApplication sharedApplication].delegate.window;
    NSLog(@"delegateWindow:\n%@", dwindow);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar - 1;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor greenColor];
    if (!self.rootViewController) {
        self.rootViewController = [HomeVC new];
    }
    
}

@end
