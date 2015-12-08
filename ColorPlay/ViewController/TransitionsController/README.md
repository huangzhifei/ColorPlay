
本来可以创建一个 AnimationController 的基类，实现 UIViewControllerAnimatedTransitioning 协议

然后留出公共接口属性 @property CGFloat duration; 在实现他的两个协议，在里面分发让子类来实现具体的动画

但是在模拟器上运行调试时，非常慢，感觉是慢在多态上面，后来直接实现，明显快了很多，故这里就没有使用这种方式，

不知道是不是我的错觉。

