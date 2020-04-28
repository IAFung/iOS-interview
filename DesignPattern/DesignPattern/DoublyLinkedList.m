//  DoublyLinkedList.m
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/27.
//  Copyright © 2019年 冯铁军. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DoublyLinkedList.h"

@interface DoublyLinkedList ()
@property (strong, nonatomic) Node *head;
@property (strong, nonatomic) Node *tail;
@property (assign, nonatomic) NSInteger length;
@end

@implementation DoublyLinkedList
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.head = nil;
        self.tail = nil;
        self.length = 0;
    }
    return self;
}
- (void)append:(id)data {
    Node *node = [[Node alloc] initWithData:data];
    
    if (self.length == 0) {
        self.head = node;
        self.tail = node;
    } else {
        self.tail.next = node;
        node.prev = self.tail;
        self.tail = node;
    }
    self.length += 1;
}
- (void)insertAtIndex:(NSInteger)index data:(id)data {
    if (index < 0 || index > self.length) {
        return;
    }
    Node *node = [[Node alloc] initWithData:data];
    if (self.length == 0) {
        self.head = node;
        self.tail = node;
    } else {
        if (index == 0) {
            self.head.prev = node;
            node.next = self.head;
            self.head = node;
        } else if (index == self.length) {
            self.tail.next = node;
            node.prev = self.tail;
            self.tail = node;
        } else {
            BOOL isTrue = index > self.length/2;
            Node *currentNode = isTrue ? self.tail : self.head;
            NSInteger dex = isTrue ? self.length-1 : 0;
            while (isTrue ? (dex-- > index) :(dex++ < index) ) {
                currentNode = isTrue ? currentNode.prev : currentNode.next;
            }
            currentNode.prev.next = node;
            node.prev = currentNode.prev;
            node.next = currentNode;
            currentNode.prev = node;
        }
    }
    self.length += 1;
}
- (Node *)getNode:(NSInteger)index {
    if (index < 0 || index >= self.length) {
        return nil;
    }
    if (self.length == 1) {
        return  self.head;
    } else {
        if (self.length == index + 1) {
            return self.tail;
        } else {
            BOOL isTrue = index > self.length/2;
            Node *currentNode = isTrue ? self.tail : self.head;
            NSInteger dex = isTrue ? self.length-1 : 0;
            while (isTrue ? (dex-- > index) :(dex++ < index) ) {
                currentNode = isTrue ? currentNode.prev : currentNode.next;
            }
            return currentNode;
        }
    }
}
- (NSInteger)indexOfNode:(id)data {
    Node *node = self.head;
    NSInteger index = 0;
    while (node) {
        if ([data isEqual:node.data]) {
            return index;
        }
        node = node.next;
        index += 1;
    }
    return -1;
}
- (void)updateNodeAtIndex:(NSInteger)index data:(id)data {
    Node *node = [self getNode:index];
    if (node) {
        node.data = data;
    }
}
- (void)removeNodeAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.length) {
        return;
    }
    if (self.length == 1) {
        self.head = nil;
        self.tail = nil;
    } else {
        if (index == 0) {
            self.head.next.prev = nil;
            self.head = self.head.next;
        } else if (index == self.length - 1) {
            self.tail.prev.next = nil;
            self.tail = self.tail.prev;
        } else {
            BOOL isTrue = index > self.length/2;
            Node *currentNode = isTrue ? self.tail : self.head;
            NSInteger dex = isTrue ? self.length-1 : 0;
            while (isTrue ? (dex-- > index) :(dex++ < index) ) {
                currentNode = isTrue ? currentNode.prev : currentNode.next;
            }
            currentNode.prev.next = currentNode.next;
            currentNode.next.prev = currentNode.prev;
        }
    }
    
}
- (void)removeNodeWithData:(id)data {
    NSInteger index = [self indexOfNode:data];
    [self removeNodeAtIndex:index];
}
- (BOOL)isEmpty {
    return self.length == 0;
}
- (NSInteger)size {
    return self.length;
}
- (NSString *)description {
    NSMutableString *mStr = @"".mutableCopy;
    Node *currentNode = self.head;
    while (currentNode) {
        [mStr appendString:currentNode.data];
        [mStr appendString:@" "];
        currentNode = currentNode.next;
    }
    return mStr;
}
- (NSString *)forwardString{
    NSMutableString *mStr = @"".mutableCopy;
    Node *currentNode = self.tail;
    while (currentNode) {
        [mStr appendString:currentNode.data];
        [mStr appendString:@" "];
        currentNode = currentNode.prev;
    }
    return mStr;
}
- (NSString *)backwardString{
    return self.description;
}
@end

@implementation Node
- (instancetype)initWithData:(id)data{
    if (self = [super init]) {
        self.data = data;
        self.prev = nil;
        self.next = nil;
    }
    return self;
}
@end
