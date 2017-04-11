//
//  ViewController.m
//  RACDemo
//
//  Created by wei on 2017/4/5.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "CaculatorMaker.h"
#import "NSObject+Calculator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.view).mas_offset(10);
        make.right.bottom.mas_equalTo(self.view).mas_offset(-10);
    }];
    
    //链式编程
    CaculatorMaker *maker = [CaculatorMaker new];
    int result = [maker.add(34).add(10) result];
    
    int result2 = [NSObject calculate:^(CaculatorMaker *maker) {
        maker.add(45).add(20);
    }];
    
    NSLog(@"%d", result2);
    
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
