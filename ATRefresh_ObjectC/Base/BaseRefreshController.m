//
//  BaseRefreshController.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "BaseRefreshController.h"
#import <AFNetworking.h>
#import <YYKit.h>
NSString *loadTitle  = @"Data loading...";
NSString *emptyTitle = @"Data Empty...";
NSString *errorTitle = @"Net Error...";
NSString *emptyData = @"icon_data_empty";
NSString *errorData = @"icon_net_error";
static
@interface BaseRefreshController ()
@property (strong, nonatomic) NSArray *imageDatas;
@property (strong, nonatomic) ATRefreshData *refreshData;
@end

@implementation BaseRefreshController
- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", self.class);
}
- (ATRefreshData *)refreshData{
    if (!_refreshData) {
        _refreshData = [[ATRefreshData alloc] init];
        _refreshData.dataSource = self;
        _refreshData.delegate = self;
    }
    return _refreshData;
}
- (NSArray *)imageDatas{
    if (!_imageDatas) {
        NSMutableArray *data = @[].mutableCopy;
        for (int i = 1; i<=35 ; i++) {
            NSString *count = [NSString stringWithFormat:@"下拉loading_00%@%@",i<10?@"0":@"",@(i)];
            UIImage *image = [UIImage imageNamed:count];
            [data addObject:image];
        }
        _imageDatas = data.copy;
    }
    return _imageDatas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option{
    [self setupRefresh:scrollView option:option image:nil title:nil];
}
- (void)setupRefresh:(UIScrollView *)scrollView
              option:(ATRefreshOption)option
               image:(NSString *)image
               title:(NSString *)title{
    if (title.length > 0) {
        emptyTitle = title;
    }
    if (image) {
        emptyData = image;
    }
    if ([self.refreshData respondsToSelector:@selector(setupRefresh:option:)]) {
        [self.refreshData setupRefresh:scrollView option:option];
    }
}
- (void)endRefresh:(BOOL)hasMore{
    if ([self.refreshData respondsToSelector:@selector(endRefresh:)]) {
        [self.refreshData endRefresh:hasMore];
    }
}
- (void)endRefreshFailure{
    [self endRefreshFailure:nil];
}
- (void)endRefreshFailure:(NSString *)error{
    if (error.length > 0) {
        errorTitle = error;
    }
    if ([self.refreshData respondsToSelector:@selector(endRefreshFailure)]) {
        [self.refreshData endRefreshFailure];
    }
}
- (BOOL)refreshNetAvailable {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}
#pragma mark ATRefreshDelegate
- (void)refreshData:(NSInteger)page {
    
}
#pragma mark ATRefreshDataSource
- (NSArray <UIImage *>*)refreshHeaderData{
    return self.imageDatas;
}
- (NSArray <UIImage *>*)refreshFooterData{
    return self.imageDatas;
}
- (UIImage *)refreshLogoData{
    return self.refreshData.refreshing ? [UIImage animatedImageWithImages:self.imageDatas duration:0.4] : [UIImage imageNamed:[self refreshNetAvailable]? emptyData:errorData];
}
- (NSAttributedString *)refreshTitle{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSString *text = self.refreshData.refreshing ? loadTitle : ([self refreshNetAvailable] ? emptyTitle : errorTitle);
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName :[ATRefresh colorWithRGB:0x333333],
                                 NSParagraphStyleAttributeName : paragraph};
    return [[NSMutableAttributedString alloc] initWithString:text
                                                  attributes:attributes];
}
- (NSAttributedString *)refreshSubtitle{
    return nil;
}
- (UIButton *)refreshButton{
    return nil;
}
@end
