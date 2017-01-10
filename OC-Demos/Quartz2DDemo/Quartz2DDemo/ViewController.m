//
//  ViewController.m
//  Quartz2DDemo
//
//  Created by wei on 2016/12/30.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *classStr;
@property (nonatomic, strong) NSMutableArray *cellLabels;

@end

static NSString * const identity = @"cellIdentity";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Quartz2d Demo";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identity];
    
    
}

- (void)addClassStr:(NSString *)classStr cellLabel:(NSString *)labelStr{
    
    [self.classStr addObject:classStr];
    [self.cellLabels addObject:labelStr];
    
}


#pragma mark - UITableViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.classStr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity forIndexPath:indexPath];
    cell.textLabel.text = self.cellLabels[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString(self.classStr[indexPath.row]);
    if (class) {
        UIViewController *vc = [class new];
        vc.title = self.cellLabels[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
