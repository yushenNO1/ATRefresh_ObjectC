//
//  ViewController.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ViewController.h"
#import <ATKit.h>
#import "ATTableController.h"
#import "ATConnectionController.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray *listData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)refreshData:(NSInteger)page{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.listData = @[@"下拉刷新",@"上拉加载",@"上拉下拉",@"无上下拉",@"ConnectionView"];
        [self.tableView reloadData];
        [self endRefresh:NO];
    });
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell cellForTableView:tableView indexPath:indexPath];
    cell.textLabel.text = self.listData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.listData[indexPath.row];
    if ([title isEqualToString:@"ConnectionView"]) {
        [[UIViewController rootTopPresentedController].navigationController pushViewController:[ATConnectionController new] animated:true];
    }else{
        ATRefreshOption option = ATRefreshNone;
        if ( [title isEqualToString:@"下拉刷新"]) {
            option = ATHeaderRefresh | ATHeaderAutoRefresh;
        }else if ([title isEqualToString:@"上拉加载"]){
            option = ATFooterRefresh | ATFooterAutoRefresh;
        }else if ([title isEqualToString:@"上拉下拉"]){
            option = ATRefreshDefault;
        }
        [[UIViewController rootTopPresentedController].navigationController pushViewController:[ATTableController vcWithOption:option] animated:YES];
    }
}
@end
