//
//  ATTableViewCell.h
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ATTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitlaleb;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (strong, nonatomic) ATModel *model;
@end

NS_ASSUME_NONNULL_END
