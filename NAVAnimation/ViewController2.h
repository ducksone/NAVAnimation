//
//  ViewController2.h
//  NAVAnimation
//
//  Created by 邓松 on 2017/6/7.
//  Copyright © 2017年 邓松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ViewController2 : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (nonatomic) UITableView *detailTableView;



- (void)starLoad;
- (void)loadDone;

@end
