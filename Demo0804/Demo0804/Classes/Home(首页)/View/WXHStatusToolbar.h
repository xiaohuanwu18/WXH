//
//  WXHStatusToolbar.h
//  Demo0804
//
//  Created by Mac Mini on 16/8/14.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHStatus.h"
@interface WXHStatusToolbar : UIView
+ (instancetype)toolbar;
@property (nonatomic, strong) WXHStatus *status;
@end
