//
//  ATRefresh.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATRefresh.h"
#define at_inset       [UIApplication sharedApplication].delegate.window.safeAreaInsets
@implementation ATRefresh
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}
+ (BOOL)at_iphoneX{
    if (@available(iOS 11.0, *)) {
        return at_inset.bottom > 0 ? true : false;  //34 or 21
    }
    return NO;
}
+ (CGFloat)at_statusBar{
    if (@available(iOS 11.0, *)) {
        return at_inset.top;
    }
    return 20;
}
+ (CGFloat)at_tabBar{
    if (@available(iOS 11.0, *)) {
        return at_inset.bottom;
    }
    return 0;
}
+ (CGFloat)at_naviBar{
    return  (44 + [ATRefresh at_statusBar]);
}
@end
