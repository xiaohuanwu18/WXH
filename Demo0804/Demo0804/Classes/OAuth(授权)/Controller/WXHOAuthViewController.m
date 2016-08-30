//
//  WXHOAuthViewController.m
//  Demo729
//
//  Created by Mac Mini on 16/8/3.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "WXHOAuthViewController.h"
#import "AFNetworking.h"
#import "WXHAccount.h"
#import "WXHAccountTool.h"
#import "WXHTabBarController.h"
#import "WXHNewfaeatureViewController.h"
#import "UIWindow+Extension.h"
@interface WXHOAuthViewController ()<UIWebViewDelegate>

@end

@implementation WXHOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webVoew=[[UIWebView alloc]init];
    webVoew.frame=self.view.bounds;
    webVoew.delegate=self;
    [self.view addSubview:webVoew];
    
    NSString *adder=@"https://api.weibo.com/oauth2/authorize?client_id=2467071828&redirect_uri=https://www.baidu.com";
    NSURL *url=[NSURL URLWithString:adder];
    NSURLRequest *requet=[NSURLRequest requestWithURL:url];
    [webVoew loadRequest:requet];
    
}

#pragma mark --webView

-(void)webViewDidFinishLoad:( UIWebView *)webView
{
    //NSLog(@"webViewDidFinishLoad");
}
-(void)webViewDidStartLoad:( UIWebView *)webView
{
    // NSLog(@"webViewDidStartLoad");
}


-(BOOL)webView:(nonnull UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   // NSLog(@"%@",request.URL.absoluteString);
     // 1.获得url
     NSString *url = request.URL.absoluteString;
    // 2.判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) { // 是回调地址
        // 截取code=后面的参数值
        int fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        //NSLog(@"%@",code);
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
        
        
        // 禁止加载回调地址
        return NO;
    }
    return YES;
}

/**
 *  利用code（授权成功后的request token）换取一个accessToken
 *
 *  @param code 授权成功后的request token
 */
- (void)accessTokenWithCode:(NSString *)code
{
    // 1.请求管理者
     AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"2467071828";
    params[@"client_secret"] = @"4c18c652f2ef222d54a4f713ac1f7dd0";
    params[@"grant_type"]= @"authorization_code";
    params[@"redirect_uri"] = @"https://www.baidu.com";
    params[@"code"] = code;
    //[manger po]
 // 3.发送请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"请求成功%@",responseObject);
         // 将返回的账号字典数据 --> 模型，存进沙盒
          WXHAccount *account = [WXHAccount accountWithDict:responseObject];
        // 存储账号信息
        [WXHAccountTool saveAccount:account];
        // 切换窗口的根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败%@",error);
        
    }];
//    [manger POST:@"https://api.weibo.com/oauth2/access_token" parameters:params constructingBodyWithBlock:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"请求成功%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"请求失败%@",error);
//        
//    }];
    
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
