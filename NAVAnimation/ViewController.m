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
    
    //计算位置
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
    CGRect cc = CGRectMake(rectInSuperview.origin.x, rectInSuperview.origin.y + 50, rectInSuperview.size.width, rectInSuperview.size.height - 50);
    
    [DDAnimationObject shareDDAnimation].middleImage = animationCell.showImageView.image;
    [DDAnimationObject shareDDAnimation].animationRect = cc;
    [[DDAnimationObject shareDDAnimation] starShot:self];
    
    ViewController2 *vc2 = [[ViewController2 alloc] init];
    [self.navigationController pushViewController:vc2 animated:YES];
    
}

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
