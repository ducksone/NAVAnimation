# NAVAnimation
customize UINavigationController animation

当push动画完成时
[[DDAnimationObject shareDDAnimation] animationPushComplete:^(UIViewController *vc) {
        ViewController2 *vc2 = (ViewController2 *)vc;
        [vc2 loadDone];
        }];
当push动画刚开始
[[DDAnimationObject shareDDAnimation] animationStarPush:^(UIViewController *vc) {
       ViewController2 *vc2 = (ViewController2 *)vc;
       [vc2 starLoad];
   }];  
loadDone
starLoad
这两个方法主要是在B VC里边处理一些动画 隐藏显示tableView coverImageView 之类的

获取当前点击cell上的图片 以及设置当前点击图片的rect 还有开始截图 didSelectRowAtIndexPath
[DDAnimationObject shareDDAnimation].middleImage = animationCell.showImageView.image;
[DDAnimationObject shareDDAnimation].animationRect = cc;
[[DDAnimationObject shareDDAnimation] starShot:self];

开始跳转的vc 需要支持UINavigationControllerDelegate协议
并重写
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(nonnull UIViewController *)fromVC
                                                           toViewController:(nonnull UIViewController *)toVC

该方法里边设置DDAnimationObject的type是push还是Pop
if (operation==UINavigationControllerOperationPush) {
        [DDAnimationObject shareDDAnimation].type = AnimationTypePush;
    }else{
        [DDAnimationObject shareDDAnimation].type = AnimationTypePop;
    }
    return [DDAnimationObject shareDDAnimation];
    
别忘记设置代理 self.navigationController.delegate

以上全是在A页面也就是开始需要自定义push pop动画的vc里边

A -> B B -> A 使用自定义push pop 
当B -> C 不需要使用该动画的时候 将self.navigationController.delegate置空

这个动画核心思想（截图 分别动画）我是从newPan 这位大佬写的简书上借鉴的 大佬简书：http://www.jianshu.com/u/e2f2d779c022
不过他的demo拿来运行ok 但是放自己项目上 开始后返回 有一块是黑色的
所以自己就百度然后动手做了一个  

演示gif如下
![image](https://github.com/ducksone/NAVAnimation/blob/master/NAVAnimation/未命名.gif)
