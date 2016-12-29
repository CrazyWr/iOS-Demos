//
//  MethodSwizzlingVC.m
//  TestRuntime
//
//  Created by wei on 2016/12/28.
//  Copyright © 2016年 wei. All rights reserved.
//  blog's address http://southpeak.github.io/2014/11/06/objective-c-runtime-4/
//

#import "MethodSwizzlingVC.h"
#import <objc/runtime.h>

@interface MethodSwizzlingVC ()

@end

@implementation MethodSwizzlingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
    

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        Class class = [self class];
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
       
        NSLog(@"===========================MethodSwizzlingVC Demo======================");
        NSLog(@"originMethod IMP:%p  swizzleMethod IMP:%p", method_getImplementation(originalMethod), method_getImplementation(swizzledMethod));
        
        //这里防止 class没有实现originMethod 而其父类实现了originMethod 下面exchange将会交换父类的方法
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod)
                                            );
        
        NSLog(@"originMethod IMP:%p  swizzleMethod IMP:%p didAddMethod:%d", method_getImplementation(originalMethod), method_getImplementation(swizzledMethod), didAddMethod);
        
        if (didAddMethod) {

            /**    SEL          IMP
             *     origin   ->  swizzle
             *     swizzle  ->  swizzle
             */
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod)
                                );
            /**    SEL          IMP
             *     origin   ->  swizzle
             *     swizzle  ->  origin
             */
        } else {
            /**    SEL          IMP
             *     origin   ->  origin
             *     swizzle  ->  swizzle
             */
            method_exchangeImplementations(originalMethod, swizzledMethod);
            /**    SEL          IMP
             *     origin   ->  swizzle
             *     swizzle  ->  origin
             */
        }
        
        NSLog(@"originMethod IMP:%p  swizzleMethod IMP:%p", method_getImplementation(originalMethod), method_getImplementation(swizzledMethod));
        
    });
    
}

#pragma mark - Method Swizzling
- (void)xxx_viewWillAppear:(BOOL)animated {
//    在swizzling的过程中，方法中的[self xxx_viewWillAppear:animated]已经被重新指定到UIViewController类的-viewWillAppear:中。
//    在这种情况下，不会产生无限循环。
//    不过如果我们调用的是 [self viewWillAppear:animated]，则会产生无限循环，因为这个方法的实现在运行时已经被重新指定为xxx_viewWillAppear:了
    NSLog(@"xxx_viewWillAppear: %@", self);
    [self xxx_viewWillAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear: %@", self);
    [super viewWillAppear:animated];
    
}


@end
