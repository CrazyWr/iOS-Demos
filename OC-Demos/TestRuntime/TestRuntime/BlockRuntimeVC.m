//
//  BlockRuntimeVC.m
//  TestRuntime
//
//  Created by wei on 2016/12/30.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "BlockRuntimeVC.h"
#import <objc/runtime.h>

@interface MyTestClass4 : NSObject

@end

@implementation MyTestClass4



@end


@interface BlockRuntimeVC ()

@end

@implementation BlockRuntimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MyTestClass4 *test = [MyTestClass4 new];
    
    void (^block)(id obj, NSString *str) = ^(id obj, NSString *str){
        NSLog(@"str %@", str);
    };
    
    IMP imp = imp_implementationWithBlock(block);
    BOOL didAddMethod = class_addMethod([test class], @selector(addMethod:), imp, "v@:");
    
    if (didAddMethod) {
        [test performSelector:@selector(addMethod:) withObject:@"通过 block 添加 method "];
    }
    
    
}



@end
