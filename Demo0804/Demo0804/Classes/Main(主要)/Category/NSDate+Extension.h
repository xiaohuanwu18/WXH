//
//  NSDate+Extension.h
//  Demo0804
//
//  Created by Mac Mini on 16/8/15.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;
@end
