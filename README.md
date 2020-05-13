
1、ATRefresh_ObjectC集成方式:

    pod 'ATRefresh_ObjectC'
    pod 'ATRefresh_Swift'
    
2、ATRefresh_ObjectC使用方式:

    查看Ddemo
    2、1 无下拉刷新、无上拉加载
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshNone];
    
    2、2 无下拉刷新、无上拉加载
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATHeaderRefresh|ATHeaderAutoRefresh];
    
    2、3 无下拉刷新、有上拉加载
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATFooterRefresh|ATFooterAutoRefresh];
    
    2.4 有下拉刷新、有上拉加载
    [self setupEmpty:self.tableView];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
   
    For Example
   
     [ATTool getData:@"https://api.zhuishushenqi.com/book/by-categories" params:params success:^(id  _Nonnull object) {
            if (page == 1) {
                [self.listData removeAllObjects];
            }
            NSArray *datas = [NSArray modelArrayWithClass:ATModel.class json:object];
            if (datas.count > 0) {
                [self.listData addObjectsFromArray:datas];
            }
            [self.tableView reloadData];
            
            [self endRefresh:datas.count >= count];//判断是否有下一页
       } failure:^(NSError * _Nonnull error) {
       
            [self endRefreshFailure];
       }];
       
3、ATRefresh_Swift版本:
    
    [Swift版本](https://github.com/tianya2416/ATRefresh_Swift.git)
