//
//  WXHStatusFrames.h
//  Demo0804
//
//  Created by Mac Mini on 16/8/10.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 昵称字体
#define HWStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define HWStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define HWStatusCellSourceFont HWStatusCellTimeFont
// 正文字体
#define HWStatusCellContentFont [UIFont systemFontOfSize:14]
// 被转发微博的正文字体
#define HWStatusCellRetweetContentFont [UIFont systemFontOfSize:13]
// cell之间的间距宽度
#define HWStatusCellMargin 15

// cell的边框宽度
#define HWStatusCellBorderW 10
@class WXHStatus;
@interface WXHStatusFrames : NSObject
@property (nonatomic, strong) WXHStatus *status;
/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photoViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;

/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文 + 昵称 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotoViewF;
/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
