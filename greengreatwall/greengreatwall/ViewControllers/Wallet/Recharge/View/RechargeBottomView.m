//
//  RechargeBottomView.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/29.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "RechargeBottomView.h"

@implementation RechargeBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:([UIColor whiteColor])];
        
        _labelTotalPrice = [[UILabel alloc] init];
        _labelTotalPrice.numberOfLines = 1;
        _labelTotalPrice.lineBreakMode = LineBreakModeDefault;
        _labelTotalPrice.textColor = [UIColor blackColor];
        _labelTotalPrice.backgroundColor = [UIColor clearColor];
        _labelTotalPrice.textAlignment = NSTextAlignmentLeft;
        [_labelTotalPrice setFont:FontMediumWithSize(16)];
        [_labelTotalPrice setFrame:RectWithScale(CGRectMake(110, 80, 500, 40), GPCommonLayoutScaleSizeWidthIndex)];
        _labelTotalPrice.text = [NSString stringWithFormat:@"充值金额 ￥ 0元"];
        
        _buttonAccount = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonAccount setTitle:@"充值" forState:UIControlStateNormal];
        [_buttonAccount.titleLabel setFont:FontRegularWithSize(16)];
        [_buttonAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonAccount setBackgroundColor:kColorTheme];
        [_buttonAccount setFrame:RectWithScale(CGRectMake(720, 40, 300, 100), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonAccount addTarget:self action:@selector(accountBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonAccount.layer.masksToBounds = YES;
        _buttonAccount.clipsToBounds = YES;
        [_buttonAccount.layer setCornerRadius:50*GPCommonLayoutScaleSizeWidthIndex];
        
        
        [self addSubview:_labelTotalPrice];
        [self addSubview:_buttonAccount];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)accountBtn:(UIButton *)sender {
    if (self.AccountBlock) {
        self.AccountBlock();
    }
}

@end
