//
//  ATCollectionViewCell.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATCollectionViewCell.h"
#import "UIImageView+ATLoad.h"
@implementation ATCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ATModel *)model{
    if (_model != model) {
        _model = model;
        [self.imageV setGkImageWithURL:model.cover];
        self.titleLab.text = model.title;
    }
}
@end
