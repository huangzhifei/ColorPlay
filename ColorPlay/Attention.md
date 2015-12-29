
经验总结：

----------------------------------------------------------------------------------------------------

利用Product-->Analyze静态分析，一般会分析出哪里出现memory leaks，主要的 leaks 点在桥接 (__bridge) :C 和 OC
之间传递数据的时候需要使用桥接! why?

1、内存管理：
在 OC 中，如果是在 ARC 环境下开发，编译器在编译的时候会根据代码结构，自动为 OC 代码添加 retain/release/autorelease等。
                                                                    -----自动内存管理(ARC)的原理!

但是, ARC只负责 OC 部分的内存管理！不会负责 C 语言部分代码的内存管理！也就是说即使是在 ARC 的开发环境中如果使用 C 语言代码
出现了 retain/copy/new/create 等字样呢!我们都需要手动为其添加 release 操作！否则会出现内存泄露！

在混合开发时(C 和 OC 代码混合)，C 和 OC 之间传递数据需要使用 __bridge 桥接，目的就是为了告诉编译器如何管理内存，在 MRC 中
不需要使用桥接! 因为都需要手动进行内存管理！

2、数据类型转换：

    Foundation 和 Core Foundation框架的数据类型可以互相转换的
    Foundation :  OC
    Core Foundation : C 语言

    NSString *str = @"123"; // Foundation
    CFStringRef str2 = (__bridge CFStringRef)str; // Core Foundation

    NSString *str3 = (__bridge NSString *)str2;
    CFArrayRef ---- NSArray
    CFDictionaryRef ---- NSDictionary
    CFNumberRef ---- NSNumber

    Core Foundation 中手动创建的数据类型，都需要手动释放

    CGPathRef path = CGPathCreateMutable();
    CGPathRetain(path);

    CGPathRelease(path);
    CGPathRelease(path);

3、桥接的添加:
    利用 Xcode 提示自动添加！ -- 简单/方便/快速
    /**
        凡是函数名中带有create\copy\new\retain等字眼, 都应该在不需要使用这个数据的时候进行release
        GCD的数据类型在ARC环境下不需要再做release
        CF(Core Foundation)的数据类型在ARC\MRC环境下都需要再做release
    */


文章连接：http://www.jianshu.com/p/4336d4c8ee1e


4、OC语法规定, 不能直接修改一个"对象"的"结构体属性"的"成员"

    iv.frame.size = image.size;// 错误
    先取出 --> 再修改 --> 重新赋值
    CGRect tempFrame = iv.frame;
    tempFrame.size = image.size;
    iv.frame = tempFrame;


5、UIViewContentMode

    - 规律一:
    但凡取值中包含Scale单词的, 都会对图片进行拉伸(缩放)
    但凡取值中没有出现Scale单词的, 都不会对图片进行拉伸
    UIViewContentModeScaleToFill,
    + 会按照UIImageView的宽高比来拉伸图片
    + 直到让整个图片都填充UIImageView为止
    + 因为是按照UIImageView的宽高比来拉伸, 所以图片会变形

    - 规律二:
    但凡取值中包含Aspect单词的, 都会按照图片的宽高比来拉伸
    因为是按照图片的宽高比来拉伸, 所以图片不会变形

    UIViewContentModeScaleAspectFit
    + 会按照图片的宽高比来拉伸
    + 要求整张图片都必须在UIImageView的范围内
    + 并且宽度和高度其中一个必须和UIImageView一样
    + 居中显示

    UIViewContentModeScaleAspectFill,
    + 会按照图片的宽高比来拉伸
    + 要求整张图片必须填充UIImageView
    + 并且图片的宽度或者高度其中一个必须和UIImageView一样

6、iOS 程序性能优化总结
    
    http://www.samirchen.com/ios-performance-optimization/

7、GCD 使用总结
    
    http://www.samirchen.com/ios-gcd/

8、initWithNibName 与 loadNibNamed
    
    initWithNibName：是延迟加载，这个View上的控件是 nil 的，只有到 需要显示时，才会不是 nil。UIView 没有此接口
    loadNibNamed： 即时加载，用该方法加载的xib对象中的各个元素都已经存在

