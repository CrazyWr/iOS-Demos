//
//  UILabel+storyBoardCreater.m
//  SocketDemo
//
//  Created by wei on 2017/2/13.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "UIViewController+storyBoardCreater.h"

@implementation UIViewController (storyBoardCreater)

+ (instancetype)vcFromNameInStoryBoard:(NSString *)name{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:name];
    return myView;
}

@end
