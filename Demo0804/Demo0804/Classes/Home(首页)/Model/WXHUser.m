//
//  WXHUser.m
//  Demo0804
//
//  Created by Mac Mini on 16/8/9.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "WXHUser.h"

@implementation WXHUser
- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}
@end
