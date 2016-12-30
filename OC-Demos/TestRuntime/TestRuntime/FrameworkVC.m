//
//  FrameworkVC.m
//  TestRuntime
//
//  Created by wei on 2016/12/30.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "FrameworkVC.h"
#import <objc/runtime.h>

@interface FrameworkVC ()

@end

@implementation FrameworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"获取指定类所在动态库");
    NSLog(@"UIView's Framework: %s", class_getImageName(NSClassFromString(@"UIView")));
    NSLog(@"获取指定库或框架中所有类的类名");
    
    unsigned int outCount;
    const char ** classes = objc_copyClassNamesForImage(class_getImageName(NSClassFromString(@"UIView")), &outCount);
    for (int i = 0; i < outCount; i++) {
        NSLog(@"class name: %s", classes[i]);
    }
    
    
}

@end
