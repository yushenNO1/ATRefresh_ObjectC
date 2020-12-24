//
//  ATRefreshData.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/12/22.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATRefreshData.h"

#define RefreshPageStart (1)
@interface ATRefreshData ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
    BOOL _isSetKVO;
    BOOL _needReload;
}
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL refreshing;

@property (nonatomic, strong) NSArray <UIImage *>*headers;
@property (nonatomic, strong) NSArray <UIImage *>*footers;
@property (nonatomic, strong) UIButton *button;
@end

@implementation ATRefreshData
- (void)dealloc {
    _scrollView.delegate = nil;
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", self.class);
}
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
- (UIButton *)button{
    if (!_button && [self.dataSource respondsToSelector:@selector(refreshButton)]) {
        _button = [self.dataSource refreshButton];
    }
    return _button;
}
#pragma mark - refresh 刷新处理
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option {
    [self setupEmpty:scrollView];
    self.scrollView = scrollView;
    //无
    if (option == ATRefreshNone) {
        [self headerRefreshing];
    }
    //下拉
    if (option & ATHeaderRefresh) {
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
        if (self.headers.count > 0) {
            header.automaticallyChangeAlpha = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
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
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        if (self.footers.count > 0) {
            [footer setImages:@[self.footers.firstObject] forState:MJRefreshStateIdle];
            [footer setImages:self.footers duration:0.35f forState:MJRefreshStateRefreshing];
            [footer setTitle:@"--我是有底线的--" forState:MJRefreshStateNoMoreData];
            [footer setTitle:@"" forState:MJRefreshStatePulling];
            [footer setTitle:@"" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
        }
        if (option & ATFooterAutoRefresh) {
            [self footerRefreshing];
        }
        scrollView.mj_footer = footer;
    }
}
- (void)setupEmpty:(UIScrollView *)scrollView {
    scrollView.emptyDataSetSource = self;
    scrollView.emptyDataSetDelegate = self;
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
- (void)refreshData:(NSInteger)page {
    self.currentPage = page;
    if ([self.delegate respondsToSelector:@selector(refreshData:)]) {
        [self.delegate refreshData:page];
    }
}
- (void)setRefreshing:(BOOL)refreshing{
    _refreshing = refreshing;
    if (self.scrollView.emptyDataSetVisible) {
        [self.scrollView reloadEmptyDataSet];
    }
}
#pragma mark DZNEmptyDataSetSource DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if ([self.dataSource respondsToSelector:@selector(refreshTitle)]) {
        return [self.dataSource refreshTitle];
    }
    return nil;
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if ([self.dataSource respondsToSelector:@selector(refreshSubtitle)]) {
        return  [self.dataSource refreshSubtitle];
    }
    return  nil;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if ([self.dataSource respondsToSelector:@selector(refreshLogoData)]) {
        return [self.dataSource refreshLogoData];
    }
    return  nil;
}
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    return  nil;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    if ([self.dataSource respondsToSelector:@selector(refreshLogoVertica)]) {
        return [self.dataSource refreshLogoVertica];
    }
    return - [ATRefresh at_naviBar]/2;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    if ([self.dataSource respondsToSelector:@selector(refreshLogoSpace)]) {
        return [self.dataSource refreshLogoSpace];
    }
    return 20;
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return self.refreshing ? nil : [self.button backgroundImageForState:state];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return  self.refreshing ? nil : [self.button attributedTitleForState:state];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    if ([self.dataSource respondsToSelector:@selector(refreshColor)]) {
        return [self.dataSource refreshColor];
    }
    return [UIColor whiteColor];
}
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    if ([self.dataSource respondsToSelector:@selector(refreshAnimation)] && self.refreshing) {
        return [self.dataSource refreshAnimation];
    }
    return nil;
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.refreshing;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return !self.refreshing;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return !self.refreshing;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (self.button == nil) {
        self.refreshing ? nil : [self headerRefreshing];
    }
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (self.button) {
        self.refreshing ? nil : [self headerRefreshing];
    }
}
@end
