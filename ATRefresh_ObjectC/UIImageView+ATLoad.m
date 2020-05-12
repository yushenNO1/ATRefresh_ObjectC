//
//  UIImageView+ATLoad.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "UIImageView+ATLoad.h"
#import <YYKit.h>


@implementation UIImageView (ATLoad)
- (void)setGkImageWithURL:(nullable NSString *)url{
    [self setGkImageWithURL:url placeholder:[UIImage imageWithColor:[UIColor colorWithRGB:0xf6f6f6]]];
}
- (void)setGkImageWithURL:(nullable NSString *)url
            placeholder:(nullable UIImage  *)placeholder{
    
    [self setGkImageWithURL:url unencode:YES placeholder:placeholder];
}
- (void)setGkImageWithURL:(nullable NSString *)url
                 unencode:(BOOL)unencode
              placeholder:(nullable UIImage *)placeholder{
    if ([url hasPrefix:@"/agent/"]) {
        url = [url stringByReplacingOccurrencesOfString:@"/agent/" withString:@""];
    }
    url = unencode ? [url stringByURLDecode] : url;
    [self setImageWithURL:[NSURL URLWithString:url] placeholder:placeholder];
    //[self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}
@end
