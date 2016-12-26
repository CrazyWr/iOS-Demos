//
//  SecondViewController.m
//  ExtendTouchRectDemo
//
//  Created by wei on 2016/12/24.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

typedef void (^blk_t)(id obj);
blk_t blk;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"SecondViewController";
    
    [self captureObject];
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
}

- (void)captureObject
{
    id array = [[NSMutableArray alloc] init];
    blk = ^(id obj) {
        
        [array addObject:obj];
        NSLog(@"array count = %ld  %@", [array count], self);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
