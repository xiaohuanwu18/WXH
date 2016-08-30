//
//  WXHIconView.m
//  Demo0804
//
//  Created by Mac Mini on 16/8/15.
//  Copyright © 2016年 wuhuan. All rights reserved.
//

#import "WXHIconView.h"
#import "UIImageView+WebCache.h"
#import "WXHUser.h"
#import "UIView+Extension.h"
@interface WXHIconView()
@property (nonatomic, weak) UIImageView *verifiedView;

@end
@implementation WXHIconView
- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}
-(void)setUser:(WXHUser *)user
{
    _user=user;
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    // 2.设置加V图片
    switch (user.verified_type) {
        case HWUserVerifiedPersonal: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case HWUserVerifiedOrgEnterprice:
        case HWUserVerifiedOrgMedia:
        case HWUserVerifiedOrgWebsite: // 官方认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case HWUserVerifiedDaren: // 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES; // 当做没有任何认证
            break;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
}
@end
