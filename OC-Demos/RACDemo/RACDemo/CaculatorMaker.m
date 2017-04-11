//
//  CaculatorMaker.m
//  RACDemo
//
//  Created by wei on 2017/4/5.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "CaculatorMaker.h"

@implementation CaculatorMaker

// +
- (CaculatorMaker * (^)(int num))add{
    return ^(int num){
        _result += num;
        return self;
    };
}


// -
- (CaculatorMaker *(^)(int))minus{
    return ^(int num){
        _result -= num;
        return self;
    };
}

// *
- (CaculatorMaker *(^)(int))multy{
    return ^(int num){
        _result *= num;
        return self;
    };
}

// /
- (CaculatorMaker *(^)(int))divide{
    return ^(int num){
        _result /= num;
        return self;
    };
}
@end
