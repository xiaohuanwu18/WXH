//
//  WXHStatusCell.h
//  Demo0804
//
//  Created by Mac Mini on 16/8/10.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WXHStatusFrames;
@interface WXHStatusCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)WXHStatusFrames *statusFrame;
@end
