//
//  ViewController.m
//  RotateAnimationDemo
//
//  Created by wei on 2016/12/19.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "ViewController.h"
#import "ClockViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (strong, nonatomic) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.titles = [NSArray arrayWithObjects:@"ClockViewController", @"StickManController", nil];
    
    [self initController];

    
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@", self.navigationController.childViewControllers);
}

- (void)initController{
    
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, i*80+100, WIDTH-100, 50)];
        btn.backgroundColor = [UIColor blueColor];
        btn.tag = i+10;
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}

- (void)btnClick:(UIButton *)btn{
    
    NSString *title = self.titles[btn.tag-10];
    UIViewController *obj = (UIViewController *)[[NSClassFromString(title) alloc] init];
    obj.title = self.titles[btn.tag-10];
    if (obj) {
        [self.navigationController pushViewController:obj animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
