//
//  UIBarButtonItem+Extension.m
//  Demo729
//
//  Created by Mac Mini on 16/7/30.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithTarget:(id)targer action:(SEL) action image:(NSString *)image highImage:(NSString *)hightImage
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:targer action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    btn.size=btn.currentBackgroundImage.size;
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    return buttonItem;
}

@end
