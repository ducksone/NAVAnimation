//
//  DDAnimationObject.m
//  NAVAnimation
//
//  Created by 邓松 on 2017/6/6.
//  Copyright © 2017年 邓松. All rights reserved.
//

#import "DDAnimationObject.h"

#define ANIMATION_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define ANIMATION_WIDTH [[UIScreen mainScreen] bounds].size.width
#define ANIMATION_TIME_PUSH 0.5
#define ANIMATION_TIME_POP 0.5

@interface DDAnimationObject()<CAAnimationDelegate>



@end


@implementation DDAnimationObject
{
//    UIImage
    CGRect topRect;
    CGRect middleRect;
    CGRect bottomRect;
}

+ (DDAnimationObject *)shareDDAnimation
{
    static DDAnimationObject *animationObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animationObj = [[DDAnimationObject alloc] init];
    });
    return animationObj;
}

//跳转动画的执行时间
-(NSTimeInterval)transitionDuration:(id < UIViewControllerContextTransitioning >)transitionContext;{
    return ANIMATION_TIME_PUSH;
}


-(void)animateTransition:(id < UIViewControllerContextTransitioning >)transitionContext{
    self.transitionContext = transitionContext;
    //无论跳转还是返回  当前视图都是fromVC  动画之后显示的是toVC
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIView* containerView = [transitionContext containerView];
    
    switch (self.type) {
        case AnimationTypePush://跳转到新视图
        {
            self.DDStarPush(toViewController);
            
            [[transitionContext containerView] addSubview:toViewController.view];
            
            CGRect frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            toViewController.view.frame = frame;
            
            __block UIView *toMaskView = [[UIView alloc] initWithFrame:frame];
            [toViewController.view addSubview:toMaskView];
            
            
            __block UIImageView *topImageView = [[UIImageView alloc] initWithFrame:topRect];
            topImageView.image = self.topImage;
            [toMaskView addSubview:topImageView];
            
            __block UIImageView *middleImageView = [[UIImageView alloc] initWithFrame:middleRect];
            middleImageView.image = self.middleImage;
            [toMaskView addSubview:middleImageView];
            
            __block UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:bottomRect];
            bottomImageView.image = self.bottomImage;
            [toMaskView addSubview:bottomImageView];
            
            
            topImageView.frame = topRect;
            middleImageView.frame = middleRect;
            bottomImageView.frame = bottomRect;
            
            [UIView animateWithDuration:ANIMATION_TIME_PUSH animations:^{
                topImageView.frame = CGRectMake(0, -topRect.size.height, topRect.size.width, topRect.size.height);
                middleImageView.frame = CGRectMake(0, 0, middleRect.size.width, middleRect.size.height);
                bottomImageView.frame = CGRectMake(0, ANIMATION_HEIGHT, bottomRect.size.width, bottomRect.size.height);
            }completion:^(BOOL finished) {
                
                self.DDPushComplete(toViewController);
                [toMaskView removeFromSuperview];
                toMaskView = nil;
                
                [fromViewController.view removeFromSuperview];
                
                [transitionContext completeTransition:YES];
            }];
            
        }
            break;
            
        case AnimationTypePop://返回
        {
            
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
            CGRect frame = [transitionContext initialFrameForViewController:fromViewController];
            fromViewController.view.frame= frame;
            
            __block UIView *toMaskView = [[UIView alloc] initWithFrame:frame];
            [fromViewController.view addSubview:toMaskView];
            
//            NSLog(@"222topRect:%@  middleRect:%@  bottomRect:%@",NSStringFromCGRect(topRect),NSStringFromCGRect(middleRect),NSStringFromCGRect(bottomRect));
            
            __block UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -topRect.size.height, topRect.size.width, topRect.size.height)];
            topImageView.image = self.topImage;
            [toMaskView addSubview:topImageView];
            
            __block UIImageView *middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, middleRect.size.width, middleRect.size.height)];
            middleImageView.image = self.middleImage;
            [toMaskView addSubview:middleImageView];
            
            __block UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ANIMATION_HEIGHT, bottomRect.size.width, bottomRect.size.height)];
            bottomImageView.image = self.bottomImage;
            [toMaskView addSubview:bottomImageView];
            
            
            [UIView animateWithDuration:ANIMATION_TIME_POP
                            animations:^{
                                topImageView.frame = topRect;
                                middleImageView.frame = middleRect;
                                bottomImageView.frame = bottomRect;
                                
                            } completion:^(BOOL finished) {
                                [toMaskView removeFromSuperview];
                                toMaskView = nil;
                                
                                [fromViewController.view removeFromSuperview];
                                [transitionContext completeTransition:YES];
                            }];
        }
            break;
            
        default:
            break;
    }
    
}



#pragma mark -- CABasicAnimation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //告诉 iOS 这个 transition 完成
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    //清除 fromVC 的 mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.maskView = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.maskView = nil;
}


/**
 *开始截图 前提 middleRect必须存在
 */
- (void)starShot:(UIViewController *) vc
{
    //判断中间截图位置
    if (CGRectEqualToRect(self.animationRect, CGRectNull)) {
        NSLog(@"middleRect未设置");
        return;
    }
    
    topRect = CGRectNull;
    middleRect = self.animationRect;
    bottomRect = CGRectNull;
    
    
    
    topRect = CGRectMake(0, 0, ANIMATION_WIDTH, middleRect.origin.y);
    
    bottomRect = CGRectMake(0, middleRect.origin.y + middleRect.size.height, ANIMATION_WIDTH, ANIMATION_HEIGHT - (middleRect.origin.y + middleRect.size.height));
    
    self.topImage = [DDAnimationObject ddScreenShot:vc.view cutRect:topRect];
    //不用截中间的图片 直接从cell上拿
//    self.middleImage = [DDAnimationObject ddScreenShot:vc.view cutRect:middleRect];
    
    self.bottomImage = [DDAnimationObject ddScreenShot:vc.view cutRect:bottomRect];
    
    
    
    
}


/**
 *返回截图
 *contentView 截图的视图
 *rect 截图的区域
 */
+ (UIImage *)ddScreenShot:(UIView *) contentView cutRect:(CGRect) rect
{
    CGRect cvRect = contentView.frame;
    UIGraphicsBeginImageContext(cvRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [contentView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    float originX = 90;
//    float originY = 50 + 20;
//    float width = [[UIScreen mainScreen] bounds].size.width - 90 * 2;
//    float height = 100;
//    //你需要的区域起点,宽,高;
    
    UIImage *image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([img CGImage], rect)];
    
    return image;
}

- (void)animationPushComplete:(DDAnimationPushComplete)block
{
    self.DDPushComplete = block;
}


- (void)animationStarPush:(DDAnimationStarPush)block
{
    self.DDStarPush = block;
}

@end
