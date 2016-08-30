//
//  WXHHomeViewController.m
//  Demo729
//
//  Created by Mac Mini on 16/7/29.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "WXHHomeViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "HWTitleMenuViewController.h"
#import "DropdownMenu.h"
#import "WXHTitleButton.h"
#import "WXHAccountTool.h"
#import "AFNetworking.h"
#import "WXHAccount.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "WXHUser.h"
#import "WXHStatus.h"
#import "WXHLoadMoreFooter.h"
#import "WXHStatusCell.h"
#import "WXHStatusFrames.h"
// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface WXHHomeViewController ()<DropdownMenuDelegate>
/**
 *  微博数组（里面放的都是微博字典，一个字典对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation WXHHomeViewController

- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}



- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.backgroundColor = HWColor(211, 211, 211);
    // 设置导航栏内容
    [self setupNav];
    // 获得用户信息（昵称）
    [self setupUserInfo];
    // 加载最新的微博数据
    //[self loadNewStatus];
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
     // 集成上拉刷新控件
    [self setupRefresh];
    


    
//    // 获得未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    HWLog(@"viewDidAppear---%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}
/**
 *  获得未读数（显示在首页右上角度）
 */
- (void)setupUnreadCount
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.拼接请求参数
    WXHAccount *account = [WXHAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 设置提醒数字(微博的未读数)
         NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) {
            self.tabBarItem.badgeValue=nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        }else
        {
            self.tabBarItem.badgeValue=status;
            [UIApplication sharedApplication].applicationIconBadgeNumber=status.intValue;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

/**
 *  集成上拉刷新控件
 */
- (void)setupRefresh
{
    WXHLoadMoreFooter *footer = [WXHLoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}

/**
 *   集成下拉刷新控件
 */
- (void)setupDownRefresh
{
     // 1.添加刷新控件
    UIRefreshControl *control=[[UIRefreshControl alloc]init];
    // 只有用户通过手动下拉刷新，才会触发UIControlEventValueChanged事件
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
   // 2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发UIControlEventValueChanged事件)
      [control beginRefreshing];
    // 3.马上加载数据
    [self refreshStateChange:control];

}
/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)refreshStateChange:(UIRefreshControl *)control
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    // 2.拼接请求参数
    NSMutableDictionary *parames=[NSMutableDictionary dictionary];
    WXHAccount *account=[WXHAccountTool account];
    parames[@"access_token"]=account.access_token;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    WXHStatusFrames *firstSttus=[self.statusFrames firstObject];
    if (firstSttus) {
        parames[@"since_id"]=firstSttus.status.idstr;
        
    }
       // 3.发送请求
    [manger GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:parames success:^(AFHTTPRequestOperation *operation, id responseObject) {
         // 将 "微博字典"数组 转为 "微博模型"数组
         NSArray *newStatuses=[WXHStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将 WXHStatus数组 转为 WXHStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range=NSMakeRange(0, newFrames.count);
        NSIndexSet *set=[NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
       // [self.statuses insertObject:newStatuses atIndex:set];
        
        
        // 刷新表格
         [self.tableView reloadData];
        
        // 结束刷新刷新
        [control endRefreshing];
        // 显示最新微博的数量
         [self showNewStatusCount:newStatuses.count];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 结束刷新刷新
        [control endRefreshing];
        
    }];
    
}

/**
 *  将WXHStatus模型转为WXHStatusFrames模型
 */
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (WXHStatus *status in statuses) {
        WXHStatusFrames *f = [[WXHStatusFrames alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}

/**
 *  显示最新微博的数量
 *
 *  @param count 最新微博的数量
 */
- (void)showNewStatusCount:(NSInteger)count
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    // 2.设置其他属性
    if (count == 0) {
        label.text = @"没有新的微博数据，稍后再试";
    } else {
        label.text = [NSString stringWithFormat:@"共有%ld条新的微博数据", count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    // 3.添加
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 1.0; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        //        label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            //            label.y -= label.height;
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];


   
}

/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    WXHAccount *account = [WXHAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    WXHStatusFrames *lastStatus = [self.statusFrames lastObject];
    if (lastStatus) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatus.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        //NSLog(@"request-->>%@",responseObject);
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [WXHStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        // 将 WXHStatus数组 转为 WXHStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
       
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];
}


/*  获得用户信息（昵称）
*/
- (void)setupUserInfo
{   // 1.请求管理者
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parme=[NSMutableDictionary dictionary];
    // 2.拼接请求参数
    WXHAccount *account=[WXHAccountTool account];
    parme[@"access_token"]=account.access_token;
      parme[@"uid"] = account.uid;
    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:parme success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
//        // 设置名字
//        NSString *name = responseObject[@"name"];
//        [titleButton setTitle:name forState:UIControlStateNormal];
        WXHUser *user=[WXHUser objectWithKeyValues:responseObject];
         [titleButton setTitle:user.name forState:UIControlStateNormal];
        // 存储昵称到沙盒中
        account.name =user.name;
        [WXHAccountTool saveAccount:account];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败-%@",error);
    }];
    
}
/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    /* 中间的标题按钮 */
    WXHTitleButton *titleButton = [[WXHTitleButton alloc] init];
    // 设置图片和文字
    NSString *name = [WXHAccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;

    

}
/**
 *  标题点击
 */
- (void)titleClick:(UIButton *)titleButton
{
    // 1.创建下拉菜单
    DropdownMenu *menu = [DropdownMenu menu];
     menu.delegate = self;
    // 2.设置内容
    HWTitleMenuViewController *vc = [[HWTitleMenuViewController alloc] init];
    vc.view.height = 150;
    vc.view.width = 150;
    menu.contentController = vc;
    
    // 3.显示
    [menu showFrom:titleButton];
}

-(void)friendSearch
{
    
}
-(void)pop
{
}

#pragma mark - HWDropdownMenuDelegate
/**
 *  下拉菜单被销毁了
 */
- (void)dropdownMenuDidDismiss:(DropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
    // 让箭头向下
    //    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}

/**
 *  下拉菜单显示了
 */
- (void)dropdownMenuDidShow:(DropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
    // 让箭头向上
    //    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.statusFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获得cell
    WXHStatusCell *cell = [WXHStatusCell cellWithTableView:tableView];
    // 给cell传递模型数据
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        
        // 加载更多的微博数据
        [self loadMoreStatus];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXHStatusFrames *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
