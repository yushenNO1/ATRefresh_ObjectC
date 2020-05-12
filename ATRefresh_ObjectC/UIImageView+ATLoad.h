//
//  UIImageView+ATLoad.h
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (ATLoad)
- (void)setGkImageWithURL:(nullable NSString *)url;
- (void)setGkImageWithURL:(nullable NSString *)url
              placeholder:(nullable UIImage  *)placeholder;
- (void)setGkImageWithURL:(nullable NSString *)url
                 unencode:(BOOL)unencode
              placeholder:(nullable UIImage  *)placeholder;
@end

NS_ASSUME_NONNULL_END
