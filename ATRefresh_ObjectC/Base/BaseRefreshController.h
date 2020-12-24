//
//  BaseRefreshController.h
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATRefreshData.h"
#import <Masonry.h>
#import "ATTool.h"
#import "ATModel.h"
#import <ATKit_ObjectC/ATKit.h>

@interface BaseRefreshController : UIViewController<ATRefreshDataSource,ATRefreshDelegate>
@property (strong, nonatomic,readonly) ATRefreshData *refreshData;

//default
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option;
//custom
- (void)setupRefresh:(UIScrollView *)scrollView option:(ATRefreshOption)option image:(NSString *)image title:(NSString *)title;
- (void)endRefresh:(BOOL)hasMore;

- (void)endRefreshFailure;
- (void)endRefreshFailure:(NSString *)error;
@end


