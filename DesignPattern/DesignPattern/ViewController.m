//  ViewController.m
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/3.
//  Copyright © 2019年 冯铁军. All rights reserved.
//

#import "ViewController.h"
#import "Milk.h"
#import "SimpleFactory.h"
#import "YiliMilkFactory.h"
#import "GuangmingMilkFactory.h"
#import "BMWCarFactory.h"
#import "VWCarFactory.h"
#import "BWThread.h"
#import "BWProxy.h"
#import "DoublyLinkedList.h"
@interface ViewController ()
//@property (strong, nonatomic) NSThread *thread;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self binary_search:19 arr:@[@1,@4,@8,@19,@33,@44,@85,@87]];
    NSMutableArray *mArr = @[@33,@99,@4,@8,@57,@33,@45,@85,@87,@44,@99,@10,@19,@8,@83].mutableCopy;
//    NSArray *arr = [self lomuto_quick_sort:mArr lowIndex:0 highIndex:mArr.count-1];
//    NSLog(@"%@",arr);
//    [self selection_sort:mArr];
//    [self _quick_sort:mArr lowIndex:0 highIndex:mArr.count-1];
//    [self bubble_sort:mArr];
//    [self insertion_sort:mArr];
//    [self shell_sort:mArr];
//    [self merge_sort:mArr];
//    [self heap_sort:mArr];
    
}
- (void)heap_sort:(NSMutableArray *)arr{
    NSInteger count = arr.count;
    NSInteger start = (count - 2) / 2;
    while (start >= 0) {
        [self shiftDownArray:arr start:start end:arr.count-1];
        start--;
    }
    NSInteger end = count - 1;
    while (end > 0) {
        [arr exchangeObjectAtIndex:end withObjectAtIndex:0];
        [self shiftDownArray:arr start:0 end:end - 1];
        end--;
    }
    NSLog(@"%@",arr);
}
- (void)shiftDownArray:(NSMutableArray *)arr start:(NSInteger)startIndex end:(NSInteger)endIndex{
    NSInteger root = startIndex;
    while ((root * 2 + 1) <= endIndex) {
        NSInteger child = root * 2 + 1;
        if (child + 1 <= endIndex && [arr[child] integerValue] < [arr[child+1] integerValue]) {
            child++;
        }
        if ([arr[root] integerValue] < [arr[child] floatValue]) {
            [arr exchangeObjectAtIndex:root withObjectAtIndex:child];
            NSLog(@"%@",arr);
            root = child;
        } else {
            return;
        }
    }
}
- (NSMutableArray *)merge_sort:(NSMutableArray *)arr{
    NSInteger length = arr.count;
    if (length < 2) {
        return arr;
    }
    NSInteger middle = length / 2;
    NSMutableArray *left = [[arr subarrayWithRange:NSMakeRange(0, middle)] mutableCopy];
    NSMutableArray *right = [[arr subarrayWithRange:NSMakeRange(middle, length - middle)] mutableCopy];
    arr = [self merge:[self merge_sort:left] right:[self merge_sort:right]];
   NSLog(@"%@",arr);
    return arr;
    
}
- (NSMutableArray *)merge:(NSMutableArray *)left right:(NSMutableArray *)right {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:left.count+right.count];
    while (left.count > 0 && right.count > 0) {
        if ([left.firstObject integerValue] <= [right.firstObject integerValue]) {
            [result addObject:left.firstObject];
            [left removeObjectAtIndex:0];
        } else {
            [result addObject:right.firstObject];
            [right removeObjectAtIndex:0];
        }
    }
    while (left.count) {
        [result addObject:left.firstObject];
        [left removeObjectAtIndex:0];
    }
    while (right.count) {
        [result addObject:right.firstObject];
        [right removeObjectAtIndex:0];
    }
    return result;
}
- (void)shell_sort:(NSMutableArray *)arr{
    NSInteger gap = arr.count/2;
    while (gap > 0) {
        for (int k = 0; k<gap; k++) {
          for (NSInteger i=gap+k; i<arr.count; i+=gap) {
              NSInteger currentValue = [arr[i] integerValue];
              NSInteger pos = i;
              while (pos >= gap && [arr[pos - gap] integerValue] > currentValue) {
                  arr[pos] = arr[pos - gap];
                  pos -= gap;
              }
              arr[pos] = @(currentValue);
              NSLog(@"---%@",arr);
            }
        }
        
        gap = gap/2;
    }
    NSLog(@"result---%@",arr);

}

- (void)insertion_sort:(NSMutableArray *)arr{
    for (int i=0; i<arr.count-1; i++) {
//        NSInteger temp = [arr[i-1] integerValue];
        for (int j=i+1; j > 0; j--) {
            if ([arr[j-1] integerValue] > [arr[j] integerValue]) {
                [arr exchangeObjectAtIndex:j-1 withObjectAtIndex:j];
            } else {
                break;
            }
        }
        
    }
    NSLog(@"%@",arr);
}
- (void)bubble_sort:(NSMutableArray *)arr{
    for (int i=0; i<arr.count; i++) {
        for (int j=1; j<arr.count-i; j++) {
            if ([arr[j] integerValue] < [arr[j-1] integerValue]) {
                [arr exchangeObjectAtIndex:j-1 withObjectAtIndex:j];
            }
        }
    }
    NSLog(@"%@",arr);
}
- (NSArray *)_quick_sort:(NSMutableArray *)arr lowIndex:(NSInteger)low highIndex:(NSInteger)high{
    NSInteger i = low;
    NSInteger j = high;
    NSInteger pivot = [arr[(low+high)/2] integerValue];
    do {
        while (([arr[i] integerValue] < pivot) && (i<high)) {
            i++;
        }
        while (([arr[j] integerValue] > pivot) && (j > low)) {
            j--;
        }
        if (i <= j) {
            [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
            i++;
            j--;
        }
    } while (i<=j);
    if (low < j) {
        [self _quick_sort:arr lowIndex:low highIndex:j];
    }
    if (high > i) {
        [self _quick_sort:arr lowIndex:i highIndex:high];
    }
    return arr;
}
//从第low个元素开始,到high结束 大于设定值,j+1,小于设定值,交换i和j的值,并将i+1,j+1. 循环结束,将i的值与j的值交换
//low~i-1  小于预定值的范围  i+1~high大于预定值的范围
- (NSArray *)lomuto_quick_sort:(NSMutableArray *)arr lowIndex:(NSInteger)low highIndex:(NSInteger)high{
    if (low >= high) {
        return arr;
    }
    NSInteger pivot = [arr[high] integerValue];
    NSInteger i = low;
    NSInteger j = low;
    int k = low;
    while (k < high) {
        NSInteger temp = [arr[k] integerValue];
        if (temp >= pivot) {
            j ++;
        } else {
            [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
            i++;
            j++;
        }
        k++;
    }
    [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
    [self lomuto_quick_sort:arr lowIndex:low highIndex:i-1];
    [self lomuto_quick_sort:arr lowIndex:i+1 highIndex:high];
    return arr;
}
- (NSArray *)quick_sort:(NSMutableArray *)arr{
    if (arr.count < 2) {
        return arr;
    }
    NSMutableArray *smallArr = @[].mutableCopy;
    NSMutableArray *bigArr = @[].mutableCopy;
    NSMutableArray *equal = @[].mutableCopy;
    NSInteger sample = [arr.firstObject integerValue];
    [arr removeObjectAtIndex:0];
    [arr addObject:@(sample)];
    for (int i=0; i<arr.count; i++) {
        if ([arr[i] integerValue] > sample) {
            [bigArr addObject:arr[i]];
        } else if ([arr[i] integerValue] < sample) {
            [smallArr addObject:arr[i]];
        } else {
            [equal addObject:arr[i]];
        }
    }
    NSArray *small = [self quick_sort:smallArr];
    NSArray *big = [self quick_sort:bigArr];
    small = [small arrayByAddingObjectsFromArray:equal];
    big = [small arrayByAddingObjectsFromArray:big];
    return big;
}
- (void)selection_sort:(NSMutableArray *)arr{
    for (int i = 0; i<arr.count; i++) {
        int min = i;
        for (int j = i + 1; j < arr.count; j++) {
                   if ([arr[j] intValue] < [arr[min] intValue]) {
                       min = j;
                   }
        }
        NSNumber *temp = arr[min];
        arr[min] = arr[i];
        arr[i] = temp;
    }
    NSLog(@"%@",arr);
    
}
- (int)find_smallest:(NSArray *)arr{
    int min = [arr.firstObject intValue];
    for (NSNumber *number in arr) {
        if (min>number.intValue) {
            min = number.intValue;
        }
    }
    return min;
}

- (void)simpleFactory{
    Milk *milk = [SimpleFactory milkWithType:0];
    NSLog(@"%@",milk);
}
- (void)factoryMethod{
    Milk *gm = [GuangmingMilkFactory createMilk];
    Milk *yl = [YiliMilkFactory createMilk];
    NSLog(@"%@",gm);
    NSLog(@"%@",yl);
}
- (void)abstractFactory{
    Engine *bmwEngine = [BMWCarFactory createEngine];
    Tyre *bmwTyre = [BMWCarFactory createTyre];
    Glass *bmwGlass = [BMWCarFactory createGlass];

}
- (void)test{
    NSLog(@"%s",__func__);
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
    [self.timer invalidate];
}

@end
