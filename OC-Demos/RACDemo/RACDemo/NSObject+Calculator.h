//
//  NSObject+Calculator.h
//  RACDemo
//
//  Created by wei on 2017/4/5.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CaculatorMaker;
@interface NSObject (Calculator)

+ (int)calculate:(void (^)(CaculatorMaker *))block;

@end
