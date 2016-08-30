//
//  WXHTabBarController.m
//  Demo729
//
//  Created by Mac Mini on 16/7/29.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "WXHTabBarController.h"
#import "WXHNavigationController.h"
#import "WXHDiscoverViewController.h"
#import "WXHHomeViewController.h"
#import "WXHProfileViewController.h"
#import "WXHMessageCenterViewController.h"
//#import "HcdGuideView.h"
@interface WXHTabBarController ()

@end

@implementation WXHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
//    NSMutableArray *images = [NSMutableArray new];
//    
//    [images addObject:[UIImage imageNamed:@"1"]];
//    [images addObject:[UIImage imageNamed:@"2"]];
//    [images addObject:[UIImage imageNamed:@"3"]];
//    
//    [[HcdGuideViewManager sharedInstance] showGuideViewWithImages:images
//                                                   andButtonTitle:@"立即体验"
//                                              andButtonTitleColor:[UIColor whiteColor]
//                                                 andButtonBGColor:[UIColor clearColor]
//                                             andButtonBorderColor:[UIColor whiteColor]];
//    
   [self addchildes];

}
-(void)addchildes
{
    WXHHomeViewController *home=[[WXHHomeViewController alloc]init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectImage:@"tabbar_home_selected"];
    
    WXHMessageCenterViewController *message=[[WXHMessageCenterViewController alloc]init];
    [self addChildVc:message title:@"消息" image:@"tabbar_message_center"  selectImage:@"tabbar_message_center_selected"];
    
    WXHDiscoverViewController *discover=[[WXHDiscoverViewController alloc]init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover"  selectImage:@"tabbar_discover_selected"];
    
    WXHProfileViewController *profile=[[WXHProfileViewController alloc]init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile"  selectImage:@"tabbar_profile_selected"];
    
    
}

-(void)addChildVc:(UIViewController *)addChildVc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    addChildVc.title=title;
    addChildVc.tabBarItem.image=[UIImage imageNamed:image];
    addChildVc.tabBarItem.selectedImage=[UIImage imageNamed:selectImage];
    
    WXHNavigationController *nav=[[WXHNavigationController alloc]initWithRootViewController:addChildVc];
    
    [self addChildViewController:nav];
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
