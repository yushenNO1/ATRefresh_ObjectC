//
//  ATRefershController.h
//  RefreshController
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <KVOController.h>
#import "ATRefersh.h"


@interface ATRefershController : UIViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) id <ATRefreshDataSource>dataSource;//数据源

@property (nonatomic, assign, readonly) NSInteger currentPage;//当前页数
@property (nonatomic, assign, readonly) BOOL refreshing;//数据是否刷新中
@property (nonatomic, assign, readonly) BOOL reachable; //网络是否可达
/**
 @brief 设置刷新控件 子类可在refreshData中发起网络请求, 请求结束后回调endRefresh结束刷新动作
 @param scrollView 刷新控件所在scrollView
 @param option 刷新空间样式
 */
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option;
/**
 设置空界面显示, 如果需要定制化 请实现协议 DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
 tableView或者CollectionView数据reload后, 空界面展示可自动触发, 如需强制刷新, 请调用 [scrollView reloadEmptyDataSet];
 
 @param scrollView 空界面所在scrollView
 @param image 空界面图片
 @param title 空界面标题
 */
- (void)setupEmpty:(UIScrollView *)scrollView image:(UIImage *)image title:(NSString *)title;
- (void)setupEmpty:(UIScrollView *)scrollView;
/**
 @brief 分页请求一开始page = 1
 @param page 当前页码
 */
- (void)refreshData:(NSInteger)page;
/**
 @brief 分页加载成功 是否有下一页数据
 */
- (void)endRefresh:(BOOL)hasMore;
- (void)endRefreshNeedHidden:(BOOL)hasMore;
/**
 @brief 加载失败调用该方法
 */
- (void)endRefreshFailure;

- (void)headerRefreshing NS_REQUIRES_SUPER;
- (void)footerRefreshing NS_REQUIRES_SUPER;

@end