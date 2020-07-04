//
//  HomeWindow.h
//  TestFloatingView
//
//  Created by ZD on 2020/7/3.
//  Copyright © 2020 ZD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeWindow : UIWindow
+ (instancetype)shareInstance;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
