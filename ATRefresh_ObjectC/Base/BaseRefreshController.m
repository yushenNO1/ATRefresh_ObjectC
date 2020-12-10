//
//  BaseRefreshController.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "BaseRefreshController.h"
#import <AFNetworking.h>
@interface BaseRefreshController ()<ATRefreshDataSource>
@property (strong, nonatomic) NSArray *imageDatas;
@end

@implementation BaseRefreshController
- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", self.class);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *data = @[].mutableCopy;
    for (int i = 1; i<=35 ; i++) {
        NSString *count = [NSString stringWithFormat:@"下拉loading_00%@%@",i<10?@"0":@"",@(i)];
        UIImage *image = [UIImage imageNamed:count];
        [data addObject:image];
    }
    self.imageDatas = data.copy;
    self.dataSource = self;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}
#pragma mark ATRefreshDataSource
- (NSArray <UIImage *>*)refreshFooterData{
    return self.imageDatas;
}
- (NSArray <UIImage *>*)refreshHeaderData{
    return self.imageDatas;
}
- (NSArray <UIImage *>*)refreshLoaderData{
    return self.imageDatas;
}
- (UIImage *)refreshEmptyData{
    return [UIImage imageNamed:@"icon_data_empty"];
}
- (UIImage *)refreshErrorData{
    return [UIImage imageNamed:@"icon_net_error"];
}
- (NSString *)refreshLoaderToast{
    return @"数据加载中...";
}
- (NSString *)refreshErrorToast{
    return @"网络错误...";
}
- (NSString *)refreshEmptyToast{
    return  @"没有数据...";
}

- (BOOL)refreshNetAvailable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
@end
