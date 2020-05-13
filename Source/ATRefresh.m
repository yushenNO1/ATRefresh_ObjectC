//
//  ATRefresh.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATRefresh.h"

@implementation ATRefresh
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}
+ (BOOL)reachable{
    return YES;
}

+ (BOOL)iPad{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}
+ (BOOL)iPhone_X{
    if ([ATRefresh iPad]) {
        return NO;
    }
    UIView *window = [UIApplication sharedApplication].delegate.window;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets inset = window.safeAreaInsets;
        return (inset.bottom == 34) || (inset.bottom == 21);
    }
    return NO;
}
+ (CGFloat)NAVI_HIGHT{
    return [self iPhone_X] ? 88 : 64;
}
@end
