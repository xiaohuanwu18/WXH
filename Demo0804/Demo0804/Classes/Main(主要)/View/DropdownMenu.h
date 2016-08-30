//
//  DropdownMenu.h
//  Demo729
//
//  Created by Mac Mini on 16/7/31.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DropdownMenu;

@protocol DropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(DropdownMenu *)menu;
- (void)dropdownMenuDidShow:(DropdownMenu *)menu;
@end

@interface DropdownMenu : UIView
@property (nonatomic, weak) id<DropdownMenuDelegate> delegate;
+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@end
