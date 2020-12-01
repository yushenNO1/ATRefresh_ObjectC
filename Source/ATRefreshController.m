//
//  ATRefreshController.m
//  RefreshController
//
//  Created by wangws1990 on 2018/7/19. 
//  Copyright © 2018年 wangws1990. All rights reserved.
//

#import "ATRefreshController.h"
#define RefreshPageStart (1)
#define RefreshPageSize (20)
@interface ATRefreshController ()<UIGestureRecognizerDelegate> {
    BOOL _isSetKVO;
    BOOL _needReload;
    __weak UIView *_emptyView;
}
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, assign) BOOL reachable;

@property (nonatomic, strong) NSArray <UIImage *>*headers;
@property (nonatomic, strong) NSArray <UIImage *>*footers;

@property (nonatomic, strong) UIImage *loaderData;
@property (nonatomic, strong) UIImage *emptyData;
@property (nonatomic, strong) UIImage *errorData;

@property (nonatomic, copy) NSString *emptyTitle;
@property (nonatomic, copy) NSString *errorTitle;
@property (nonatomic, copy) NSString *loaderTitle;
@end

@implementation ATRefreshController
- (NSArray *)headers{
    if (!_headers && [self.dataSource respondsToSelector:@selector(refreshHeaderData)]) {
        _headers = [self.dataSource refreshHeaderData];
    }
    return _headers;
}
- (NSArray *)footers{
    if (!_footers && [self.dataSource respondsToSelector:@selector(refreshFooterData)]) {
        _footers = [self.dataSource refreshFooterData];
    }
    return _footers;
}
- (UIImage *)loaderData{
    if (!_loaderData && [self.dataSource respondsToSelector:@selector(refreshLoaderData)]) {
        NSArray *datas = [self.dataSource refreshLoaderData];
        _loaderData = [UIImage animatedImageWithImages:datas duration:0.35];
    }
    return _loaderData;
}
- (UIImage *)emptyData{
    if (!_emptyData && [self.dataSource respondsToSelector:@selector(refreshEmptyData)]) {
        _emptyData = [self.dataSource refreshEmptyData];
    }
    return _emptyData;
}
- (UIImage *)errorData{
    if (!_errorData && [self.dataSource respondsToSelector:@selector(refreshErrorData)]) {
        _errorData = [self.dataSource refreshErrorData];
    }
    return _errorData;
}
- (NSString *)errorTitle{
    if (!_errorTitle && [self.dataSource respondsToSelector:@selector(refreshErrorToast)]) {
        _errorTitle = [self.dataSource refreshErrorToast];
    }
    return _errorTitle;
}
- (NSString *)emptyTitle{
    if (!_emptyTitle && [self.dataSource respondsToSelector:@selector(refreshEmptyToast)]) {
        _emptyTitle = [self.dataSource refreshEmptyToast];
    }
    return _emptyTitle;
}
- (NSString *)loaderTitle{
    if (!_loaderTitle && [self.dataSource respondsToSelector:@selector(refreshLoaderToast)]) {
        _loaderTitle = [self.dataSource refreshLoaderToast];
    }
    return _loaderTitle;
}
- (void)dealloc {
    _scrollView.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}
#pragma mark - refresh 刷新处理
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option {
    self.scrollView = scrollView;
    //无
    if (option == ATRefreshNone) {
        [self headerRefreshing];
    }
    //下拉
    if (option & ATHeaderRefresh) {
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        if (self.headers.count > 0) {
            [header setImages:@[self.headers.firstObject] forState:MJRefreshStateIdle];
            [header setImages:self.headers duration:0.35f forState:MJRefreshStateRefreshing];
        }
        if (option & ATHeaderAutoRefresh) {
            [self headerRefreshing];
        }
        scrollView.mj_header = header;
    }
    //上拉
    if (option & ATFooterRefresh) {
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
        footer.triggerAutomaticallyRefreshPercent = 1;//-20
        footer.stateLabel.hidden = NO;
        footer.labelLeftInset = -22;
    
        if (self.footers.count > 0) {
            [footer setImages:@[self.footers.firstObject] forState:MJRefreshStateIdle];
            [footer setImages:self.footers duration:0.35f forState:MJRefreshStateRefreshing];
        }
        [footer setTitle:@"--我是有底线的--" forState:MJRefreshStateNoMoreData];
        [footer setTitle:@"" forState:MJRefreshStatePulling];
        [footer setTitle:@"" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        if (option & ATFooterAutoRefresh) {
            [self footerRefreshing];
        }
        scrollView.mj_footer = footer;
    }
}
- (void)headerRefreshing {
    if (self.refreshing == NO) {
        self.refreshing = YES;
        self.scrollView.mj_footer.hidden = YES;
        self.currentPage = RefreshPageStart;
        if ([self respondsToSelector:@selector(refreshData:)]) {
            [self refreshData:self.currentPage];
        }
    }
}

- (void)footerRefreshing {
    if (self.refreshing == NO) {
        self.refreshing = YES;
        self.currentPage++;
        [self refreshData:self.currentPage];
    }
}

- (void)endRefreshFailure {
    if (self.currentPage > RefreshPageStart) {
        self.currentPage--;
    }
    [self baseEndRefreshing];
    if (self.scrollView.mj_footer.isRefreshing) {
        self.scrollView.mj_footer.state = MJRefreshStateIdle;
    }
}
- (void)baseEndRefreshing {
    if (self.scrollView.mj_header.isRefreshing) {
        [self.scrollView.mj_header endRefreshing];
    }
    self.refreshing = NO;
}
- (void)endRefresh:(BOOL)hasMore {
    [self baseEndRefreshing];
    
    if (hasMore) {
        self.scrollView.mj_footer.state = MJRefreshStateIdle;
        ((MJRefreshAutoStateFooter *)self.scrollView.mj_footer).stateLabel.textColor = [ATRefresh colorWithRGB:0x666666];
        self.scrollView.mj_footer.hidden = NO;
    }
    else {
        self.scrollView.mj_footer.state = MJRefreshStateNoMoreData;
        ((MJRefreshAutoStateFooter *)self.scrollView.mj_footer).stateLabel.textColor = [ATRefresh colorWithRGB:0x999999];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGFloat height  = (self.scrollView.contentSize.height);
            CGFloat sizeHeight  = (self.scrollView.frame.size.height);
            self.scrollView.mj_footer.hidden = (self.currentPage == RefreshPageStart) || (height < sizeHeight);
        });
    }
}
- (void)endRefreshNeedHidden:(BOOL)hasMore {
    [self baseEndRefreshing];
    
    self.scrollView.mj_footer.state = hasMore ? MJRefreshStateIdle : MJRefreshStateNoMoreData;
    self.scrollView.mj_footer.hidden = !hasMore;
}

- (void)refreshData:(NSInteger)page {
    self.currentPage = page;
    
    if ([NSStringFromClass(self.class) isEqualToString:NSStringFromClass(ATRefreshController.class)]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.scrollView.mj_header.isRefreshing || self.scrollView.mj_footer.isRefreshing) {
                [self endRefreshFailure];
            }
        });
    }
}
- (void)setRefreshing:(BOOL)refreshing{
    _refreshing = refreshing;
    if (self.scrollView.emptyDataSetVisible) {
        [self.scrollView reloadEmptyDataSet];
    }
}

#pragma mark - DZNEmptyData 空数据界面处理
- (void)setupEmpty:(UIScrollView *)scrollView {
    [self setupEmpty:scrollView image:nil title:nil];
}
- (void)setupEmpty:(UIScrollView *)scrollView image:(UIImage *)image title:(NSString *)title {
    scrollView.emptyDataSetSource = self;
    scrollView.emptyDataSetDelegate = self;
    if (image) {
        self.emptyData = image;
    }
    if (title) {
        self.emptyTitle = title;
    }
    if (_isSetKVO) {
        return;
    }
    _isSetKVO = YES;
    [self.KVOController observe:scrollView keyPaths:@[FBKVOKeyPath(scrollView.contentSize), FBKVOKeyPath(scrollView.contentInset)] options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, UIScrollView * _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (object.contentOffset.y >= -object.mj_inset.top && object.emptyDataSetVisible) {
            [NSObject cancelPreviousPerformRequestsWithTarget:object selector:@selector(reloadEmptyDataSet) object:nil];
            [object performSelector:@selector(reloadEmptyDataSet) withObject:nil afterDelay:0.01];
        }
    }];
}
#pragma mark DZNEmptyDataSetSource DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSString *text = self.refreshing ? self.loaderTitle : (self.reachable ?self.emptyTitle:self.errorTitle);
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName :[ATRefresh colorWithRGB:0x999999],
                                 NSParagraphStyleAttributeName : paragraph};
    return [[NSMutableAttributedString alloc] initWithString:(text ? [NSString stringWithFormat:@"\r\n%@", text] : @"")
                                                  attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return self.refreshing ? self.loaderData : (self.reachable ? self.emptyData : self.errorData);
}

#pragma mark - DZNEmptyDataSetDelegate
// 是否可以动画显示
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    
    return NO;
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -[ATRefresh NAVI_HIGHT]/2;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 1;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return !self.refreshing;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    self.refreshing ? nil : [self headerRefreshing];
}
- (BOOL)reachable{
    return  [ATRefresh reachable];
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES ;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
//这个是返回优先方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
