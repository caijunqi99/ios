//
//  RechargeBottomView.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/29.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RechargeBottomView : UIView
@property (nonatomic, strong) UILabel *labelTotalPrice;

@property (nonatomic, strong) UIButton *buttonAccount;

@property (nonatomic, copy) void (^AccountBlock)(void);

-(instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
