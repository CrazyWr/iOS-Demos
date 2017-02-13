//
//  ViewController.m
//  SocketDemo
//
//  Created by wei on 2017/2/9.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+storyBoardCreater.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *classnames;
@property (strong, nonatomic) NSMutableArray *titles;

@end

NSString * const cellIdentity = @"cellIdentity";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"SocketDemo";
    self.titles = @[].mutableCopy;
    self.classnames = @[].mutableCopy;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentity];
    
    [self addItemTitle:@"BSDSocketManagerDemo" className:@"BSDSocketController"];
    
    [self.tableView reloadData];
}

- (void)addItemTitle:(NSString *)title className:(NSString *)classname{
    [self.classnames addObject:classname];
    [self.titles addObject:title];
}

#pragma mark - TalbeView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    Class c = NSClassFromString(self.classnames[indexPath.row]);
    UIViewController *vc = [UIViewController vcFromNameInStoryBoard:self.classnames[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
