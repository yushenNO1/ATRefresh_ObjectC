
1、ATRefresh_ObjectC集成方式:

    pod 'ATRefresh_ObjectC'
    如果想使用最新的功能可以这样
    pod 'ATRefresh_ObjectC',    :git => 'https://github.com/tianya24/ATRefresh_ObjectC.git'
    
2、ATRefresh_ObjectC使用方式:

    查看Ddemo
    2.1、Create BaseRefershController
    - (ATRefreshData *)refreshData{
        if (!_refreshData) {
            _refreshData = [[ATRefreshData alloc] init];
            _refreshData.dataSource = self;
            _refreshData.delegate = self;
        }
        return _refreshData;
    }
    2.2、implementation delegate and dataSource
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
    
    2.3、do something BaseRefershController
    
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

3、extends BaseRefershController : 

    3、1 无下拉刷新、无上拉加载
    [self setupRefresh:self.tableView option:ATRefreshNone];
    
    3、2 有下拉刷新、无上拉加载
    [self setupRefresh:self.tableView option:ATHeaderRefresh|ATHeaderAutoRefresh];
    
    3、3 无下拉刷新、有上拉加载
    [self setupRefresh:self.tableView option:ATFooterRefresh|ATFooterAutoRefresh];
    
    3.4 有下拉刷新、有上拉加载
    [self setupRefresh:self.tableView option:ATRefreshDefault];
   
    - (void)refreshData:(NSInteger)page{
        NSInteger count = 20;
        NSDictionary *params =@{@"gender":@"male",@"major":@"玄幻",@"start":@((page - 1) * 20 + 1),@"limit":@(count),@"type":@"hot",@"minor":@""};
        [ATTool getData:@"https://api.zhuishushenqi.com/book/by-categories" params:params success:^(id  _Nonnull object) {
            if (page == 1) {
                [self.listData removeAllObjects];
            }
            NSArray *datas = [NSArray modelArrayWithClass:ATModel.class json:object];
            if (datas.count > 0) {
                [self.listData addObjectsFromArray:datas];
            }
            [self.collectionView reloadData];
            [self endRefresh:datas.count >= count];//判断是否有下一页
        } failure:^(NSError * _Nonnull error) {
            [self endRefreshFailure];
        }];
    }
4、ATRefresh_Swift版本:

[Swift版本](https://github.com/tianya2416/ATRefresh_Swift.git)
