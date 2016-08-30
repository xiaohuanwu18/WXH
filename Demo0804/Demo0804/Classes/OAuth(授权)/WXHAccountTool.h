//
//  WXHAccountTool.h
//  Demo0804
//
//  Created by Mac Mini on 16/8/8.
//  Copyright © 2016年 wuhuan. All rights reserved.
//处理账号相关的所有操作:存储账号、取出账号、验证账号

#import <Foundation/Foundation.h>
#import "WXHAccount.h"
@interface WXHAccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(WXHAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (WXHAccount *)account;
@end
