//  DoublyLinkedList.h
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/27.
//  Copyright © 2019年 冯铁军. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Node;
@interface DoublyLinkedList : NSObject
- (void)append:(id)data;
- (void)insertAtIndex:(NSInteger)index data:(id)data;
- (Node *)getNode:(NSInteger)index;
- (NSInteger)indexOfNode:(id)data;
- (void)updateNodeAtIndex:(NSInteger)index data:(id)data;
- (void)removeNodeAtIndex:(NSInteger)index;
- (void)removeNodeWithData:(id)data;
- (BOOL)isEmpty;
- (NSInteger)size;
- (NSString *)forwardString;
- (NSString *)backwardString;
@end


@interface Node : NSObject
@property (strong, nonatomic) Node *prev;
@property (strong, nonatomic) Node *next;
@property (strong, nonatomic) id data;
- (instancetype)initWithData:(id)data;
@end

