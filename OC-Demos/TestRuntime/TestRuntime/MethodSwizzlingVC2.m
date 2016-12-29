//
//  MethodSwizzlingVC2.m
//  TestRuntime
//
//  Created by wei on 2016/12/29.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "MethodSwizzlingVC2.h"
#import "ChildCustomClass.h"

@interface MethodSwizzlingVC2 ()

@end

@implementation MethodSwizzlingVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //验证class未实现originMethod 父类实现originMethod时的方法执行
    ChildCustomClass *custom = [ChildCustomClass new];
    [custom customMethod];
    
    NSLog(@"custom class: %@", [custom class]);
    NSLog(@"custom's class: %@", [custom superclass]);
    
    NSLog(@"self class: %@", [self class]);
    NSLog(@"super class: %@", [super class]);
    
    
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    
    BOOL res3 = [(id)[ChildCustomClass class] isKindOfClass:[ChildCustomClass class]];
    BOOL res4 = [(id)[ChildCustomClass class] isMemberOfClass:[ChildCustomClass class]];
    
    NSLog(@"%d %d %d %d", res1, res2, res3, res4);
    
}

@end
