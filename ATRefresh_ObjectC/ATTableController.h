//
//  ATTableController.h
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATTableController : BaseTableViewController
+ (instancetype)vcWithOption:(ATRefreshOption )option;
@end

NS_ASSUME_NONNULL_END
