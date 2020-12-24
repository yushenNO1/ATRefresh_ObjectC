//
//  ATRefreshData.h
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/12/22.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRefresh_ObjectC.h"
#import "ATRefresh.h"

@interface ATRefreshData : NSObject

@property (nonatomic, assign) id <ATRefreshDataSource>dataSource;
@property (nonatomic, assign) id <ATRefreshDelegate>delegate;
@property (nonatomic, assign, readonly) BOOL refreshing;//数据是否刷新中
/**
 @brief 设置刷新控件 子类可在refreshData中发起网络请求, 请求结束后回调endRefresh结束刷新动作
 @param scrollView 刷新控件所在scrollView
 @param option 刷新空间样式
 */
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option;
/**
 @brief 分页加载成功 是否有下一页数据
 */
- (void)endRefresh:(BOOL)hasMore;
/**
 @brief 加载失败调用该方法
 */
- (void)endRefreshFailure;
@end

