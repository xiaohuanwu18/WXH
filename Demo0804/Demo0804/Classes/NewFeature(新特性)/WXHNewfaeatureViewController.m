//
//  WXHNewfaeatureViewController.m
//  Demo729
//
//  Created by Mac Mini on 16/8/3.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "WXHNewfaeatureViewController.h"
#import "WXHTabBarController.h"
#import "UIView+Extension.h"
#import "HcdGuideView.h"
#define WXHNewfeatureCount 4
@interface WXHNewfaeatureViewController ()<UIScrollViewDelegate>
@property(nonatomic,weak)UIPageControl *pageControl;
@property(nonatomic,weak)UIScrollView *scrollView;
@end

@implementation WXHNewfaeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView=[[UIScrollView alloc]init];
    scrollView.frame=self.view.bounds;
    //scrollView.contentSize=CGSizeMake(4*scrollView.width, 0);
    [self.view addSubview:scrollView];
    self.scrollView=scrollView;
    
    // 2.添加图片到scrollView中
    CGFloat scrollW=scrollView.width;
    CGFloat scrollH=scrollView.height;
    for (int i=0; i<WXHNewfeatureCount; i++) {
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.width=scrollW;
        imageView.height=scrollH;
        imageView.y=0;
        imageView.x=i*scrollW;
         // 显示图片
        NSString *name=[NSString stringWithFormat:@"new_feature_%d",i+1];
        imageView.image=[UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        if (i==WXHNewfeatureCount-1) {
             [self setupLastImageView:imageView];
            
        }
    }
    // 3.设置scrollView的其他属性
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize=CGSizeMake(WXHNewfeatureCount*scrollW, 0);
    scrollView.bounces=NO;// 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    // 4.添加pageControl：分页，展示目前看的是第几页
    UIPageControl *pageControl=[[UIPageControl alloc]init];
    NSLog(@"page:%@",pageControl);
    pageControl.numberOfPages=WXHNewfeatureCount;
    pageControl.backgroundColor=[UIColor redColor];
    //pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    //pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = HWColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = HWColor(189, 189, 189);
    pageControl.centerX=scrollW*0.5;
    pageControl.centerY=scrollH-50;
    [self.view addSubview:pageControl];
    self.pageControl=pageControl;
    
    
}

/**
 *  初始化最后一个imageView
 *
 *  @param imageView 最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    
     // 开启交互功能
    imageView.userInteractionEnabled=YES;
    // 1.分享给大家（checkbox)
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shareBtn.width = 200;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = imageView.height * 0.65;
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

 // 2.开始微博
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = shareBtn.centerX;
    startBtn.centerY = imageView.height * 0.75;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];

    
   
}
//分享给大家（checkbox)
- (void)shareClick:(UIButton *)shareBtn
{
    // 状态取反
    shareBtn.selected = !shareBtn.isSelected;
}

- (void)startClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[WXHTabBarController alloc] init];
    

}

-(void)scrollViewDidScroll:( UIScrollView *)scrollView
{
  //  NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    double page=scrollView.contentOffset.x/scrollView.width;
    // 四舍五入计算出页码
    self.pageControl.currentPage = (int)(page + 0.5);
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
