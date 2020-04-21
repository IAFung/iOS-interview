# iOS-interview
### 设计到的技术点
#### 1. 内存管理
#### 2. runtime
```
load和initialize的区别
① 调用时机----load在类被加载时调用,且在main函数之前调用. initialize在类或其子类收到第一条消息是调用
② 执行方式----load直接根据方法地址调用. initialize通过objc_msgSend调用
③ 调用顺序----load先编译先执行,如果继承,先执行父类再执行子类.分类也是先编译先执行. initialize如果类和其分类都实现最终只调用最后编译的分类中的同名方法.如果子类和父类都实现,先调用父类再调用子类
```
#### 3. runloop
概念: 一个线程一次只能执行一个任务，执行完成后线程就会退出。我们需要一个机制，让线程能随时处理事件但并不退出。这就是runloop.关键在于如何管理事件/消息，如何让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒。
作用: 1. 保持程序的持续运行，在iOS线程中，会在main方法给主线程创建一个RunLoop，保证主线程不被销毁
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
内部逻辑:
![runloop](https://user-gold-cdn.xitu.io/2019/12/24/16f36f8727cf58f1?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

#### 4. KVO
#### 5. KVC
![setKey](https://user-gold-cdn.xitu.io/2018/8/16/1653e63385b66420?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
![ValueForKey](https://user-gold-cdn.xitu.io/2018/8/16/1654345519a1f4a3?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
#### 6. 通知
#### 7. 多线程
#### 8. block
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

#### 9. 证书签名
#### 10. 启动优化
#### 11. 响应链
#### 12. autoreleasepool

Runloop和Autorelease
iOS在主线程的Runloop中注册了2个Observer
第1个Observer监听了kCFRunLoopEntry事件，会调用objc_autoreleasePoolPush()
第2个Observer
监听了kCFRunLoopBeforeWaiting事件，会调用objc_autoreleasePoolPop()、objc_autoreleasePoolPush()
监听了kCFRunLoopBeforeExit事件，会调用objc_autoreleasePoolPop()

#### 13. 源码分析
#### 14. 网络
TCP UDP区别:
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
GET POST区别
get: 获取资源 post: 处理资源
get请求是 安全的--不引起服务端任何状态变化
幂等的 -- 同一请求执行多次和执行一次效果相同
可缓存的
post请求是非安全,非幂等,不可缓存

TCP 三次握手, 四次挥手
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

HTTPS:
![HTTPS](https://user-gold-cdn.xitu.io/2019/3/28/169c44ac0af42de7?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

抓包原理:
1. 截获客户端的HTTPS请求，伪装成中间人客户端去向服务端发送HTTPS请求
2. 接受服务端返回，用自己的证书伪装成中间人服务端向客户端发送数据内容。
即中间人攻击
![charles](https://user-gold-cdn.xitu.io/2019/3/28/169c44ac0ae69a06?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
怎么禁止中间人攻击
1. 将证书文件也放置在客户端一份, 确保服务端证书与本地证书一致才进行通信,但是证书过期会要重新更换
2. 将证书公钥保存在本地,效果与放置证书一致,且证书过期公钥不会改变
#### 15. 数据结构与算法
