//
//  AdditionalButtonAnimationVC.m
//  UITableView
//
//  Created by Guangquan Yu on 2018/4/1.
//  Copyright © 2018年 YUGQ. All rights reserved.
//

#import "AdditionalButtonAnimationVC.h"

@interface AdditionalButtonAnimationVC ()<UIScrollViewDelegate, CAAnimationDelegate>
@property(nonatomic, strong)UIScrollView * scrollView;
@property(nonatomic, strong)UIButton * additionalButton;

@property(nonatomic, assign)BOOL startAnimationEnd; // 开始动画是否结束
@property(nonatomic, assign)BOOL startEnd_EndNOEnd; // 开始动画结束，结束动画未开始
@property(nonatomic, assign)BOOL endAnimationEnd; // 结束动画是否结束

@end

@implementation AdditionalButtonAnimationVC

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _startAnimationEnd = YES;
    _endAnimationEnd = YES;
    _startEnd_EndNOEnd = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.additionalButton];
    
    CGFloat navHeight = 64;
    for (int i=0; i<10; i++) {
        UIImageView * imgV =[UIImageView new];
        imgV.frame = CGRectMake(10, 10 + i*(500+10) + navHeight, 300, 500);
        imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]];
        [self.scrollView addSubview:imgV];
    }
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-5); //全屏
    self.scrollView.contentSize =CGSizeMake([UIScreen mainScreen].bounds.size.width, 10 + 10*(500+10)+ navHeight);
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        scroll.backgroundColor = [UIColor redColor];
        scroll.scrollEnabled = YES;
        scroll.pagingEnabled = NO;
        scroll.bounces = YES;
        scroll.delegate = self;
        _scrollView = scroll;
        
        
    }
    return _scrollView;
}


-(UIButton *)additionalButton{
    if (!_additionalButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(300, 500, 60, 60);
        button.tintColor = [UIColor blackColor];
        UIImage * img = [UIImage imageNamed:@"14"];
        [button setImage:img forState:0];
//        [button addTarget:self action:@selector(leftAction) forControlEvents:64];
        _additionalButton = button;
    }
    return _additionalButton;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self additionalButtonStartAnimation];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [self performSelector:@selector(additionalButtonEndAnimation) withObject:nil afterDelay:1.5];

}


- (void)additionalButtonStartAnimation{
    if (_endAnimationEnd == YES && _startAnimationEnd == YES && _startEnd_EndNOEnd == NO) {
        _startAnimationEnd = NO;
        
        
        // 1、设置最终状态
        CGAffineTransform t = CGAffineTransformMakeScale(0.0 , 0.0);
        [self.additionalButton.layer setAffineTransform:t];
        
        // 2、添加一个动画【不影响实际的缩放】
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@1.1 ,@0.8, @0.3,@0.0,@0.0];
        animation.duration = 0.5;
        animation.calculationMode = kCAAnimationCubic;
        animation.removedOnCompletion = YES;
        animation.delegate = self;
        // 自定义动画名称
        [animation setValue:@"开始动画-缩小" forKey:@"animationName"];
        [self.additionalButton.layer addAnimation:animation forKey:@"transform.scale"];
    }
    
}

- (void)additionalButtonEndAnimation{
    if (_startEnd_EndNOEnd == YES) {
        _startAnimationEnd = YES;
        _endAnimationEnd = NO;
        _startEnd_EndNOEnd = NO;
        
        
        // 1、设置最终状态
        CGAffineTransform t = CGAffineTransformMakeScale(1.0 , 1.0);
        [self.additionalButton.layer setAffineTransform:t];
        
        // 2、添加一个动画【不影响实际的缩放】
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@0.2 ,@0.5, @1.3,@0.8,@1.0];
        animation.duration = 0.5;
        animation.delegate = self;
        animation.calculationMode = kCAAnimationCubic;
        //    animation.removedOnCompletion = YES;
        // 自定义动画名称
        [animation setValue:@"结束动画-放大" forKey:@"animationName"];
        [self.additionalButton.layer addAnimation:animation forKey:@"transform.scale"];
    }
    
}

#pragma mark - 动画的代理方法
//-(void)animationDidStart:(CAAnimation *)anim {
//    // 获取 动画的名称
//    NSString *name = [anim valueForKey:@"animationName"];
//    bool isTriangle = [name isEqualToString:@"TriangleAnimation"];
//    bool isRightLine = [name containsString:@"LineAnimation"];
//    if (isTriangle) {
//        _triangleLayer.lineCap = kCALineCapRound;
//    }else if (isRightLine){
//        _leftLineLayer.lineCap = kCALineCapRound;
//        _rightLineLayer.lineCap = kCALineCapRound;
//    }
//}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 获取 动画的名称
    NSString *name = [anim valueForKey:@"animationName"];

    if ([name isEqualToString:@"开始动画-缩小"]) { // 缩小动画结束
        _startAnimationEnd = YES;
        if (_endAnimationEnd == YES) {
            _startEnd_EndNOEnd = YES; // 开始动画结束，结束动画还未开始
        }
    } else { // 放大动画结束
        _endAnimationEnd = YES;
     
    }
    
    
   
}

@end
