//
//  DDAnimationObject.h
//  NAVAnimation
//
//  Created by 邓松 on 2017/6/6.
//  Copyright © 2017年 邓松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AnimationType) {
    AnimationTypePush,
    AnimationTypePop,
};

/**
 *push完成
 */
typedef void(^DDAnimationPushComplete)(UIViewController *vc);

/**
 *开始push
 */
typedef void(^DDAnimationStarPush)(UIViewController *vc);


@interface DDAnimationObject : NSObject<UIViewControllerAnimatedTransitioning>

@property (strong,nonatomic) id<UIViewControllerContextTransitioning> transitionContext;
//用于区别动画的方向，是跳转还是返回
@property (assign,nonatomic) AnimationType type;

//点击cell中的UIImageView的frame
@property (assign,nonatomic) CGRect animationRect;
@property (strong,nonatomic) DDAnimationPushComplete DDPushComplete;
@property (strong,nonatomic) DDAnimationStarPush DDStarPush;

/**
 *保存三张截图
 */
@property (nonatomic) UIImage *topImage;
@property (nonatomic) UIImage *middleImage;
@property (nonatomic) UIImage *bottomImage;

+ (DDAnimationObject *)shareDDAnimation;

- (void)animationPushComplete:(DDAnimationPushComplete) block;
- (void)animationStarPush:(DDAnimationStarPush) block;

/*以下属性及方法 暂时暴露 做测试*/
- (void)starShot:(UIViewController *) vc;





@end
