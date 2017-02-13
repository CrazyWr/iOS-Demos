//
//  BSDSocketManager.h
//  SocketDemo
//
//  Created by wei on 2017/2/13.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BSDSocketMsgDelegate <NSObject>

- (void)receiveMsg:(NSString *)msg;

@end


@interface BSDSocketManager : NSObject

@property (weak, nonatomic) id <BSDSocketMsgDelegate> delegate;

+ (instancetype)manager;

- (void)connectIP:(NSString *)IPString port:(NSString *)port;

- (void)disConnect;

- (void)sendMsg:(NSString *)msg;


@end
