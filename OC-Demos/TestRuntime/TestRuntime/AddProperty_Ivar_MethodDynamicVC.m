//
//  AddProperty_Ivar_MethodDynamicVC.m
//  TestRuntime
//
//  Created by wei on 2016/12/27.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "AddProperty_Ivar_MethodDynamicVC.h"
#import <objc/runtime.h>

@interface MyTestClass : NSObject

@property (strong, nonatomic) NSMutableArray *array;
@property (copy, nonatomic) NSString *string;

- (void)method1;
+ (void)classMethod1;

@end

@interface MyTestClass () {
    NSInteger       _instance1;
    NSString    *   _instance2;
}
@property (nonatomic, assign) NSUInteger integer;
- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end

@implementation MyTestClass
+ (void)classMethod1 {
    
}

- (void)method1 {
    NSLog(@"call method method1");
}

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}

@end


@interface AddProperty_Ivar_MethodDynamicVC ()

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

@implementation AddProperty_Ivar_MethodDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self ex_registerClassPair];
    
}

/**
 @brief 运行时创建一个TestClass类 superClass NSError, 添加一个方法testMetaClass方法, 执行的是TestMetaClass方法的内容
 */
- (void)ex_registerClassPair {
    
    Class newClass = objc_allocateClassPair([MyTestClass class], "TestClass", 0);
    //添加实例 -- 必须是动态添加的类可以添加实例, 已存在的类无法添加
    //    class_addIvar(newClass, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    [self addIvarWithtarget:newClass withPropertyName:@"_ivar2" withValue:@"ivar2Value"];
    //添加方法
    class_addMethod(newClass, NSSelectorFromString(@"testMetaClass"), (IMP)TestMetaClass, "v@:");
    //添加属性 -- 但是无法调用(没有 set get方法)
    [self  addPropertyWithTarget:newClass propertyName:@"property2"];
    
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] init];
    [instance performSelector:@selector(testMetaClass)];
    
    Ivar ivar = class_getInstanceVariable(newClass, "_ivar2");
    object_setIvar(instance, ivar, @"ivar2Valuesss");
    id ivar2Value = [self getIvarValueWithTarget:instance withPropertyName:@"_ivar2"];
    NSLog(@"%@", ivar2Value);
    
    [instance performSelector:@selector(setProperty2:) withObject:@"property2Value"];
    NSLog(@"property2's value: %@", [instance performSelector:@selector(property2)]);
    
    
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(newClass, &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name:%s", property_getName(property));
    }
    
    NSLog(@"%@", instance);
}

#pragma - mark Ivar
/**
 @brief add ivar
 
 @param target class
 @param propertyName propertyName description
 @param value judge ivar's type by value
 */
- (void)addIvarWithtarget:(Class)target withPropertyName:(NSString *)propertyName withValue:(id)value {
    
    const char * type = @encode(typeof(value));
    BOOL add = class_addIvar(target, [propertyName UTF8String], sizeof(typeof(value)), log2(sizeof(typeof(value))), type);
    
    if (add) {
        NSLog(@"创建实例Ivar成功");
    }else{
        NSLog(@"创建实例Ivar失败");
    }
    
}


/**
 @brief 获取目标target的指定属性值

 @param target target description
 @param propertyName propertyName description
 @return return value description
 */
- (id)getIvarValueWithTarget:(id)target withPropertyName:(NSString *)propertyName {
    Ivar ivar = class_getInstanceVariable([target class], [propertyName UTF8String]);
    if (ivar) {
//        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = object_getIvar(target, ivar);
        return value;
    } else {
        return nil;
    }
}


#pragma mark - Property
- (void)addPropertyWithTarget:(Class)cls propertyName:(NSString *)propertyName {
   
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = {"C", ""};//C -> Copy
    objc_property_attribute_t backingivar = {"V", "_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    BOOL add = class_addProperty(cls, [propertyName UTF8String], attrs, 3);
    
    if (add){
        NSLog(@"添加属性成功");
    }else{
        NSLog(@"添加属性失败");
    }
    
    //添加get和set方法
//    class_addMethod(cls, NSSelectorFromString(propertyName), (IMP)getter, "@@:");
//    class_addMethod(cls, NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]]), (IMP)setter, "v@:@");
    
}

@end
