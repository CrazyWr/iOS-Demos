//
//  ChildCustomClass.m
//  TestRuntime
//
//  Created by wei on 2016/12/29.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "ChildCustomClass.h"
#import <objc/runtime.h>

@implementation ChildCustomClass

+ (void)load{
    
    Class class = [self class];
    SEL originSEL = @selector(customMethod);
    SEL swizzleSEL = @selector(swizzleMethod);
    
    Method originMethod = class_getInstanceMethod(class, originSEL);
    Method swizzleMethod = class_getInstanceMethod(class, swizzleSEL);
    
    NSLog(@"===========================MethodSwizzlingVC Demo2======================");
    NSLog(@"originMethod IMP:%p  swizzleMethod IMP:%p", method_getImplementation(originMethod), method_getImplementation(swizzleMethod));
    BOOL didAddMethod = class_addMethod(class, originSEL, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    NSLog(@"originMethod IMP:%p  swizzleMethod IMP:%p didAddMethod:%d", method_getImplementation(originMethod), method_getImplementation(swizzleMethod), didAddMethod);
    if (didAddMethod) {
        class_replaceMethod(class, swizzleSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else{
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
    NSLog(@"originMethod IMP:%p  swizzleMethod IMP:%p", method_getImplementation(originMethod), method_getImplementation(swizzleMethod));
    
}

- (void)swizzleMethod{
    NSLog(@"child swizzleMethod running");
    [self swizzleMethod];
}

@end
