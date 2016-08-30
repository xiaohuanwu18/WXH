//
//  AppDelegate.m
//  Demo729
//
//  Created by Mac Mini on 16/7/29.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "AppDelegate.h"
#import "WXHTabBarController.h"
#import "WXHNewfaeatureViewController.h"
#import "WXHOAuthViewController.h"
#import "WXHAccountTool.h"
#import "WXHAccount.h"
#import "UIWindow+Extension.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 2.设置根控制器
    WXHAccount *account = [WXHAccountTool account];
    if (account) { // 之前已经登录成功过
        [self.window switchRootViewController];
    } else {
        self.window.rootViewController = [[WXHOAuthViewController alloc] init];
    }

    // 2.设置根控制器
//    WXHAccount *account = [WXHAccountTool account];
//    if (account) { // 之前已经登录成功过
//        NSString *key = @"CFBundleVersion";
//        // 上一次的使用版本（存储在沙盒中的版本号）
//        NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//        // 当前软件的版本号（从Info.plist中获得）
//        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
//        
//        if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
//            self.window.rootViewController = [[WXHTabBarController alloc] init];
//        } else { // 这次打开的版本和上一次不一样，显示新特性
//            self.window.rootViewController = [[WXHNewfaeatureViewController alloc] init];
//            
//            // 将当前的版本号存进沙盒
//            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//    } else {
//        self.window.rootViewController = [[WXHOAuthViewController alloc] init];
//    }
//    

//
     // 3.显示窗口
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
/**
 *  当app进入后台时调用
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {

    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
    UIBackgroundTaskIdentifier task=[application beginBackgroundTaskWithExpirationHandler:^{
       
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
    // 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay
    // 搞一个0kb的MP3文件，没有声音
    // 循环播放
    
    // 以前的后台模式只有3种
    // 保持网络连接
    // 多媒体应用
    // VOIP:网络电话
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
