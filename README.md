# FloatingView
查看滴滴开源的 [DoraemonKit](https://github.com/didi/DoraemonKit) 以及阿里开源的[youku-sdk-tool-woodpecker](https://github.com/alibaba/youku-sdk-tool-woodpecker)
时, 看到启动入口均采用 `UIWindow` 来实现, 效果如下图悬浮的绿色按钮.

![悬浮按钮](https://tva1.sinaimg.cn/large/007S8ZIlly1ggexgrla66g30a40hyjrp.gif)

拖动悬浮按钮可以随手指一动(图上为模拟器效果), 点击悬浮按钮可以切换页面.

对这种效果的实现方式, 我的第一直觉是采用在 VC 的 `touch` 事件中进行处理, 但是按钮还需要有点击效果, 这个就难以处理了. 带着疑问查看源码, 发现两个项目中的悬浮框均是采用 `UIWindow` 的方式来实现, 十分巧妙. 自己关于`Window` 的使用方式做了一些尝试, 遂有此文.

##### 1 新建的 `UIWindow` 如何显示?
开始时, 我首先把创建的 `UIWindow` 添加到 `keyWindow` 上, 调用 `show` 方法显示正常, 但是在使用 `Xcode` 中的渲染工具`debug view hierarchy`查看 App 的渲染层级时, 直接崩溃. 反复查找, 移除添加到 `keyWindow` 的代码, 显示和渲染均正常. 

`UIWindow` 属于一个完整渲染层的容器控件, 不能再添加其他 `UIWindow` 实例. 一个 `App` 应用属于一个最底层容器, 可以同时承载不同的 `UIWindow`. 多个 `UIWindow` 在`App` 中的显示顺序, 按照 `windowLevel` 的大小, 从前到后进行显示. `App` 中多个 `UIWindow` 的响应, 和 `View` 中多个 `子View` 的响应方式一样, `hitTest` 方法返回哪个`UIView`, 哪个对象就响应.

`iOS13` 中使用多场景 `SceneDelegate` 时, 在 `- (void)scene: willConnectToSession: options:` 方法中创建 `Window` 时, 要采用 `initWithWindowScene:` 的方式, 否则 `Window`将无法显示. 可以采用修改 `Xcode` 模板的方式, 在新建工程时默认去除 `SceneDelegate`, 操作方式可参考:[MyTemplate](https://github.com/uniapp10/MyTemplate).

##### 2 keyWindow 和 delegate 的 Window
一般在 `application:didFinishLaunchingWithOptions:` 方法中新建 `Window`, 作为 `AppDelegate` 的属性. 然后调用 `makeKeyAndVisible` 方法显示在 App 中. 此时通过`[UIApplication sharedApplication].keyWindow` 获取的为此 `Window`. 新建 `UIWindow` 实例, 调用`makeKeyAndVisible` 后, 可以改变项目中的 `keyWindow`. 比如系统的 `UIAlertView`/`UIAlertController`/`KeyBoard` 显示时, 会自动切换 `UIApplication` 的 `keyWindow`. 将某些控件显示在 `keyWindow` 时, 需要注意变化, 避免控件意料之外的消失.

将`UIWindow` 的 `hidden` 属性设置为 `false` 时, 即可在 APP 显示, 为何还要置位 `KeyWindow` 呢?  看一下文档上 `makeKeyAndVisible` 的介绍:
```

Use this method to make the window key without changing its visibility. 
The key window receives keyboard and other non-touch related events. 
This method causes the previous key window to resign the key status.

```
主要在第二点, 设置为 `key window` 后, 可以响应键盘和非触摸事件. App 中的事件一共包含 7 种:
```

typedef NS_ENUM(NSInteger, UIEventType) {
 UIEventTypeTouches,
 UIEventTypeMotion,
 UIEventTypeRemoteControl,
 UIEventTypePresses API_AVAILABLE(ios(9.0)),
 UIEventTypeScroll      API_AVAILABLE(ios(13.4), tvos(13.4)) API_UNAVAILABLE(watchos) = 10,
 UIEventTypeHover       API_AVAILABLE(ios(13.4), tvos(13.4)) API_UNAVAILABLE(watchos) = 11,
 UIEventTypeTransform   API_AVAILABLE(ios(13.4), tvos(13.4)) API_UNAVAILABLE(watchos) = 14,

```
后面 3 类为 `iOS13` 新增, 文档上也没有介绍. 日常开发中接触到的主要是前面 4 类. 第一类为 `touch` 事件, 是否为 `keyWindow` 均可以响应; 第二类为加速计事件, 主要指`shake`; 第三类为远程控制, 比如`airpod` 对音量的控制; 第四类为按压事件, 文档上解释为`a physical button`, `iPhone` 上符合条件的只有音量键和电源键. 

`UIWindow` 在显示/隐藏、keyWindow 切换时，会发送以下 4 种通知：
```

UIWindowDidBecomeVisibleNotification
UIWindowDidBecomeHiddenNotification
UIWindowDidBecomeKeyNotification
UIWindowDidResignKeyNotification

```
监听以上通知，测试键盘和2/3/4 类事件发生时，多 `UIWindow` 的响应情况。粘贴代码过于繁琐，直接说下测试结论：
1. `motion`中的`shake`事件中，`keyWindow` 才可以响应；
2. 监听音量键通知`AVSystemController_SystemVolumeDidChangeNotification`前，需要调用 `[[UIApplication sharedApplication] beginReceivingRemoteControlEvents]` 方法，非 `keyWindow` 也可以正常监听, 这和文档介绍的不同；
3. 非 `keyWindow` 中的 `UITextField` 和 `UITextView` 控件响应时, 会自动将所在的 `Window` 置位 `keyWindow`.

`makeKeyWindow` 和 `makeKeyAndVisible` 不同，看下 `makeKeyWindow` 的介绍：
```

This is a convenience method to show the current window and position it in front of all other windows at the same level or lower. 
If you only want to show the window, change its hidden property to NO.

```
`makeKeyWindow` 会把当前 `Window` 放在其他同级别/低级别的 `Window` 前面，但是对事件响应没有丝毫影响。当`keyWindow` 被隐藏后，系统会自动把级别最高的 `Window` 置为 `keyWindow`. 

##### 3 多 `Window` 的使用
开头的例子，将悬浮框看做 `UIWindow` 的实例，可以响应 触摸事件。添加 `panGesture`手势，在响应方法中，更新 `UIWindow` 的位置。同时在 `UIWindow` 添加 `UIButton` 控件，进而在点击方法中进行页面操作。自己简单实现了一下 [FloatingView](https://github.com/uniapp10/FloatingView)

使用 `UIWindow` 可以仿照系统 `UIAlertView` 的实现方式，随心所欲的 `show` 到最顶层。将 `VC` 上添加一个 `UIWindow` 属性(创建时默认为屏幕大小)，自身作为`UIWindow`的根控制器，设置`UIWindow` 的 `hidden` 进行显示。这种方式有一个注意点，`UIWindow` 对 `rootViewController` 是强引用，会和 `VC` 造成循环引用，在 `Window` 隐藏时，主动将 `rootViewController` 置为 nil, 打破循环。

使用 `Window` 还可以实现顺利启动广告图。

#####  总结
可以将 App 看做一个容器，里面可以装多个 `UIWindow`，显示顺序和 `windowLevel` 的大小有关。
多 `UIWindow` 间彼此独立，不能相互添加，否者渲染层级会出问题。非`keyWindow` 和 `keyWindow` 间对系统事件的响应方式不同，通过 `makeKeyWindow` 可以调整多 `Window` 的显示，通过 `makeKeyAndVisible` 可以切换 `keyWindow`. 通过多 `UIWindow`，可以很方便的模仿 `UIAlertView` 的实现，实现自定义弹窗以及启动图。
[Demo](https://github.com/uniapp10/FloatingView)

##### 喜欢和关注都是对我的鼓励和支持~