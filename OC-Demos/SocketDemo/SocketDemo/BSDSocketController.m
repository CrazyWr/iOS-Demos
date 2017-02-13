//
//  BSDSocketController.m
//  SocketDemo
//
//  Created by wei on 2017/2/13.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "BSDSocketController.h"
#import "BSDSocketManager.h"


@interface BSDSocketController ()<BSDSocketMsgDelegate>


@property (weak, nonatomic) IBOutlet UITextField *IPTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;


@property (strong, nonatomic) BSDSocketManager *manager;

@end

@implementation BSDSocketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.manager = [BSDSocketManager manager];
    self.manager.delegate = self;
    
}

- (IBAction)disConnect:(UIButton *)sender {
    [self.manager disConnect];
}

- (IBAction)connect:(UIButton *)sender {
    [self.manager connectIP:self.IPTextField.text port:self.portTextField.text];
}

- (IBAction)send:(UIButton *)sender {
    [self.manager sendMsg:self.msgTextField.text];
}

#pragma mark - MsgDelegate
- (void)receiveMsg:(NSString *)msg{
    NSLog(@"%@", msg);
}

@end
