//
//  ATConnectionController.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATConnectionController.h"
#import "ATCollectionViewCell.h"
@interface ATConnectionController ()
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation ATConnectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listData= @[].mutableCopy;
    [self showNavTitle:@"玄幻"];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
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
        [self.collectionView reloadData];
        [self endRefresh:datas.count >= count];
    } failure:^(NSError * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 4 *10 -1)/3;
    CGFloat height = width * 1.3 + 30;
    return CGSizeMake(width, height);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ATCollectionViewCell *cell = [ATCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10,10,10);
}
@end
