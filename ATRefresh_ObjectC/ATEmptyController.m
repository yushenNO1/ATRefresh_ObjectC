//
//  ATEmptyController.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/12/23.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATEmptyController.h"

@interface ATEmptyController ()
@property (assign, nonatomic) BOOL needTitle;
@end

@implementation ATEmptyController
+ (instancetype)vcWithNeedTitle:(BOOL )needTitle{
    ATEmptyController *vc = [[[self class] alloc] init];
    vc.needTitle = needTitle;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavTitle:@"Empty Data"];
    [self setupRefresh:self.tableView option:ATRefreshDefault];
    // Do any additional setup after loading the view.
}
- (void)refreshData:(NSInteger)page{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefreshFailure];
    });
}
- (UIImage *)refreshLogoData{
    return self.refreshData.refreshing ? [UIImage imageNamed:@"icon_load_data"] : [UIImage imageNamed:@"icon_net_error"];
}
- (CAAnimation *)refreshAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
}
- (NSAttributedString *)refreshSubtitle{
    if (!self.needTitle) {
        return  nil;
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSString *text = @"This allows you to share photos from your library and save photos to your camera roll.";
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName :[ATRefresh colorWithRGB:0x999999],
                                 NSParagraphStyleAttributeName : paragraph};
    return [[NSMutableAttributedString alloc] initWithString:(text ? [NSString stringWithFormat:@"%@", text] : @"")
                                                  attributes:attributes];
}
- (UIButton *)refreshButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [UIImage imageNamed:@"icon_load_button"];
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(8, -60, 8, -60);
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    image = [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSString *text = @"Try Again";
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName :[UIColor whiteColor],
                                 NSParagraphStyleAttributeName : paragraph};
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    [button setAttributedTitle:att forState:UIControlStateNormal];
    return  button;
}
@end
