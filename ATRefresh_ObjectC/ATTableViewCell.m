//
//  ATTableViewCell.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATTableViewCell.h"
#import "UIImageView+ATLoad.h"
@implementation ATTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(ATModel *)model{
    if (_model != model) {
        _model = model;
        [self.imageV setGkImageWithURL:model.cover];
        self.titleLab.text = model.title ?:@"";
        self.subTitlaleb.text = model.shortIntro ?:@"";
        self.nickNameLab.text = model.author ?:@"";
    }
}
@end
