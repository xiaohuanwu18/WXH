//
//  WXHStatusPhotosView.m
//  Demo0804
//
//  Created by Mac Mini on 16/8/15.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "WXHStatusPhotosView.h"
#import "WXHPhoto.h"
#import "WXHStatusPhotoView.h"
#import "UIView+Extension.h"

#define HWStatusPhotoWH 70
#define HWStatusPhotoMargin 10
#define HWStatusPhotoMaxCol(count) ((count==4)?2:3)
@implementation WXHStatusPhotosView
-(void)setPhotos:(NSArray *)photos
{
    _photos=photos;
    int photosCount=photos.count;
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count<photosCount) {
        WXHStatusPhotoView *photoView=[[WXHStatusPhotoView alloc]init];
        [self addSubview:photoView];
    }
     // 遍历所有的图片控件，设置图片
    for (int i=0; i<self.subviews.count; i++) {
        WXHStatusPhotoView *photoView=self.subviews[i];
        if (i<photosCount) {// 显示
            photoView.phto=photos[i];
            photoView.hidden=NO;
        }else
        {// 隐藏
            photoView.hidden=YES;
        }
    }
}


+ (CGSize)sizeWithCount:(int)count
{
    // 最大列数（一行最多有多少列）
    int maxCols = HWStatusPhotoMaxCol(count);
    
    ///Users/apple/Desktop/课堂共享/05-iPhone项目/1018/代码/黑马微博2期35-相册/黑马微博2期/Classes/Home(首页)/View/HWStatusPhotosView.m 列数
    int cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * HWStatusPhotoWH + (cols - 1) * HWStatusPhotoMargin;
    
    // 行数
    int rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * HWStatusPhotoWH + (rows - 1) * HWStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    int photosCount = self.photos.count;
    int maxCol = HWStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        WXHStatusPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (HWStatusPhotoWH + HWStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (HWStatusPhotoWH + HWStatusPhotoMargin);
        photoView.width = HWStatusPhotoWH;
        photoView.height = HWStatusPhotoWH;
    }
}
@end
