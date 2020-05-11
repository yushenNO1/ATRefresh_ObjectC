//
//  ATRefersh.h
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RefreshPageStart (1)
#define RefreshPageSize (20)
/**
 *  集成刷新控件
 */
typedef NS_ENUM(NSUInteger, ATRefreshOption) {
    ATRefreshNone         = 0,
    ATHeaderRefresh       = 1 << 0,
    ATFooterRefresh       = 1 << 1,
    ATHeaderAutoRefresh   = 1 << 2,
    ATFooterAutoRefresh   = 1 << 3,
    ATFooterDefaultHidden = 1 << 4,
    ATRefreshDefault = (ATHeaderRefresh | ATHeaderAutoRefresh | ATFooterRefresh | ATFooterDefaultHidden),
};
@protocol ATRefreshDataSource <NSObject>

@required
- (NSArray <UIImage *>*)refreshFooterData;
- (NSArray <UIImage *>*)refreshHeaderData;
- (NSArray <UIImage *>*)refreshLoaderData;
- (UIImage *)refreshEmptyData;
- (UIImage *)refreshErrorData;
@optional
- (NSString *)refreshLoaderToast;
- (NSString *)refreshErrorToast;
- (NSString *)refreshEmptyToast;
@end

@interface ATRefersh : NSObject
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue;
+ (BOOL)reachable;
+ (BOOL)iPad;
+ (BOOL)iPhoneX;
+ (CGFloat)NAVI_HIGHT;
@end

