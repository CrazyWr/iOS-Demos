//
//  NSObject+Calculator.m
//  RACDemo
//
//  Created by wei on 2017/4/5.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "NSObject+Calculator.h"
#import "CaculatorMaker.h"
@implementation NSObject (Calculator)

+ (int)calculate:(void (^)(CaculatorMaker * maker))block{
    CaculatorMaker *maker = [CaculatorMaker new];
    block(maker);
    return maker.result;
}

@end
