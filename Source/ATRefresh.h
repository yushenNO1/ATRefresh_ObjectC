//
//  ATRefresh.h
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ATRefreshOption) {
    ATRefreshNone         = 0,
    ATHeaderRefresh       = 1 << 0,
    ATFooterRefresh       = 1 << 1,
    ATHeaderAutoRefresh   = 1 << 2,
    ATFooterAutoRefresh   = 1 << 3,
    ATRefreshDefault = (ATHeaderRefresh | ATHeaderAutoRefresh | ATFooterRefresh | ATFooterAutoRefresh),
};

@protocol ATRefreshDataSource <NSObject>
@required
- (NSArray <UIImage *>*)refreshFooterData;
- (NSArray <UIImage *>*)refreshHeaderData;

- (UIImage *)refreshLogoData;
- (NSAttributedString *)refreshTitle;
- (NSAttributedString *)refreshSubtitle;

- (CGFloat)refreshLogoVertica;
- (CGFloat)refreshLogoSpace;
- (UIColor *)refreshColor;
- (UIButton *)refreshButton;
- (CAAnimation *)refreshAnimation;

@end

@protocol ATRefreshDelegate<NSObject>
@required
- (void)refreshData:(NSInteger)page;

@end

@interface ATRefresh : NSObject

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue;
+ (BOOL)at_iphoneX;
+ (CGFloat)at_statusBar;
+ (CGFloat)at_naviBar;
+ (CGFloat)at_tabBar;

@end

