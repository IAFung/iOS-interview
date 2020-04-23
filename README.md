# iOS-interview
### 设计到的技术点
#### 1. 内存管理
![分区](https://upload-images.jianshu.io/upload_images/1387472-53381455db3bb0c9.png?imageMogr2/auto-orient/strip|imageView2/2/w/984/format/webp)


| 内存管理方法                      | 具体实现                                     |
| --------------------------- | ---------------------------------------- |
| alloc                       | 经过一系列的函数调用栈，最终通过调用 C 函数`calloc`来申请内存空间，并初始化对象的`isa`，但并没有设置对象的引用计数值为 1。 |
| init                        | 基类的`init`方法啥都没干，只是将`alloc`创建的对象返回。我们可以重写`init`方法来对`alloc`创建的实例做一些初始化操作。 |
| new                         | `new`方法很简单，只是嵌套了`alloc`和`init`。          |
| copy、mutableCopy            | 调用了`copyWithZone`和`mutableCopyWithZone`方法。 |
| retainCount                 | ① 如果`isa`不是`nonpointer`，引用计数值 = `SideTable`中的引用计数表中存储的值 + 1；② 如果`isa`是`nonpointer`，引用计数值 = `isa`中的`extra_rc`存储的值 + 1 +`SideTable`中的引用计数表中存储的值。 |
| retain                      | ① 如果`isa`不是`nonpointer`，就对`Sidetable`中的引用计数进行 +1；② 如果`isa`是`nonpointer`，就将`isa`中的`extra_rc`存储的引用计数进行 +1，如果溢出，就将`extra_rc`中`RC_HALF`（`extra_rc`满值的一半）个引用计数转移到`sidetable`中存储。 |
| release                     | ① 如果`isa`不是`nonpointer`，就对`Sidetable`中的引用计数进行 -1，如果引用计数 =0，就`dealloc`对象；② 如果`isa`是`nonpointer`，就将`isa`中的`extra_rc`存储的引用计数进行 -1。如果下溢，即`extra_rc`中的引用计数已经为 0，判断`has_sidetable_rc`是否为`true`即是否有使用`Sidetable`存储。如果有的话就申请从`Sidetable`中申请`RC_HALF`个引用计数转移到`extra_rc`中存储，如果不足`RC_HALF`就有多少申请多少，然后将`Sidetable`中的引用计数值减去`RC_HALF`（或是小于`RC_HALF`的实际值），将实际申请到的引用计数值 -1 后存储到`extra_rc`中。如果`extra_rc`中引用计数为 0 且`has_sidetable_rc`为`false`或者`Sidetable`中的引用计数也为 0 了，那就`dealloc`对象。 |
| dealloc                     | ① 判断销毁对象前有没有需要处理的东西（如弱引用、关联对象、`C++`的析构函数、`SideTabel`的引用计数表等等）；② 如果没有就直接调用`free`函数销毁对象；③ 如果有就先调用`object_dispose`做一些释放对象前的处理（置弱引用指针置为`nil`、移除关联对象、`object_cxxDestruct`、在`SideTabel`的引用计数表中擦出引用计数等待），再用`free`函数销毁对象。 |
| 清除`weak`，`weak`指针置为`nil`的过程 | 当一个对象被销毁时，在`dealloc`方法内部经过一系列的函数调用栈，通过两次哈希查找，第一次根据对象的地址找到它所在的`Sidetable`，第二次根据对象的地址在`Sidetable`的`weak_table`中找到它的弱引用表。遍历弱引用数组，将指向对象的地址的`weak`变量全都置为`nil`。 |
| 添加`weak`                    | 经过一系列的函数调用栈，最终在`weak_register_no_lock()`函数当中，进行弱引用变量的添加，具体添加的位置是通过哈希算法来查找的。如果对应位置已经存在当前对象的弱引用表（数组），那就把弱引用变量添加进去；如果不存在的话，就创建一个弱引用表，然后将弱引用变量添加进去。 |

TaggedPointer
```Objective-C
	NSString *a = @"a"; //__NSCFConstantString
        NSMutableString *b = [a mutableCopy]; //__NSCFString
        NSString *c = [a copy]; //__NSCFConstantString
        NSString *d = [[a mutableCopy] copy]; //NSTaggedPointerString
        NSString *e = [NSString stringWithString:a]; //__NSCFConstantString
        NSString *f = [NSString stringWithFormat:@"f"]; //NSTaggedPointerString
        NSString *string1 = [NSString stringWithFormat:@"abcdefg"]; //NSTaggedPointerString
        NSString *string2 = [NSString stringWithFormat:@"abcdefghi"]; //NSTaggedPointerString
        NSString *string3 = [NSString stringWithFormat:@"abcdefghij"]; //__NSCFString
1. 通过字面量@"..."创建的字符串为__NSCFConstantString类型,存储在字符串常量区.相同内容的 __NSCFConstantString 对象的地址相同，也就是说常量字符串对象是一种单例，可以通过 == 判断字符串内容是否相同。
2. __NSCFString存储在堆区,需要维护引用计数.
3. 使用stringWithFormat方法创建的字符串,当指针不足以存储字符串内容(超过8个字节),字符串为__NSCFString类型,反之为NSTaggedPointerString
4. 对可变字符串进行copy操作时,当指针不足以存储字符串内容(超过8个字节),拷贝的字符串为__NSCFString类型,反之为NSTaggedPointerString
5. 对__NSCFConstantString和NSTaggedPointerString进行浅copy,只是拷贝指针,不改变类型.
6. __NSCFConstantString和NSTaggedPointerString不需要维护引用计数.__NSCFString在堆区,需要维护引用计数
```

#### 2. runtime
```
isa指针存储的内容
nonpointer：(isa的第0位(isa的最后面那位)，共占1位)。为0表示这个isa只存储了地址值，为1表示这是一个优化过的isa。
has_assoc：(isa的第1位，共占1位)。记录这个对象是否是关联对象,没有的话，释放更快。
has_cxx_dtor：(isa的第2位，共占1位)。记录是否有c++的析构函数，没有的话，释放更快。
shiftcls：(isa的第3-35位，共占33位)。记录类对象或元类对象的地址值。
magic：(isa的第36-41位，共占6位)，用于在调试时分辨对象是否完成初始化。
weakly_referenced：(isa的第42位，共占1位)，用于记录该对象是否被弱引用或曾经被弱引用过，没有被弱引用过的对象可以更快释放。
deallocating：(isa的第43位，共占1位)，标志对象是否正在释放内存。
has_sidetable_rc：(isa的第44位，共占1位)，用于标记是否有扩展的引用计数。当一个对象的引用计数比较少时，其引用计数就记录在isa中，当引用计数大于某个值时就会采用sideTable来协助存储引用计数。
extra_rc：(isa的第45-63位，共占19位)，用来记录该对象的引用计数值-1(比如引用计数是5的话这里记录的就是4)。这里总共是19位，如果引用计数很大，19位存不下的话就会采用sideTable来协助存储，规则如下：当19位存满时，会将19位的一半(也就是上面定义的RC_HALF)存入sideTable中，如果此时引用计数又+1，那么是加在extra_rc上，当extra_rc又存满时，继续拿出RC_HALF的大小放入sideTable。当引用计数减少时，如果extra_rc的值减少到了0，那就从sideTable中取出RC_HALF大小放入extra_rc中。综上所述，引用计数不管是增加还是减少都是在extra_rc上进行的，而不会直接去操作sideTable，这是因为sideTable中有个自旋锁，而引用计数的增加和减少操作是非常频繁的，如果直接去操作sideTable会非常影响性能，所以这样设计来尽量减少对sideTable的访问。

load和initialize的区别
① 调用时机----load在类被加载时调用,且在main函数之前调用. initialize在类或其子类收到第一条消息是调用
② 执行方式----load直接根据方法地址调用. initialize通过objc_msgSend调用
③ 调用顺序----load先编译先执行,如果继承,先执行父类再执行子类.分类也是先编译先执行. initialize如果类和其分类都实现最终只调用最后编译的分类中的同名方法.如果子类和父类都实现,先调用父类再调用子类
```
#### 3. runloop
##### 概念: 
runloop是通过内部维护的事件循环来对事件/消息进行管理的一个对象.通过mach_msg来进行用户态和内核态的切换.让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒。
##### 作用: 
1. 保持程序的持续运行，在iOS线程中，会在main方法给主线程创建一个RunLoop，保证主线程不被销毁
2. 处理APP中的各种事件（如touch，timer，performSelector等）
3. 界面更新
4. 手势识别
5. AutoreleasePool
    系统在主线程RunLoop注册了2个observer
    第一个observe监听即将进入RunLoop，调用_objc_autoreleasePoolPush()创建自动释放池
    第二个observe监听两个事件，进入休眠之前和即将退出RunLoop
    在进入休眠之前的回调里，会先释放自动释放池，然后在创建一个自动释放池
    在即将退出的回调里，会释放自动释放池
6. 线程保活
7. 监测卡顿
##### 内部逻辑:
![runloop](https://user-gold-cdn.xitu.io/2019/12/24/16f36f8727cf58f1?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

#### 4. KVO
#### 5. KVC
![setKey](https://user-gold-cdn.xitu.io/2018/8/16/1653e63385b66420?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
![ValueForKey](https://user-gold-cdn.xitu.io/2018/8/16/1654345519a1f4a3?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
#### 6. 通知
#### 7. 多线程
#### 8. block
##### block是将函数及其执行上下文封装起来的对象
##### 变量截获:
静态局部变量: 指针形式截获
基本数据类型的局部变量: 截获其值
对象类型的局部变量: 连同所有权修饰符一起截获  `__weak` `__strong`
静态全局变量和全局变量----不截获

__block修饰符: 
基本数据类型的局部变量和对象类型的局部变量需要__block修饰符

block三种类型: __NSGlobalBlock__、__NSStackBlock__、__NSMallocBlock__
没有访问普通局部变量(也就是说block里面没有访问任何外部变量或者访问的是静态局部变量或者访问的是全局变量)，那这个block就是__NSGlobalBlock__。__NSGlobalBlock__类型的block在内存中是存在数据区的(也叫全局区或静态区，全局变量和静态变量是存在这个区域的)。__NSGlobalBlock__类型的block调用copy方法的话什么都不会做。

_NSStackBlock__
如果一个block里面访问了普通的局部变量，那它就是一个__NSStackBlock__，它在内存中存储在栈区，栈区的特点就是其释放不受开发者控制，都是由系统管理释放操作的，所以在调用__NSStackBlock__类型block时要注意，一定要确保它还没被释放。如果对一个__NSStackBlock__类型block做copy操作，那会将这个block从栈复制到堆上。
__NSStackBlock__的继承链是：__NSStackBlock__ : __NSStackBlock : NSBlock : NSObject。

__NSMallocBlock__
一个__NSStackBlock__类型block做调用copy，那会将这个block从栈复制到堆上，堆上的这个block类型就是__NSMallocBlock__，所以__NSMallocBlock__类型的block是存储在堆区。如果对一个__NSMallocBlock__类型block做copy操作，那这个block的引用计数+1。

在ARC环境下，编译器会根据情况，自动将栈上的block复制到堆上。有一下4种情况会将栈block复制到堆上：
a. block作为函数返回值
b. 将block赋值给强指针
c. 当block作为参数传给Cocoa API时
d. block作为GCD的API的参数时

#### 9. 证书签名
#### 10. App性能优化
##### 启动优化
![](https://user-gold-cdn.xitu.io/2019/10/14/16dc83bdebcf251e?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
```
TA(App总启动时间) = T1(main()之前的加载时间) + T2(main()之后的加载时间) +T3(首页数据加载+闪屏页数据同步)
T1 = 系统dylib(动态链接库)和自身App可执行文件的加载
T2 = main方法执行之后到Delegate类中的didFinishLaunchingWithOptions方法执行结束前这段时间

1. iOS的启动流程
	根据 info.plist 里的设置加载闪屏，建立沙箱，对权限进行检查等
	加载可执行文件
	加载动态链接库，进行 rebase 指针调整和 bind 符号绑定
	Objc 运行时的初始处理，包括 Objc 相关类的注册、category 注册、selector 唯一性检查等；
	初始化，包括了执行 +load() 方法、attribute((constructor)) 修饰的函数的调用、创建 C++ 静态全局变量。
	执行 main 函数
	Application 初始化，到 applicationDidFinishLaunchingWithOptions 执行完
	初始化帧渲染，到 viewDidAppear 执行完，用户可见可操作。
2. 启动优化
	减少动态库的加载
	去除掉无用的类和C++全局变量的数量
	尽量让load方法中的内容放到首屏渲染之后再去执行，或者使用initialize替换
	去除在首屏展现之前非必要的功能
	检查首屏展现之前主线程的耗时方法，将没必要的耗时方法滞后或者延迟执行

```
##### 卡顿优化
```
主线程中进化IO或其他耗时操作，解决：把耗时操作放到子线程中操作
GCD并发队列短时间内创建大量任务，解决：使用线程池
文本计算，解决：把计算放在子线程中避免阻塞主线程
大量图像的绘制，解决：在子线程中对图片进行解码之后再展示
高清图片的展示，解法：可在子线程中进行下采样处理之后再展示


CPU层面:
1 尽量用轻量级的对象，比如用不到事件处理的地方使用CALayer取代UIView
2 尽量提前计算好布局（例如cell行高）
3 不要频繁地调用和调整UIView的相关属性，比如frame、bounds、transform等属性，尽量减少不必要的调用和修改(UIView的显示属性实际都是CALayer的映射，而CALayer本身是没有这些属性的，都是初次调用属性时通过resolveInstanceMethod添加并创建Dictionary保存的，耗费资源)
4 Autolayout会比直接设置frame消耗更多的CPU资源，当视图数量增长时会呈指数级增长.
5 图片的size最好刚好跟UIImageView的size保持一致，减少图片显示时的处理计算
6 控制一下线程的最大并发数量
7 尽量把耗时的操作放到子线程
8 文本处理（尺寸计算、绘制、CoreText和YYText）:
(1). 计算文本宽高boundingRectWithSize:options:context: 和文本绘制drawWithRect:options:context:放在子线程操作
(2). 使用CoreText自定义文本空间，在对象创建过程中可以缓存宽高等信息，避免像UILabel/UITextView需要多次计算(调整和绘制都要计算一次)，且CoreText直接使用了CoreGraphics占用内存小，效率高。（YYText）
9 图片处理（解码、绘制）图片都需要先解码成bitmap才能渲染到UI上，iOS创建UIImage，不会立刻进行解码，只有等到显示前才会在主线程进行解码，固可以使用Core Graphics中的CGBitmapContextCreate相关操作提前在子线程中进行强制解压缩获得位图.
10 TableViewCell 复用: 在cellForRowAtIndexPath:回调的时候只创建实例，快速返回cell，不绑定数据。在willDisplayCell: forRowAtIndexPath:的时候绑定数据（赋值）
11 高度缓存: 在tableView滑动时，会不断调用heightForRowAtIndexPath:，当 cell 高度需要自适应时，每次回调都要计算高度，会导致 UI 卡顿。为了避免重复无意义的计算，需要缓存高度。
12 视图层级优化: 不要动态创建视图,在内存可控的前提下，缓存subview。善用hidden。
13 减少视图层级: 减少subviews个数，用layer绘制元素. 少用 clearColor，maskToBounds，阴影效果等。
14 减少多余的绘制操作.
15 图片优化：
（1）不要用JPEG的图片，应当使用PNG图片。
（2）子线程预解码（Decode），主线程直接渲染。因为当image没有Decode，直接赋值给imageView会进行一个Decode操作。
（3）优化图片大小，尽量不要动态缩放(contentMode)。
（4）尽可能将多张图片合成为一张进行显示。
16 减少透明 view： 使用透明view会引起blending，在iOS的图形处理中，blending主要指的是混合像素颜色的计算。最直观的例子就是，我们把两个图层叠加在一起，如果第一个图层的透明的，则最终像素的颜色计算需要将第二个图层也考虑进来。这一过程即为Blending。
17 理性使用-drawRect: 当你使用UIImageView在加载一个视图的时候，这个视图虽然依然有CALayer，但是却没有申请到一个后备的存储，取而代之的是使用一个使用屏幕外渲染，将CGImageRef作为内容，并用渲染服务将图片数据绘制到帧的缓冲区，就是显示到屏幕上，当我们滚动视图的时候，这个视图将会重新加载，浪费性能。所以对于使用-drawRect:方法，更倾向于使用CALayer来绘制图层。因为使用CALayer的-drawInContext:，Core Animation将会为这个图层申请一个后备存储，用来保存那些方法绘制进来的位图。那些方法内的代码将会运行在 CPU上，结果将会被上传到GPU。这样做的性能更为好些。静态界面建议使用-drawRect:的方式，动态页面不建议。
18 按需加载:局部刷新，刷新一个cell就能解决的，坚决不刷新整个 section 或者整个tableView，刷新最小单元元素。
利用runloop提高滑动流畅性，在滑动停止的时候再加载内容，像那种一闪而过的（快速滑动），就没有必要加载，可以使用默认的占位符填充内容。

GPU层面:
1 尽量避免短时间内大量图片的显示，尽可能将多张图片合成一张进行显示
2 GPU能处理的最大纹理尺寸是4096x4096，一旦超过这个尺寸，就会占用CPU资源进行处理，所以纹理尽量不要超过这个尺寸
3 GPU会将多个视图混合在一起再去显示，混合的过程会消耗CPU资源，尽量减少视图数量和层次
4 减少透明的视图（alpha<1），不透明的就设置opaque为YES，GPU就不会去进行alpha的通道合成
5 尽量避免出现离屏渲染.
6 合理使用光栅化 shouldRasterize:光栅化是把GPU的操作转到CPU上，生成位图缓存，直接读取复用。CALayer会被光栅化为bitmap，shadows、cornerRadius等效果会被缓存。更新已经光栅化的layer，会造成离屏渲染。bitmap超过100ms没有使用就会移除。受系统限制，缓存的大小为 2.5X Screen Size。
shouldRasterize 适合静态页面显示，动态页面会增加开销。如果设置了shouldRasterize为 YES，那也要记住设置rasterizationScale为contentsScale。
7 异步渲染.在子线程绘制，主线程渲染。


TableView卡顿: 
1.cell 的行高不是固定值，需要计算，则要尽可能缓存行高值，避免重复计算行高。因为 heightForRowAtIndexPath:是调用最频繁的方法。
2.滑动时按需加载，这个在大量图片展示，网络加载的时候很管用!(SDWebImage 已经实现异 步加载，配合这条性能杠杠的)。
3.正确使用 reuseIdentifier 来重用 Cells
4.尽量少用或不用透明图层
5.如果 Cell 内现实的内容来自 web，使用异步加载，缓存请求结果
6.减少 subviews 的数量
7.在 heightForRowAtIndexPath:中尽量不使用 cellForRowAtIndexPath:，如果你需要用到它， 只用一次然后缓存结果
8.所有的子视图都预先创建，如果不需要显示可以设置 hidden，尽量少动态给 Cell 添加 View
9.颜色不要使用 alpha
10.栅格化
11.cell 的 subViews 的各级 opaque 值要设成 YES，尽量不要包含透明的子 View
opaque 用于辅助绘图系统，表示 UIView 是否透明。在不透明的情况下，渲染视图时需要快速 地渲染，以提􏰀高性能。渲染最慢的操作之一是混合(blending)。提􏰀高性能的方法是减少混合操 作的次数，其实就是 GPU 的不合理使用，这是硬件来完成的(混合操作由 GPU 来执行，因为这 个硬件就是用来做混合操作的，当然不只是混合)。 优化混合操作的关键点是在平衡 CPU 和 GPU 的负载。还有就是 cell 的 layer 的 shouldRasterize 要设成 YES。
12.cell 异步加载图片以及缓存
13.异步绘制
	(1)在绘制字符串时，尽可能使用 drawAtPoint: withFont:，而不要使用更复杂的 drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode; 如果要绘制过长的字符串，建议自己先截 断，然后使用 drawAtPoint: withFont:方法绘制。
	(2)在绘制图片时，尽量使用 drawAtPoint，而不要使用 drawInRect。drawInRect 如果在绘 制过程中对图片进行放缩，会特别消耗 CPU。
	(3)其实，最快的绘制就是你不要做任何绘制。有时通过 UIGraphicsBeginImageContextWithOptions() 或者 CGBitmapContextCeate() 创建位图会显 得更有意义，从位图上面抓取图像，并设置为 CALayer 的内容。
	如果你必须实现 -drawRect:，并且你必须绘制大量的东西，这将占用时间。
	(4)如果绘制 cell 过程中，需要下载 cell 中的图片，建议在绘制 cell 一段时间后再开启图 片下载任务。譬如先画一个默认图片，然后在 0.5S 后开始下载本 cell 的图片。
	(5)即使下载 cell 图片是在子线程中进行，在绘制 cell 过程中，也不能开启过多的子线程。 最好只有一个下载图片的子线程在活动。否则也会影响 UITableViewCell 的绘制，因而影响了 UITableViewCell 的滑动速度。(建议结合使用 NSOpeartion 和 NSOperationQueue 来下载图片， 如果想尽可能找的下载图片，可以把[self.queuesetMaxConcurrentOperationCount:4];)
	(6)最好自己写一个 cache，用来缓存 UITableView 中的 UITableViewCell，这样在整个 UITableView 的生命周期里，一个 cell 只需绘制一次，并且如果发生内存不足，也可以有效的 释放掉缓存的 cell。
14.不要将 tableview 的背景颜色设置成一个图片。这回严重影响 UITableView 的滑动速度。在 限时免费搜索里，我曾经翻过一个错误:self.tableView_.backgroundColor = [UIColorcolorWithPatternImage:[UIImageimageNamed:@"background.png"]]; 通过这种方式 设置 UITableView 的背景颜色会严重影响 UTIableView 的滑动流畅性。修改成 self.tableView_.backgroundColor = [UIColor clearColor];之后，fps 从 43 上升到 60 左右。 滑动比较流畅。
```
##### 耗电优化
尽可能降低 CPU、GPU 的功耗。
尽量少用 定时器。
优化 I/O 操作。
	不要频繁写入小数据，而是积攒到一定数量再写入
	读写大量的数据可以使用 Dispatch_io ，GCD 内部已经做了优化。
	数据量比较大时，建议使用数据库
网络方面的优化
	减少压缩网络数据 （XML -> JSON -> ProtoBuf），如果可能建议使用 ProtoBuf。
	如果请求的返回数据相同，可以使用 NSCache 进行缓存
	使用断点续传，避免因网络失败后要重新下载。
	网络不可用的时候，不尝试进行网络请求
	长时间的网络请求，要提供可以取消的操作
	采取批量传输。下载视频流的时候，尽量一大块一大块的进行下载，广告可以一次下载多个
定位层面的优化
	如果只是需要快速确定用户位置，最好用 CLLocationManager 的 requestLocation 方法。定位完成后，会自动让定位硬件断电
	如果不是导航应用，尽量不要实时更新位置，定位完毕就关掉定位服务
	尽量降低定位精度，比如尽量不要使用精度最高的 kCLLocationAccuracyBest
	需要后台定位时，尽量设置 pausesLocationUpdatesAutomatically 为 YES，如果用户不太可能移动的时候系统会自动暂停位置更新
	尽量不要使用 startMonitoringSignificantLocationChanges，优先考虑 startMonitoringForRegion:
硬件检测优化
	用户移动、摇晃、倾斜设备时，会产生动作(motion)事件，这些事件由加速度计、陀螺仪、磁力计等硬件检测。在不需要检测的场合，应该及时关闭这些硬件
##### 网络优化
```
优化DNS解析和缓存
对传输的数据进行压缩，减少传输的数据
使用缓存手段减少请求的发起次数
使用策略来减少请求的发起次数，比如在上一个请求未着地之前，不进行新的请求
避免网络抖动，提供重发机制
```
##### app瘦身
![ss](https://user-gold-cdn.xitu.io/2020/4/17/17187331aeb0cc0f?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
LinkMap分析每个类占用的大小.针对性的进行代码的体积的优化，比如三方库占用空间巨量，有没其他的替代方案。在取舍两个相同库的时候也可以根据体积的比重做出取舍。

##### 编译速度优化
#### 11. 响应链
#### 12. autoreleasepool
##### Autoreleasepool是由多个AutoreleasePoolPage以双向链表的形式连接起来的
Autoreleasepool的基本原理：在每个自动释放池创建的时候，会在当前的AutoreleasePoolPage中设置一个标记位，在此期间，当有对象调用autorelsease时，会把对象添加到AutoreleasePoolPage中，若当前页添加满了，会初始化一个新页，然后用双向量表链接起来，并把新初始化的这一页设置为hotPage,当自动释放池pop时，从最下面依次往上pop，调用每个对象的release方法，直到遇到标志位。

Runloop和Autorelease
iOS在主线程的Runloop中注册了2个Observer
第1个Observer监听了kCFRunLoopEntry事件，会调用objc_autoreleasePoolPush()
第2个Observer
监听了kCFRunLoopBeforeWaiting事件，会调用objc_autoreleasePoolPop()、objc_autoreleasePoolPush()
监听了kCFRunLoopBeforeExit事件，会调用objc_autoreleasePoolPop()

#### 13. 源码分析
#### 14. 网络
##### TCP UDP区别:
```objective-c
1、连接性:
	 TCP 面向连接（如打电话要先拨号建立连接）;
	 UDP 是面向无连接的，即发送数据之前不需要建立连接
2、可靠性：
   TCP 提供可靠的服务。也就是说，通过TCP连接传送的数据，无差错，不丢失，不重复，且按序到达; 
	 UDP尽最大努力交付，即不保证可靠交付
3、传输内容：
	 TCP面向字节流，实际上是TCP把数据看成一连串无结构的字节流;
	 UDP是面向报文的，UDP没有拥塞控制，因此网络出现拥塞不会使源主机的发送速率降低（对实时应用很有用，如IP电话，实时视频会议等）
4、服务性质：
	 TCP连接只能是点到点的;
	 UDP支持一对一，一对多，多对一和多对多的交互通信
5、开销：
	 TCP首部开销20字节;
	 UDP的首部开销小，只有8个字节
6、信道
	 TCP的逻辑通信信道是全双工的可靠信道
	 UDP则是不可靠信道
```
##### GET POST区别
get: 获取资源 post: 处理资源
get请求是 安全的--不引起服务端任何状态变化
幂等的 -- 同一请求执行多次和执行一次效果相同
可缓存的
post请求是非安全,非幂等,不可缓存

##### TCP 三次握手, 四次挥手
三次握手: 
![三次握手](https://user-gold-cdn.xitu.io/2020/1/7/16f7e03b1ea507e8?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
1 客户端向服务端发起请求链接，首先发送SYN报文，SYN=1，seq=x,并且客户端进入SYN_SENT状态
2 服务端收到请求链接，服务端向客户端进行回复，并发送响应报文，SYN=1，seq=y,ACK=1,ack=x+1,并且服务端进入到SYN_RCVD状态
3 客户端收到确认报文后，向服务端发送确认报文，ACK=1，ack=y+1，此时客户端进入到ESTABLISHED，服务端收到用户端发送过来的确认报文后，也进入到ESTABLISHED状态，此时链接创建成功
![四次挥手](https://user-gold-cdn.xitu.io/2020/1/7/16f7e03b21a07f0c?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
1 客户端向服务端发起关闭链接，并停止发送数据
2 服务端收到关闭链接的请求时，向客户端发送回应，我知道了，然后停止接收数据
3 当服务端发送数据结束之后，向客户端发起关闭链接，并停止发送数据
4 客户端收到关闭链接的请求时，向服务端发送回应，我知道了，然后停止接收数据

##### HTTPS:
![HTTPS](https://user-gold-cdn.xitu.io/2019/3/28/169c44ac0af42de7?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

##### 抓包原理:
1. 截获客户端的HTTPS请求，伪装成中间人客户端去向服务端发送HTTPS请求
2. 接受服务端返回，用自己的证书伪装成中间人服务端向客户端发送数据内容。
即中间人攻击
![charles](https://user-gold-cdn.xitu.io/2019/3/28/169c44ac0ae69a06?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
##### 怎么禁止中间人攻击
1. 将证书文件也放置在客户端一份, 确保服务端证书与本地证书一致才进行通信,但是证书过期会要重新更换
2. 将证书公钥保存在本地,效果与放置证书一致,且证书过期公钥不会改变

#### 16. 数据结构
#### 17. 设计模式
#### 18. 算法

