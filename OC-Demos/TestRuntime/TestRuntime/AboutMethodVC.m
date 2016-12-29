//
//  AboutMethodVC.m
//  TestRuntime
//
//  Created by wei on 2016/12/28.
//  Copyright © 2016年 wei. All rights reserved.
//  blog's address http://southpeak.github.io/2014/11/03/objective-c-runtime-3/
//

#import "AboutMethodVC.h"
#import <objc/runtime.h>

@interface MyTestClass3 : NSObject

@property (strong, nonatomic) NSArray *array;
@property (copy, nonatomic) NSString *string;

+ (void)classMethod;
- (void)method1;

@end

@implementation MyTestClass3

+ (void)classMethod{
    NSLog(@"calss method running");
}

- (void)method1{
    NSLog(@"method1 running");
}

- (void)method2{
    NSLog(@"method2 running");
}

- (void)method4{
    NSLog(@"method4 running");
}

- (void)method5{
    NSLog(@"method5 running");
}

@end


@interface AboutMethodVC ()

@end

@implementation AboutMethodVC{
    MyTestClass3 *_test;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _test = [MyTestClass3 new];
    
    unsigned int outcount;
    Method *methods = class_copyMethodList([_test class],
                                           &outcount);
    for (int i = 0; i < outcount; i++) {
        Method method = methods[i];
        NSLog(@"%@'s method - %@ - index: %d", [_test class], NSStringFromSelector(method_getName(method)), i);
    }
    
    Method classMethod = class_getClassMethod([_test class], NSSelectorFromString(@"classMethod"));
    Method method1 = class_getInstanceMethod([_test class], NSSelectorFromString(@"method1"));
    Method method2 = class_getInstanceMethod([_test class], NSSelectorFromString(@"method2"));
    
    //只是一个指向方法的指针（准确的说，只是一个根据方法名hash化了的KEY值，能唯一代表一个方法
    SEL sel = NSSelectorFromString(@"method1");
    //执行代码的地址
    IMP imp = class_getMethodImplementation([_test class], sel);
    NSLog(@"runtimeMethod Sel:%p  IMP:%p", sel, imp);
    
    struct objc_method_description * des = method_getDescription(method1);
    NSLog(@"method desc:%@  %s", NSStringFromSelector(des->name), des->types);
    
    //string describing a method's parameter and return types
    const char * methodImple = method_getTypeEncoding(method1);
    NSLog(@"string describing a method's parameter and return types: %s", methodImple);
    
    //参数个数  隐形参数  (id self, SEL _cmd)
    int argumentCoutn = method_getNumberOfArguments(method1);
    NSLog(@"argumentCount: %d", argumentCoutn);
    
    //
    char * type = method_copyArgumentType(method1, 0);
    NSLog(@"type: %s", type);
    
    //交换方法实现
    method_exchangeImplementations(method1, method2);
    if([_test respondsToSelector:@selector(method1)]){
        [_test performSelector:@selector(method1)];
    }
    
    /**   消息转发机制
     *
     *      1.动态方法解析  +resolveInstanceMethod:(实例方法) || +resolveClassMethod:(类方法)
     *      2.备用接收者    - (id)forwardingTargetForSelector:(SEL)aSelector
     *      3.完整转发
     */
    
    //  通过重写 +resolveInstanceMethod:(实例方法)
    //  动态添加 Method3 实例方法
    //  警告  暂时没办法消除
//    [self performSelector:@selector(method3)];
    [self performSelector:NSSelectorFromString(@"method3")];
    
    //  通过重写 - (id)forwardingTargetForSelector:(SEL)aSelector
    //  将 method4 实现 转发给_test 实现
    //  无法操作消息函数 返回值
//    [self performSelector:@selector(method4)];
    [self performSelector:NSSelectorFromString(@"method4")];
    
    //
//    [self performSelector:@selector(method5)];
    [self performSelector:NSSelectorFromString(@"method5")];
    
    
}

//动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"method3"]) {
        class_addMethod(self.class,
                        NSSelectorFromString(@"method3"),
                        (IMP)functionForMethod3,
                        "V@:");
    }
    return [super resolveInstanceMethod:sel];
}

void functionForMethod3(id self, SEL _cmd){
    NSLog(@"method3 running");
}


//备用接收者
- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    NSString *selectorString = NSStringFromSelector(aSelector);
    if ([selectorString isEqualToString:@"method4"]) {
        return _test;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}


//完整转发 最后机会
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    if ([MyTestClass3 instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_test];
        NSLog(@"method5 invocation: %@", anInvocation);
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([MyTestClass3 instancesRespondToSelector:aSelector]) {
            signature = [MyTestClass3 instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;
}


@end
