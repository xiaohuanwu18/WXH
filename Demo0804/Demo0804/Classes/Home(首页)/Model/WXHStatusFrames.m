//
//  WXHStatusFrames.m
//  Demo0804
//
//  Created by Mac Mini on 16/8/10.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "WXHStatusFrames.h"
#import "WXHStatus.h"
#import "WXHUser.h"
#import "NSString+Extension.h"
#import "WXHStatusPhotosView.h"
// cell的边框宽度
#define HWStatusCellBorderW 10
@implementation WXHStatusFrames

//- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
//{
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = font;
//    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
//    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//}
//
//- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
//{
//    return [self sizeWithText:text font:font maxW:MAXFLOAT];
//}

-(void)setStatus:(WXHStatus *)status
{
    _status=status;
    WXHUser *user=status.user;
     // cell的宽度
    CGFloat cellW=[UIScreen mainScreen].bounds.size.width;
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = HWStatusCellBorderW;
    CGFloat iconY = HWStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + HWStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:HWStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + HWStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
      /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + HWStatusCellBorderW;
    CGSize timeSize = [status.created_at sizeWithFont:HWStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + HWStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:HWStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + HWStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [status.text sizeWithFont:HWStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};

    /** 配图 */
    
    CGFloat originalH=0;
    if (status.pic_urls.count) {// 有配图
        CGFloat photoX=contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + HWStatusCellBorderW;
         CGSize photosSize = [WXHStatusPhotosView sizeWithCount:status.pic_urls.count];
        self.photoViewF =(CGRect){{photoX, photoY}, photosSize};
        
        originalH = CGRectGetMaxY(self.photoViewF) + HWStatusCellBorderW;
        
    }
    else { // 没配图
        originalH = CGRectGetMaxY(self.contentLabelF) + HWStatusCellBorderW;
    }
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = HWStatusCellMargin;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    CGFloat toolbarY = 0;
    /* 被转发微博 */
    if (status.retweeted_status) {
        WXHStatus *retweeted_status = status.retweeted_status;
        WXHUser *retweeted_status_user = retweeted_status.user;
        
        /** 被转发微博正文 */
        CGFloat retweetContentX = HWStatusCellBorderW;
        CGFloat retweetContentY = HWStatusCellBorderW;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
        CGSize retweetContentSize = [retweetContent sizeWithFont:HWStatusCellRetweetContentFont maxW:maxW];
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        
        /** 被转发微博配图 */
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count) { // 转发微博有配图
            //CGFloat retweetPhotoWH = 100;
            CGFloat retweetPhotoX = retweetContentX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetContentLabelF) + HWStatusCellBorderW;
            CGSize retweetPhotosSize = [WXHStatusPhotosView sizeWithCount:retweeted_status.pic_urls.count];
          self.retweetPhotoViewF = (CGRect){{retweetPhotoX, retweetPhotoY}, retweetPhotosSize};
            
            retweetH = CGRectGetMaxY(self.retweetPhotoViewF) + HWStatusCellBorderW;
        } else { // 转发微博没有配图
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + HWStatusCellBorderW;
        }
        
        /** 被转发微博整体 */
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW;
        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        
        toolbarY = CGRectGetMaxY(self.retweetViewF);
    } else {
        toolbarY = CGRectGetMaxY(self.originalViewF);
    }
    /** 工具条 */
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 35;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
//    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarF);
}
@end
