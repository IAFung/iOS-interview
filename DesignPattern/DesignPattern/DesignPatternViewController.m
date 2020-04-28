//  DesignPatternViewController.m
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import "DesignPatternViewController.h"
#import "AVPlayer.h"
#import "PlayerAdapter.h"
#import "VinegarSauceDecorator.h"
#import "VegetableSalad.h"
@interface DesignPatternViewController ()
@property (strong, nonatomic) id<AVPlayerProtocol> player; //这里需要使用id<AVPlayerProtocol>,不能直接使用AVPlayer.不然适配器模式不适用
@end

@implementation DesignPatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    客户端只需使用适配器初始化方法将新的播放器对象传入.其他调用无需修改.
    // 播放器对象是关联,不指定具体的类型.
    //适配器类需要遵循AVPlayerProtocol协议,并在实现AVPlayerProtocol协议的方法里调用IJKPlayer的对应类似方法
//    [self oldPlayer]; 原始方法
    [self newPlayer]; //新方法
}

- (void)oldPlayer{
    self.player = [[AVPlayer alloc] init];
}
- (void)newPlayer {
    self.player = [[PlayerAdapter alloc] initWithPlayer: [IJKPlayer new]];
}

- (void)startPlayer {
    [self.player av_start];
}

- (void)stopPlayer {
    [self.player av_stop];
}

- (void)resumePlayer {
    [self.player av_resume];
}

//对蔬菜沙拉添加醋   Salad为抽象构件 VegetableSalad为具体构件 SauceDecorator为装饰类 VinegarSauceDecorator为具体装饰类
- (void)decoratorPattern{
    Salad *vegetableSalad = [[VegetableSalad alloc] init];
    vegetableSalad = [[VinegarSauceDecorator alloc] initWithSalad:vegetableSalad];
}
@end
