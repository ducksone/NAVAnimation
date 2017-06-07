//
//  BaseViewController.m
//  BangBangPlus
//
//  Created by J's Mac on 16/3/6.
//  Copyright © 2016年 FiveClovers. All rights reserved.
//

#import "BaseViewController.h"



@interface BaseViewController ()
@end

@implementation BaseViewController
- (void)initConfig
{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController.navigationBar setBarTintColor:TIFANNY_BLUE];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //设定返回按钮
    self.navigationController.navigationBarHidden = YES;
    
//    self.tabBarController.tabBar.hidden = YES;
    // 移除view手势左滑
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self initNavigationView];
}
- (void)back:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)initNavigationView
{
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    
    
    self.btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 27, 30, 30)];
//    [self.btnBack setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.btnBack setTitle:@"<-" forState:UIControlStateNormal];
    [self.btnBack setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    
    [self.btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.btnBack];
    
    self.navigationTitle    = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 30, SCREEN_WIDTH/2, 20)];
    self.navigationTitle.font   = [UIFont systemFontOfSize:17];
    self.navigationTitle.textColor  = [UIColor whiteColor];
    self.navigationTitle.textAlignment  = NSTextAlignmentCenter;
    [self.navigationView addSubview:self.navigationTitle];
    [self.view addSubview:self.navigationView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect frame;
    CGFloat btnY;
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        btnY = 7;
    } else {
        frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
        btnY = 27;
    }
    
    self.btnBack.frame = CGRectMake(10, btnY, 30, 30);
    
    self.navigationView.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initConfig];
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
