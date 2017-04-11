//
//  CaculatorMaker.h
//  RACDemo
//
//  Created by wei on 2017/4/5.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculatorMaker : NSObject

@property (nonatomic, assign) int result;

// +
- (CaculatorMaker * (^)(int num))add;

// -
- (CaculatorMaker * (^)(int num))minus;

// *
- (CaculatorMaker * (^)(int num))multy;

// /
- (CaculatorMaker * (^)(int num))divide;

@end
