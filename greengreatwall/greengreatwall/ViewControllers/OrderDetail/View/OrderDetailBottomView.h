//
//  OrderDetailBottomView.h
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/4.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailBottomView : UIView
@property (nonatomic, strong) void ((^btnClick)(UIButton*));

@property (nonatomic, strong) UIButton *buttonCancel;

@property (nonatomic, strong) UIButton *buttonDelete;

@property (nonatomic, strong) UIButton *buttonConfirm;

@property (nonatomic, strong) UIButton *buttonToPay;

@property (nonatomic, strong) UIButton *buttonViewExpress;

@property (nonatomic, strong) NSMutableArray *arrayButton;



-(instancetype)initWithFrame:(CGRect)frame;
-(void)setStyle:(NSString *)style;
@end

NS_ASSUME_NONNULL_END
