//
//  StickManController.m
//  RotateAnimationDemo
//
//  Created by wei on 2016/12/19.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "StickManController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define Radian(R) (R)/180.0*M_PI

@interface StickManController ()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *stickBgView;

@property (strong, nonatomic) UIView *l1View;
@property (strong, nonatomic) UIView *l2View;
@property (strong, nonatomic) UIView *lKuanView;
@property (strong, nonatomic) UIView *lKneeView;
@property (strong, nonatomic) UIView *lFooterView;

@property (strong, nonatomic) UIView *r1View;
@property (strong, nonatomic) UIView *r2View;
@property (strong, nonatomic) UIView *rKuanView;
@property (strong, nonatomic) UIView *rKneeView;
@property (strong, nonatomic) UIView *rFooterView;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSArray *datas;

@end

@implementation StickManController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViews];
    
    self.datas = [self readDataFromTxtFile];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@", self.navigationController.childViewControllers);
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
}

- (NSArray *)readDataFromTxtFile{
   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@".txt"];
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSData *data = [handle readDataToEndOfFile];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *array = [string componentsSeparatedByString:@"\r"];
    NSMutableArray *datas = [NSMutableArray array];
    for (NSString *dataString in array) {
        NSArray *dataArray = [dataString componentsSeparatedByString:@"\t"];
        dataArray = [self removeNilData:dataArray];
        [datas addObject:dataArray];
    }
    
    return datas;
}

- (NSArray *)removeNilData:(NSArray *)array{
    NSMutableArray *datas = [NSMutableArray array];
    for (NSString *string in array) {
        if (![string isEqualToString:@""]) {
            [datas addObject:string];
        }
    }
    return datas;
}

- (void)initViews{
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, WIDTH-100, HEIGHT-200)];
    self.bgView.layer.borderWidth = 4;
    self.bgView.layer.borderColor = [UIColor blackColor].CGColor;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.clipsToBounds = YES;
    [self.view addSubview:self.bgView];
    
    self.stickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bgView.bounds.size.height*0.25, self.bgView.bounds.size.width, self.bgView.bounds.size.height*0.5)];
    self.stickBgView.backgroundColor = [UIColor greenColor];
    [self.bgView addSubview:self.stickBgView];
    
    //左腿
    self.l1View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 100)];
    self.l1View.backgroundColor = [UIColor blackColor];
    [self.stickBgView addSubview:self.l1View];
    
    self.l2View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 100)];
    self.l2View.backgroundColor = [UIColor blueColor];
    [self.stickBgView addSubview:self.l2View];
    
    self.l1View.layer.anchorPoint = CGPointMake(0.5f, 0.95f);
    self.l2View.layer.anchorPoint = CGPointMake(0.5f, 0.95f);
    
    self.l1View.transform = CGAffineTransformMakeRotation(M_PI);
    self.l1View.center = CGPointMake(self.stickBgView.frame.size.width*0.5, 10);
    
    CGPoint point1 = [self pointFromAnchorPoint:self.l1View angel:M_PI];
    self.l2View.center = point1;
    
    self.lKuanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.lKuanView.backgroundColor = [UIColor lightGrayColor];
    self.lKuanView.layer.cornerRadius = 10;
    [self.stickBgView addSubview:self.lKuanView];
    
    self.lKneeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.lKneeView.backgroundColor = [ UIColor lightGrayColor];
    self.lKneeView.layer.cornerRadius = 10;
    [self.stickBgView addSubview:self.lKneeView];
    
    self.lKuanView.center = self.l1View.center;
    self.lKneeView.center = self.l2View.center;
    
    self.lFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 12)];
    self.lFooterView.backgroundColor = [UIColor lightGrayColor];
    [self.stickBgView addSubview:self.lFooterView];
    self.lFooterView.layer.anchorPoint = CGPointMake(0.2, 0.5);
    
    self.lFooterView.center = [self pointFromAnchorPoint:self.l2View angel:M_PI];
    
    //右腿
    self.r1View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 100)];
    self.r1View.backgroundColor = [UIColor blackColor];
    [self.stickBgView addSubview:self.r1View];
    
    self.r2View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 100)];
    self.r2View.backgroundColor = [UIColor blueColor];
    [self.stickBgView addSubview:self.r2View];
    
    self.r1View.layer.anchorPoint = CGPointMake(0.5f, 0.95f);
    self.r2View.layer.anchorPoint = CGPointMake(0.5f, 0.95f);
    
    self.r1View.transform = CGAffineTransformMakeRotation(M_PI);
    self.r1View.center = CGPointMake(self.stickBgView.frame.size.width*0.5, 10);
    
    CGPoint point2 = [self pointFromAnchorPoint:self.r1View angel:M_PI];
    self.r2View.center = point2;
    
    self.rKuanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.rKuanView.backgroundColor = [UIColor lightGrayColor];
    self.rKuanView.layer.cornerRadius = 10;
    [self.stickBgView addSubview:self.rKuanView];
    
    self.rKneeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.rKneeView.backgroundColor = [ UIColor lightGrayColor];
    self.rKneeView.layer.cornerRadius = 10;
    [self.stickBgView addSubview:self.rKneeView];
    
    self.rKuanView.center = self.r1View.center;
    self.rKneeView.center = self.r2View.center;
    
    self.rFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 12)];
    self.rFooterView.backgroundColor = [UIColor lightGrayColor];
    [self.stickBgView addSubview:self.rFooterView];
    self.rFooterView.layer.anchorPoint = CGPointMake(0.3, 0.5);
    
    self.rFooterView.center = [self pointFromAnchorPoint:self.r2View angel:0];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 210, self.stickBgView.frame.size.width*2, 10)];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapButt;
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.stickBgView.frame.size.width*2, 0)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = line.bounds;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.fillColor = [UIColor blackColor].CGColor;
    layer.path = path.CGPath;
    layer.lineWidth = 3;
    [layer setLineDashPattern:@[@8, @6]];
    
    [line.layer addSublayer:layer];
    line.tag = 100;
    [self.stickBgView addSubview:line];
    
}

- (CGPoint)pointFromAnchorPoint:(UIView *)view angel:(CGFloat)angel{
    
    CGSize size = view.bounds.size;
    CGPoint center = view.center;
    CGFloat length = size.height - 0.1*size.height;
    
    CGPoint result;
    if (angel > M_PI) {
        angel = fabs(M_PI - angel);
        result = CGPointMake(center.x-length*sin(angel), center.y+length*cos(angel));
    }else{
        angel = fabs(M_PI - angel);
        result = CGPointMake(center.x+length*sin(angel), center.y+length*cos(angel));
    }
    
    return result;
}

int count = 0;
- (void)tick{
    
    if (count < self.datas.count) {
        [self caculatePointFromDataArray:self.datas[count]];
        count++;
    }else{
        count = 425;
    }
    
    [self caculateLine];
    
}

- (void)caculatePointFromDataArray:(NSArray *)array{
    
    if (array.count < 4) {
        return;
    }
    
    CGFloat lKuanAngel = M_PI - Radian([array[0] floatValue]*0.01);
    CGFloat lKneeAngel = lKuanAngel + Radian([array[2] floatValue]*0.01);
    CGFloat rKuanAngel = M_PI - Radian([array[1] floatValue]*0.01);
    CGFloat rKneeAngel = rKuanAngel + Radian([array[3] floatValue]*0.01);
    
//    NSLog(@"lKuan:%f lKnee:%f rKuan:%f rKnee:%f", [array[0] floatValue]*0.01, [array[2] floatValue]*0.01, [array[1] floatValue]*0.01, [array[3] floatValue]*0.01);
    
    self.l1View.transform = CGAffineTransformMakeRotation(lKuanAngel);
    CGPoint lKneepoint = [self pointFromAnchorPoint:self.l1View angel:lKuanAngel];
    self.l2View.center = lKneepoint;
    
    self.l2View.transform = CGAffineTransformMakeRotation(lKneeAngel);
    
    self.lKneeView.center = self.l2View.center;
    self.lKuanView.center = self.l1View.center;
    
    self.r1View.transform = CGAffineTransformMakeRotation(rKuanAngel);
    CGPoint rKneepoint = [self pointFromAnchorPoint:self.r1View angel:rKuanAngel];
    self.r2View.center = rKneepoint;
    
    self.r2View.transform = CGAffineTransformMakeRotation(rKneeAngel);
    
    self.rKneeView.center = self.r2View.center;
    self.rKuanView.center = self.r1View.center;
    
    self.lFooterView.center = [self pointFromAnchorPoint:self.l2View angel:lKneeAngel];
    self.rFooterView.center = [self pointFromAnchorPoint:self.r2View angel:rKneeAngel];
}

- (void)caculateLine{
    
    UIView *view = [self.stickBgView viewWithTag:100];
    CGPoint point = view.frame.origin;
    CGSize size = view.frame.size;
    if (point.x < -size.width*0.5) {
        point.x = 0;
    }else{
        point.x -= 0.7;
    }
    view.frame = CGRectMake(point.x, point.y, size.width, size.height);
    
}

- (void)dealloc{
    [self.timer invalidate];
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
