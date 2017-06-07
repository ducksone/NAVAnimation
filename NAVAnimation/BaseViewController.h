//
//  BaseViewController.h
//  BangBangPlus
//
//  Created by J's Mac on 16/3/6.
//  Copyright © 2016年 FiveClovers. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_HEIGHT_DUCK [[UIScreen mainScreen] bounds].size.height

@interface BaseViewController : UIViewController
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UILabel *navigationTitle;
@property (nonatomic, strong) UIButton *btnBack;

/**
 *返回
 */
- (void)back:(UIButton*)sender;

@end
