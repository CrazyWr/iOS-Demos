//
//  AddAssociatedOjectVC.m
//  TestRuntime
//
//  Created by wei on 2016/12/28.
//  Copyright © 2016年 wei. All rights reserved.
//  blog's address http://southpeak.github.io/2014/10/30/objective-c-runtime-2/
//

#import "AddAssociatedOjectVC.h"
#import <objc/runtime.h>

@interface MyTestClass2 : NSObject

@end

@implementation MyTestClass2

@end



@interface AddAssociatedOjectVC ()

@end

static NSString * const key;

@implementation AddAssociatedOjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MyTestClass2 *test = [MyTestClass2 new];
    
    [self addAssociatedObject:test value:@"new value"];
    NSLog(@"associtaed object's value: %@", [self getAssociatedObjectValueWithTarget:test]);
    
}

- (void)addAssociatedObject:(id)target value:(id)value{
    
    if (objc_getAssociatedObject(target, &key)) {
        return;
    }
    objc_setAssociatedObject(target, &key, value, OBJC_ASSOCIATION_RETAIN);
    
}

- (id)getAssociatedObjectValueWithTarget:(id)target{
    id obj = objc_getAssociatedObject(target, &key);
    if (obj) {
        return obj;
    }
    return nil;
}

@end
