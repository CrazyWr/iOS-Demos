//
//  ViewController.m
//  ExtendTouchRectDemo
//
//  Created by wei on 2016/12/22.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ExtendTouchRect.h"
#import "SecondViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"ViewController";
    
    self.btn.touchExtendInset = UIEdgeInsetsMake(-100, -100, -100, -100);
    
}


- (IBAction)btnOnclicked:(UIButton *)sender {
    
    NSLog(@"touched");
    SecondViewController *second = [SecondViewController new];
    [self.navigationController pushViewController:second animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
