//
//  ATModel.h
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit.h>
#import <YYKit/NSObject+YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface ATModel : NSObject<NSCoding, NSCopying,YYModel>
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *shortIntro;
@property (copy, nonatomic) NSString *author;
@end

NS_ASSUME_NONNULL_END

