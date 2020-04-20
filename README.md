# iOS-interview
### 设计到的技术点
1. 内存管理
2. runtime
3. runloop


4. KVO
5. KVC
![setKey](https://user-gold-cdn.xitu.io/2018/8/16/1653e63385b66420?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
![ValueForKey](https://user-gold-cdn.xitu.io/2018/8/16/1654345519a1f4a3?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
6. 通知
7. 多线程
8. block
block是将函数及其执行上下文封装起来的对象
变量截获:
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

9. 证书签名
10. 启动优化
11. 响应链
12. autoreleasepool

Runloop和Autorelease
iOS在主线程的Runloop中注册了2个Observer
第1个Observer监听了kCFRunLoopEntry事件，会调用objc_autoreleasePoolPush()
第2个Observer
监听了kCFRunLoopBeforeWaiting事件，会调用objc_autoreleasePoolPop()、objc_autoreleasePoolPush()
监听了kCFRunLoopBeforeExit事件，会调用objc_autoreleasePoolPop()

13. 源码分析
14. 网络
15. 数据结构与算法
