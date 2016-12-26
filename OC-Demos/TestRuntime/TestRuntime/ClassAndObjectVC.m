//
//  Class&ObjectVC.m
//  TestRuntime
//
//  Created by wei on 2016/12/26.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "ClassAndObjectVC.h"
#import <objc/runtime.h>

@interface MyClass : NSObject

@property (strong, nonatomic) NSMutableArray *array;
@property (copy, nonatomic) NSString *string;

- (void)method1;
- (void)method2;
+ (void)classMethod1;

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

- (void)method1 {
    NSLog(@"call method method1");
}

- (void)method2 {
    
}

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}
@end

@interface ClassAndObjectVC ()

@end

void TestMetaClass(id self, SEL _cmd){
    NSLog(@"This objcet is %p", self);
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", objc_getClass(class_getName([NSObject class])));
}

@implementation ClassAndObjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self ex_registerClassPair];
    
    [self testMethodsAboutRuntime];
}


/**
 @brief 运行时创建一个TestClass类 superClass NSError, 添加一个方法testMetaClass方法, 执行的是TestMetaClass方法的内容
 */
- (void)ex_registerClassPair {
    
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass)];
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
    NSLog(@"==========================================================================");
    
    //父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================================");
    
    //是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass(cls)) ? @"":@"not");
    NSLog(@"==========================================================================");
    
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================================");
    
    //变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================================");
    
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
    NSLog(@"==========================================================================");
    
    //属性操作
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"propert's name is: %s at index %d", property_getName(property), i);
    }
    free(properties);//手动释放
    NSLog(@"==========================================================================");
    
    objc_property_t array = class_getProperty(cls, "array");
    if (array) {
        NSLog(@"\array\" property %s, attrubutes:%s", property_getName(array), property_getAttributes(array));
    }
    NSLog(@"==========================================================================");
    
    //方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's name: %s at index:%d", method_getName(method), i);
    }
    free(methods);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
