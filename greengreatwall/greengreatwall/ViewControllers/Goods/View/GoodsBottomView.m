//
//  GoodsBottomView.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/4.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "GoodsBottomView.h"

@implementation GoodsBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:(kColorTheme)];
        
        _buttonToStore = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonToStore setBackgroundImage:GetImageUseColor([UIColor whiteColor], CGRectMake(0, 0, 1, 1)) forState:(UIControlStateNormal)];
        [_buttonToStore setImage:GetImage(@"商城") forState:(UIControlStateNormal)];
        [_buttonToStore setFrame:RectWithScale(CGRectMake(0, 0, 150, 130), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonToStore addTarget:self action:@selector(toStore:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonToStore setTitle:@"店铺" forState:UIControlStateNormal];
        [_buttonToStore.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonToStore setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_buttonToStore layoutButtonWithEdgeInsetsStyle:HPButtonEdgeInsetsStyleTop imageTitleSpace:0];
        
        _buttonToCall = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonToCall setBackgroundImage:GetImageUseColor([UIColor whiteColor], CGRectMake(0, 0, 1, 1)) forState:(UIControlStateNormal)];
        [_buttonToCall setImage:GetImage(@"客服(1)") forState:(UIControlStateNormal)];
        [_buttonToCall setFrame:RectWithScale(CGRectMake(150, 0, 150, 130), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonToCall addTarget:self action:@selector(toCall:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonToCall setTitle:@"联系商家" forState:UIControlStateNormal];
        [_buttonToCall.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonToCall setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_buttonToCall layoutButtonWithEdgeInsetsStyle:HPButtonEdgeInsetsStyleTop imageTitleSpace:0];
        
        _buttonToShoppingCart = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonToShoppingCart setBackgroundImage:GetImageUseColor([UIColor whiteColor], CGRectMake(0, 0, 1, 1)) forState:(UIControlStateNormal)];
        [_buttonToShoppingCart setImage:GetImage(@"购物车-副本") forState:(UIControlStateNormal)];
        [_buttonToShoppingCart setFrame:RectWithScale(CGRectMake(300, 0, 150, 130), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonToShoppingCart setBackgroundColor:[UIColor clearColor]];
        [_buttonToShoppingCart addTarget:self action:@selector(toShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonToShoppingCart setTitle:@"购物车" forState:UIControlStateNormal];
        [_buttonToShoppingCart.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonToShoppingCart setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_buttonToShoppingCart layoutButtonWithEdgeInsetsStyle:HPButtonEdgeInsetsStyleTop imageTitleSpace:0];
        
        _buttonPutInShoppingCart = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonPutInShoppingCart setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_buttonPutInShoppingCart.titleLabel setFont:FontRegularWithSize(16)];
        [_buttonPutInShoppingCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonPutInShoppingCart setBackgroundColor:rgb(43, 207, 112)];
        [_buttonPutInShoppingCart setFrame:RectWithScale(CGRectMake(450, 0, 315, 130), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonPutInShoppingCart addTarget:self action:@selector(putInShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonPurchase = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonPurchase setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buttonPurchase.titleLabel setFont:FontRegularWithSize(16)];
        [_buttonPurchase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonPurchase setBackgroundColor:rgb(0, 182, 141)];
        [_buttonPurchase setFrame:RectWithScale(CGRectMake(765, 0, 315, 130), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonPurchase addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [self addSubview:_buttonToStore];
        [self addSubview:_buttonToCall];
        [self addSubview:_buttonPutInShoppingCart];
        [self addSubview:_buttonPurchase];
        [self addSubview:_buttonToShoppingCart];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)toStore:(UIButton *)sender {
    if (self.ToStoreBlock) {
        self.ToStoreBlock();
    }
}

- (void)toCall:(UIButton *)sender {
    if (self.ToCallBlock) {
        self.ToCallBlock();
    }
}

- (void)toShoppingCart:(UIButton *)sender {
    if (self.ToShoppingCartBlock) {
        self.ToShoppingCartBlock();
    }
}

- (void)putInShoppingCart:(UIButton *)sender {
    if (self.PutInShoppingCartBlock) {
        self.PutInShoppingCartBlock();
    }
}

- (void)purchase:(UIButton *)sender {
    if (self.PurchaseBlock) {
        self.PurchaseBlock();
    }
}

@end
