//
//  UIBarButtonItem+Extension.h
//  Demo729
//
//  Created by Mac Mini on 16/7/30.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithTarget:(id)targer action:(SEL) action image:(NSString *)image highImage:(NSString *)hightImage;
@end
