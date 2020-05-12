//
//  ATTableController.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATTableController.h"
#import "ATTableViewCell.h"
@interface ATTableController ()
@property (assign, nonatomic) ATRefreshOption option;
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation ATTableController
+ (instancetype)vcWithOption:(ATRefreshOption )option{
    ATTableController *vc = [[[self class] alloc] init];
    vc.option = option;
    return  vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.listData= @[].mutableCopy;
    [self showNavTitle:@"玄幻"];
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:self.option];
}
- (void)refreshData:(NSInteger)page{
    NSInteger count = 40;
    NSDictionary *params =@{@"gender":@"male",@"major":@"玄幻",@"start":@(page),@"limit":@(count),@"type":@"hot",@"minor":@""};
    [ATTool getData:@"https://api.zhuishushenqi.com/book/by-categories" params:params success:^(id  _Nonnull object) {
        if (page == 1) {
            [self.listData removeAllObjects];
        }
        NSArray *datas = [NSArray modelArrayWithClass:ATModel.class json:object];
        if (datas.count > 0) {
            [self.listData addObjectsFromArray:datas];
        }
        [self.tableView reloadData];
        [self endRefresh:datas.count >= count];
    } failure:^(NSError * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ATTableViewCell *cell = [ATTableViewCell cellForTableView:tableView indexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}

@end
