//
//  UILabel+storyBoardCreater.h
//  SocketDemo
//
//  Created by wei on 2017/2/13.
//  Copyright © 2017年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (storyBoardCreater)

+ (instancetype)vcFromNameInStoryBoard:(NSString *)name;

@end
