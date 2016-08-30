//
//  NSString+Extension.h
//  Demo0804
//
//  Created by Mac Mini on 16/8/15.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;
@end
