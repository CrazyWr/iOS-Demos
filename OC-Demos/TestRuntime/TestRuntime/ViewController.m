//
//  ViewController.m
//  TestRuntime
//
//  Created by wei on 2016/12/26.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *classStrs;


@end

static NSString *cellIdentity = @"cell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Runtime Test Demo";
    self.titles = @[].mutableCopy;
    self.classStrs  = @[].mutableCopy;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentity];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -20, 0, -20);
    
    
    [self addClassStr:@"ClassAndObjectVC" title:@"Runtime Class&Object Demo"];
    
}

- (void)addClassStr:(NSString *)classStr title:(NSString *)title{
    [self.titles addObject:title];
    [self.classStrs addObject:classStr];
}


#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString(self.classStrs[indexPath.row]);
    
    if (class) {
        UIViewController *vc = [class new];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
        vc.title = self.titles[indexPath.row];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
