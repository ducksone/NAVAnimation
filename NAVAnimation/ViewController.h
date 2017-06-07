//
//  ViewController.h
//  NAVAnimation
//
//  Created by 邓松 on 2017/6/6.
//  Copyright © 2017年 邓松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface ViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *animationTableView;

@end

