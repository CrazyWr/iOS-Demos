//
//  ClockViewController.m
//  RotateAnimationDemo
//
//  Created by wei on 2016/12/19.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "ClockViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ClockViewController ()

@property (nonatomic, strong) UIView *hourHand;
@property (nonatomic, strong) UIView *minuteHand;
@property (nonatomic, strong) UIView *secondHand;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    //set initial hand positions
    [self initViews];
    [self tick];
}

- (void)initViews{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(50, 200, WIDTH-100, WIDTH-100)];
    bgView.layer.borderWidth = 4;
    bgView.layer.borderColor = [UIColor blackColor].CGColor;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    CGPoint center = CGPointMake(bgView.bounds.size.width * 0.5, bgView.bounds.size.height * 0.5);
    
    self.hourHand = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 80)];
    self.minuteHand = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 100)];
    self.secondHand = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 120)];
    
    [bgView addSubview:self.hourHand];
    [bgView addSubview:self.minuteHand];
    [bgView addSubview:self.secondHand];
    
    self.hourHand.backgroundColor = [UIColor blackColor];
    self.minuteHand.backgroundColor = [UIColor blueColor];
    self.secondHand.backgroundColor = [UIColor redColor];
    
    self.hourHand.center = center;
    self.minuteHand.center = center;
    self.secondHand.center = center;
    
    //设置锚点
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
}

- (void)tick{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute| NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    //calculate hour hand angle //calculate minute hand angle
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    //calculate second hand angle
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    //rotate hands
    self.hourHand.transform = CGAffineTransformMakeRotation(hoursAngle);
    self.minuteHand.transform = CGAffineTransformMakeRotation(minsAngle);
    self.secondHand.transform = CGAffineTransformMakeRotation(secsAngle);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
