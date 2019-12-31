//
//  ShoppingCartBottomView.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/3.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCartBottomView : UIView

@property (nonatomic, strong) UIButton *buttonSelectAll;
@property (nonatomic, strong) UILabel *labelSelectAll;
@property (nonatomic, strong) UILabel *labelTotalPrice;

@property (nonatomic, strong) UIButton *buttonAccount;

@property (nonatomic, copy) void (^AllClickBlock)(BOOL isClick);
@property (nonatomic, copy) void (^AccountBlock)(void);



@property (nonatomic, assign) BOOL isClick;

-(instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
