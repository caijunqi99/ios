//
//  ShoppingCartBottomView.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/3.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ShoppingCartBottomView.h"

@implementation ShoppingCartBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:(kColorTheme)];
        
        _buttonSelectAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonSelectAll setImage:GetImage(@"椭圆白") forState:(UIControlStateNormal)];
        [_buttonSelectAll setFrame:RectWithScale(CGRectMake(50, 80, 40, 40), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonSelectAll addTarget:self action:@selector(clickAll:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonSelectAll setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        
        _labelSelectAll = [[UILabel alloc] init];
        _labelSelectAll.numberOfLines = 1;
        _labelSelectAll.lineBreakMode = NSLineBreakByCharWrapping;
        _labelSelectAll.textColor = [UIColor whiteColor];
        _labelSelectAll.backgroundColor = [UIColor clearColor];
        _labelSelectAll.textAlignment = NSTextAlignmentLeft;
        [_labelSelectAll setFont:FontMediumWithSize(16)];
        _labelSelectAll.text = @"全选";
        [_labelSelectAll setFrame:RectWithScale(CGRectMake(100, 80, 100, 40), GPCommonLayoutScaleSizeWidthIndex)];
        
        _labelTotalPrice = [[UILabel alloc] init];
        _labelTotalPrice.numberOfLines = 1;
        _labelTotalPrice.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTotalPrice.textColor = [UIColor whiteColor];
        _labelTotalPrice.backgroundColor = [UIColor clearColor];
        _labelTotalPrice.textAlignment = NSTextAlignmentLeft;
        [_labelTotalPrice setFont:FontMediumWithSize(16)];
        [_labelTotalPrice setFrame:RectWithScale(CGRectMake(210, 80, 500, 40), GPCommonLayoutScaleSizeWidthIndex)];
        _labelTotalPrice.text = [NSString stringWithFormat:@"合计 ￥0.00"];
        
        _buttonAccount = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonAccount setTitle:@"立即结算" forState:UIControlStateNormal];
        [_buttonAccount.titleLabel setFont:FontRegularWithSize(16)];
        [_buttonAccount setTitleColor:kColorTheme forState:UIControlStateNormal];
        [_buttonAccount setBackgroundColor:[UIColor whiteColor]];
        [_buttonAccount setFrame:RectWithScale(CGRectMake(720, 40, 300, 100), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonAccount addTarget:self action:@selector(accountBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonAccount.layer.masksToBounds = YES;
        _buttonAccount.clipsToBounds = YES;
        [_buttonAccount.layer setCornerRadius:50*GPCommonLayoutScaleSizeWidthIndex];
        
        
        [self addSubview:_buttonSelectAll];
        [self addSubview:_labelTotalPrice];
        [self addSubview:_labelSelectAll];
        [self addSubview:_buttonAccount];
        
        [self rounded:10 rectCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)clickAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:GetImage(@"结算选中") forState:(UIControlStateNormal)];
    } else {
        [sender setImage:GetImage(@"椭圆白") forState:(UIControlStateNormal)];
    }
    if (self.AllClickBlock) {
        self.AllClickBlock(sender.selected);
    }
}

- (void)accountBtn:(UIButton *)sender {
    if (self.AccountBlock) {
        self.AccountBlock();
    }
}

- (void)setIsClick:(BOOL)isClick {
    _isClick = isClick;
    self.buttonSelectAll.selected = isClick;
    if (isClick) {
        [self.buttonSelectAll setImage:GetImage(@"结算选中") forState:(UIControlStateNormal)];
    } else {
        [self.buttonSelectAll setImage:GetImage(@"椭圆白") forState:(UIControlStateNormal)];
    }
}

@end
