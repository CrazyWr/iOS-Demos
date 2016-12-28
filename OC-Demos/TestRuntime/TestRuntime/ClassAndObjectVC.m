//
//  Class&ObjectVC.m
//  TestRuntime
//
//  Created by wei on 2016/12/26.
//  Copyright © 2016年 wei. All rights reserved.
//  blog's address http://southpeak.github.io/2014/10/25/objective-c-runtime-1/
//

#import "ClassAndObjectVC.h"
#import <objc/runtime.h>

@interface MyClass : NSObject

@property (strong, nonatomic) NSMutableArray *array;
@property (copy, nonatomic) NSString *string;

- (void)method1;
- (void)method2;
- (void)method3;
+ (void)classMethod1;
+ (void)classMethod2;

@end

@interface MyClass () {
    NSInteger       _instance1;
    NSString    *   _instance2;
}
@property (nonatomic, assign) NSUInteger integer;
- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end

@implementation MyClass
+ (void)classMethod1 {
    
}

+ (void)classMethod2{
    
}

- (void)method1 {
    NSLog(@"call method method1");
}

- (void)method2 {
    
}

- (void)method3 {
    
}

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}
@end



@interface ClassAndObjectVC ()

@end

@implementation ClassAndObjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testMethodsAboutRuntime];
}


/**
 @brief 测试 类和对象相关的方法
 */
- (void)testMethodsAboutRuntime{

    MyClass *myclass = [MyClass new];
    unsigned int outCount = 0;
    Class cls = myclass.class;
    Class meta_class = objc_getMetaClass(class_getName(cls));
    
    //类名
    NSLog(@"class name: %s", class_getName(cls));
    NSLog(@"=================================类名=========================================");
    
    //父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"=================================父类=========================================");
    
    //是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass(cls)) ? @"":@"not");
    NSLog(@"=================================元类========================================");
    
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"================================实例大小==========================================");
    
    //变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"================================成员变量======================================");
    
    //成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name:%s at index:%d, offset:%zu typeEncoding:%s", ivar_getName(ivar), i, ivar_getOffset(ivar), ivar_getTypeEncoding(ivar));
    }
    free(ivars);//手动释放
    
    //通过变量名称获取变量
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string) {
        NSLog(@"\"_string\" instance variable %s", ivar_getName(string));
    }
    NSLog(@"=================================属性=========================================");
    
    //属性操作
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"propert's name is: %s at index %d", property_getName(property), i);
    }
    free(properties);//手动释放
    NSLog(@"===============================属性by名字======================================");
    
    objc_property_t array = class_getProperty(cls, "array");
    if (array) {
        NSLog(@"\"array\" property name: %s, attrubutes:%s", property_getName(array), property_getAttributes(array));
    }
    NSLog(@"================================实例方法========================================");
    
    //方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's name: %s at index:%d", sel_getName(method_getName(method)), i);
    }
    free(methods);
    
    NSLog(@"=================================类方法========================================");
    Method *classMethods = class_copyMethodList(meta_class, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = classMethods[i];
        NSLog(@"classMethod's name: %s at index:%d", sel_getName(method_getName(method)), i);
    }
    free(classMethods);
    
    Method classMethod1 = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod1) {
        NSLog(@"class method: %s", sel_getName(method_getName(classMethod1)));
    }
    
    NSLog(@"MyClass is %@ responsed to selector: method3WithArg1: arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"":@"not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method3WithArg1:arg2:));
    imp();
    NSLog(@"==================================协议======================================");
    
    //协议
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList(cls, &outCount);
    Protocol *protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    
    NSLog(@"MyCLass is %@ reponsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"":@"not", protocol_getName(protocol));
    NSLog(@"==========================================================================");
    
    
    
}



@end
