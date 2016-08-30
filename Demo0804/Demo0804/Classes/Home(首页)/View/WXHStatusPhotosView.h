//
//  WXHStatusPhotosView.h
//  Demo0804
//
//  Created by Mac Mini on 16/8/15.
//  Copyright © 2016年 wuhuan. All rights reserved.
//cell上面的配图相册（里面会显示1~9张图片, 里面都是HWStatusPhotoView）

#import <UIKit/UIKit.h>
@interface WXHStatusPhotosView : UIView
@property (nonatomic, strong) NSArray *photos;
/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(int)count;
@end
