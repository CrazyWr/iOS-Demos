//
//  ViewController.m
//  TestBlurEffectDemo
//
//  Created by wei on 2017/1/2.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initView];

}


- (void)initView{
    
    UIImage *image = [UIImage imageNamed:@"pic6.jpeg"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = image;
//    [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://www.vgocool.com:8300/Image/Business/HeadPic/8_20160908171908_532847481956228789.jpg"] placeholderImage:image options:SDWebImageAllowInvalidSSLCertificates];
    [self.view addSubview:imageView];
    
    
    UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
    blur.center = self.view.center;
    blur.translatesAutoresizingMaskIntoConstraints = false;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blur.effect = blurEffect;
    [self.view addSubview:blur];
    
    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
    vibrancyView.effect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    [blur.contentView addSubview:vibrancyView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, blur.frame.size.width, 100)];
    label.center = blur.contentView.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:26];
    label.textColor = [UIColor whiteColor];
    label.text = @"Blur Effect";
    
    [vibrancyView.contentView addSubview:label];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
