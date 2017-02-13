//
//  BSDSocketManager.m
//  SocketDemo
//
//  Created by wei on 2017/2/13.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "BSDSocketManager.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>


@interface BSDSocketManager ()

@property (nonatomic, assign) int clientSocket;

@end

@implementation BSDSocketManager

+ (instancetype)manager{
    static BSDSocketManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BSDSocketManager alloc] init];

    });
    
    return manager;
}

- (void)initSocketIP:(NSString *)IPString port:(NSString *)port{
    //每次连接前  先断开连接
    if(_clientSocket != 0){
        [self disConnect];
        _clientSocket = 0;
    }
    
    //创建客户端socket
    _clientSocket = CreateClientSocket();
    
    //服务器IP
    const char *server_IP = [IPString cStringUsingEncoding:NSUTF8StringEncoding];
    //服务器端口
    short server_port = (short)[port intValue];
    
    //等于0 说明连接失败
    if (ConnetionToServer(_clientSocket, server_IP, server_port) == 0){
        NSLog(@"Connect to server %s:%hd error", server_IP, server_port);
        return;
    }else{
        [self pullMsg];
    }
    
    //连接成功
    NSLog(@"Connect to server %s:%hd success", server_IP, server_port);
    
}

static int CreateClientSocket(){
    int clientSocket = 0;
    //创建一个socket, 返回值为int (socket 其实就是Int 类型)
    //第一个的参数addressFamily IPv4(AF_INET) || IPv6(AF_INET6)
    //第二个参数 type 表示 socket 的类型,  通常是流stream(SOCK_STREAM) 或 数据报文datagram(SOCK_DGRAM)
    //第三个参数protocol 参数通常设置为0, 以便系统自动为选择我们合适的协议, 对于 stream socket来说会是 TCP 协议(IPPROTO_TCP), 而对于datagram来说会是UDP协议(IPPROTO_UDP)
    
    clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    return clientSocket;
}

static int ConnetionToServer(int client_socket, const char *server_ip, unsigned short port){
    //生成一个sockaddr_in类型结构体
    struct sockaddr_in sAddr = {0};
    sAddr.sin_len = sizeof(sAddr);
    
    //设置IPv4
    sAddr.sin_family = AF_INET;
    
    //inet_aton 是一个改进的方法来将一个字符串IP地址转换为一个32位的网络序列IP地址
    //如果这个函数成功, 函数的返回值非零, 如果输入地址不正确则会返回零
    inet_aton(server_ip, &sAddr.sin_addr);
    
    //htons是将整型变量从主机字节 顺序转变成网络字节顺序, 赋值端口号
    sAddr.sin_port = htons(port);
    
    //用socket和服务端地址 发起连接
    //客户端特定网络地址的服务器发送链接请求, 链接成功返回0, 失败返回-1
    //注意: 该接口调用会阻塞当前线程, 知道服务器返回
    if (connect(client_socket, (struct sockaddr *)&sAddr, sizeof(sAddr)) == 0){
        return client_socket;
    }
    
    return 0;
    
}

#pragma mark - 新线程来接收消息
- (void)pullMsg{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(receiveAction) object:nil];
    [thread start];
}

#pragma mark - 对外逻辑
- (void)connectIP:(NSString *)IPString port:(NSString *)port{
    [self initSocketIP:IPString port:port];
}

- (void)disConnect{
    //关闭连接
    close(self.clientSocket);
}

- (void)sendMsg:(NSString *)msg{
    const char *send_Message = [msg UTF8String];
    send(self.clientSocket, send_Message, strlen(send_Message)+1, 0);
    
}

- (void)receiveAction{
    while (1) {
        char recv_Message[1024] = {0};
        recv(self.clientSocket, recv_Message, sizeof(recv_Message), 0);
        [self.delegate receiveMsg:[NSString stringWithFormat:@"%s", recv_Message]];
    }
}

@end
