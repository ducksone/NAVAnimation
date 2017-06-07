//
//  ViewController2.m
//  NAVAnimation
//
//  Created by 邓松 on 2017/6/7.
//  Copyright © 2017年 邓松. All rights reserved.
//

#import "ViewController2.h"
#import "DDAnimationObject.h"
#import "TopTableViewCell.h"

@interface ViewController2 ()
{
    UIView *bottomMaskView;
    UIActivityIndicatorView *stateIndicatorView;
}

@property (nonatomic ,strong) UIImageView*  NavigationHeadView;
@property (nonatomic, strong) UILabel*      NavigationUserName;


@end

@implementation ViewController2

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //
    for (id vc in self.navigationController.viewControllers) {
        if ([NSStringFromClass([vc class]) isEqualToString:@"ViewController"]) {
            self.navigationController.delegate = vc;
            break;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}

- (void)loadDone
{
    NSLog(@"____加载完成");
    if ([DDAnimationObject shareDDAnimation].animationRect.origin.y < 0) {
        self.coverImageView.hidden = NO;
    }
    //TODO:当请求数据得到时做下一步操作
    //模拟2秒钟的请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.coverImageView.hidden = YES;
        self.detailTableView.hidden = NO;
        [stateIndicatorView stopAnimating];
        
        [bottomMaskView removeFromSuperview];
        bottomMaskView = nil;
    });
}

- (void)starLoad
{
    
    //表示点击的图片被遮住了一部分 所以当push开始的时候隐藏 push结束的时候显示 不然从顶部往下滑的时候能看到背面的coverImageView
    if ([DDAnimationObject shareDDAnimation].animationRect.origin.y < 0) {
        self.coverImageView.hidden = YES;
    }
    
    [UIView animateWithDuration:0.6 animations:^{
        bottomMaskView.frame = CGRectMake(0, 2 * SCREEN_WIDTH / 3, SCREEN_WIDTH, bottomMaskView.frame.size.height);
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coverImageView.image = [DDAnimationObject shareDDAnimation].middleImage;
    [self.navigationItem setTitle:@"展示页面"];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.94 blue:0.96 alpha:1.00];
    
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT_DUCK) style:UITableViewStylePlain];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.hidden = YES;
    [self.view addSubview:_detailTableView];
    
    [self createAnimationNeed];
    [self initHeaderView];
}

- (void)createAnimationNeed
{
    CGFloat showImageHeight = 2 * SCREEN_WIDTH / 3;
    
    bottomMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT_DUCK, SCREEN_WIDTH, SCREEN_HEIGHT_DUCK - showImageHeight)];
    bottomMaskView.backgroundColor = [UIColor whiteColor];
    
    CGRect stateViewRect = CGRectMake(CGRectGetMidX(bottomMaskView.frame), CGRectGetMidY(bottomMaskView.frame), 30, 30);
    NSLog(@"___stateViewRect:%@",NSStringFromCGRect(stateViewRect));
    stateIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((bottomMaskView.frame.size.width - 30) / 2, (bottomMaskView.frame.size.height - 30) / 2, 30, 30)];
    stateIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [stateIndicatorView startAnimating];
    [bottomMaskView addSubview:stateIndicatorView];
    
    [self.view addSubview:bottomMaskView];
}

- (void)initHeaderView
{
    self.NavigationHeadView         = [[UIImageView alloc] initWithFrame:CGRectMake(45+4, 20, 40, 40)];
    self.NavigationHeadView.layer.masksToBounds = YES;
    self.NavigationHeadView.layer.cornerRadius  = 20.0f;
    self.NavigationHeadView.layer.borderColor   = [[UIColor whiteColor] CGColor];
    self.NavigationHeadView.layer.borderWidth   = 1.0f;
    self.NavigationHeadView.backgroundColor = [UIColor orangeColor];
    
    //    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserHeader:)];
    //    self.NavigationHeadView.userInteractionEnabled = YES;
    //    [self.NavigationHeadView addGestureRecognizer:singleTap];
    
    self.NavigationUserName         = [[UILabel alloc] initWithFrame:CGRectMake(self.NavigationHeadView.frame.origin.x + self.NavigationHeadView.frame.size.width + 8, 30, 150, 17)];
    self.NavigationUserName.font    = [UIFont systemFontOfSize:15.0f];
    self.NavigationUserName.textColor   = [UIColor whiteColor];
    self.NavigationUserName.text = @"测试动画";
    
    self.NavigationHeadView.alpha   = 0;
    self.NavigationUserName.alpha   = 0;
    
    self.navigationView.backgroundColor = [UIColor clearColor];
    
    [self.navigationView addSubview:self.NavigationHeadView];
    [self.navigationView addSubview:self.NavigationUserName];
    
    //手动添加的tableview 需要把navigationview提到页面的最前边 xib上拖出来 状态栏的20像素会被挤下来  不知道为什么
    [self.view bringSubviewToFront:self.navigationView];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TopTableViewCell *ttCell = [tableView dequeueReusableCellWithIdentifier:@"TopTableViewCellIdentity"];
        
        if (!ttCell) {
            ttCell = [[TopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopTableViewCellIdentity"];
        }
        
        ttCell.topCellImageView.image = [DDAnimationObject shareDDAnimation].middleImage;
        return ttCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentity"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellIdentity"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"测试cell:%ld",(long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 2 * SCREEN_WIDTH / 3;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 20;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == self.detailTableView) {
        if (scrollView.contentOffset.y > 64) {
            
            self.NavigationHeadView.alpha   = 1;
            self.NavigationUserName.alpha   = 1;
            
            self.navigationView.backgroundColor = [UIColor colorWithRed:0.43 green:0.85 blue:0.84 alpha:1.00];
        }else{
            self.NavigationHeadView.alpha   = 0;
            self.NavigationUserName.alpha   = 0;
            
            self.navigationView.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    self.navigationController.delegate = nil;
//    UIViewController *vc = [[UIViewController alloc] init];
//    [vc.navigationItem setTitle:@"空白页"];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController pushViewController:vc animated:YES];
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

- (void)back:(UIButton *)sender
{
    self.coverImageView.hidden = YES;
    self.detailTableView.hidden = YES;
    
    if (bottomMaskView) {
        [bottomMaskView removeFromSuperview];
        bottomMaskView = nil;
    }
    
    [super back:sender];
}

@end
