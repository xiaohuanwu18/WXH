//
//  WXHLoadMoreFooter.m
//  Demo0804
//
//  Created by Mac Mini on 16/8/9.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "WXHLoadMoreFooter.h"

@implementation WXHLoadMoreFooter
+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WXHLoadMoreFooter" owner:nil options:nil] lastObject];
}
@end
