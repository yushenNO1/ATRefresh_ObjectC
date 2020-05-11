//
//  ViewController.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ViewController.h"
#import <ATKit.h>
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
    return 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell cellForTableView:tableView indexPath:indexPath];
    cell.textLabel.text = self.listData[indexPath.row];
    return cell;
}
@end
