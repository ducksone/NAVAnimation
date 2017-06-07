//
//  ViewController.m
//  NAVAnimation
//
//  Created by 邓松 on 2017/6/6.
//  Copyright © 2017年 邓松. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "DDAnimationObject.h"
#import "AnimationTableViewCell.h"

@interface ViewController ()<UINavigationControllerDelegate>
{
    
}

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationView.hidden = YES;
    
    self.animationTableView.dataSource = self;
    self.animationTableView.delegate = self;
    [[DDAnimationObject shareDDAnimation] animationPushComplete:^(UIViewController *vc) {
        ViewController2 *vc2 = (ViewController2 *)vc;
        [vc2 loadDone];
    }];
    
    [[DDAnimationObject shareDDAnimation] animationStarPush:^(UIViewController *vc) {
        ViewController2 *vc2 = (ViewController2 *)vc;
        [vc2 starLoad];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnimationTableViewCell *animationCell = [tableView dequeueReusableCellWithIdentifier:@""];
    
    if (!animationCell) {
        animationCell = [[AnimationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    
    NSString *str = [NSString stringWithFormat:@"测试标题_%ld",(long)indexPath.row];
    
    animationCell.titleLabel.text = str;
    
    return animationCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 2 * [[UIScreen mainScreen] bounds].size.width / 3 + 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AnimationTableViewCell *animationCell = [tableView cellForRowAtIndexPath:indexPath];
    
    //TODO 计算位置
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    
    CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
//
////    NSLog(@"cell在tableview中的位置:%@",NSStringFromCGRect(rectInTableView));
//    NSLog(@"cell在屏幕中的位置:%@",NSStringFromCGRect(rectInSuperview));
    
    CGRect cc = CGRectMake(rectInSuperview.origin.x, rectInSuperview.origin.y + 50, rectInSuperview.size.width, rectInSuperview.size.height - 50);
//    NSLog(@"____imageView:%@",NSStringFromCGRect(cc));
    
    [DDAnimationObject shareDDAnimation].middleImage = animationCell.showImageView.image;
    [DDAnimationObject shareDDAnimation].animationRect = cc;
    [[DDAnimationObject shareDDAnimation] starShot:self];
    
    ViewController2 *vc2 = [[ViewController2 alloc] init];
    [self.navigationController pushViewController:vc2 animated:YES];
    
}



//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//    
//}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(nonnull UIViewController *)fromVC
                                                           toViewController:(nonnull UIViewController *)toVC
{
    if (operation==UINavigationControllerOperationPush) {
        [DDAnimationObject shareDDAnimation].type = AnimationTypePush;
    }else{
        [DDAnimationObject shareDDAnimation].type = AnimationTypePop;
    }
    return [DDAnimationObject shareDDAnimation];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"pushSeg"]) {
//        SecondViewController *toVC = (SecondViewController *)segue.destinationViewController;
//    }
//}

- (UIImage *)ddScreenShot:(UIView *) contentView
{
    CGRect rect = contentView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [contentView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    float originX = 90;
    float originY = 50 + 20;
    float width = [[UIScreen mainScreen] bounds].size.width - 90 * 2;
    float height = 100;
    //你需要的区域起点,宽,高;
    
    CGRect rect1 = CGRectMake(originX , originY , width , height);
    UIImage *image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([img CGImage], rect1)];
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
