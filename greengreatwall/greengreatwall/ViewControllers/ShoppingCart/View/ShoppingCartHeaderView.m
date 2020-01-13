//
//  ShoppingCartHeaderView.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/3.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ShoppingCartHeaderView.h"

@implementation ShoppingCartHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _viewRoundBack = [UIView initViewBackColor:[UIColor whiteColor]];
        
        _imageViewLeft = [[UIImageView alloc]init];
        [_imageViewLeft setImage:GetImage(@"商城购物车")];
        [_imageViewLeft setContentMode:UIViewContentModeScaleAspectFit];
        [_imageViewLeft setClipsToBounds:YES];
        
        _labelStoreName = [[UILabelAlignToTopLeft alloc] init];
        _labelStoreName.numberOfLines = 3;
        _labelStoreName.lineBreakMode = LineBreakModeDefault;
        _labelStoreName.textColor = kColorFontMedium;
        _labelStoreName.backgroundColor = [UIColor clearColor];
        _labelStoreName.textAlignment = NSTextAlignmentLeft;
        [_labelStoreName setFont:FontMediumWithSize(16)];
        
        _buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonSelect setImage:GetImage(@"椭圆") forState:UIControlStateNormal];
        [_buttonSelect setTitle:@"选择" forState:UIControlStateNormal];
        [_buttonSelect.titleLabel setFont:FontRegularWithSize(16)];
        [_buttonSelect setTitleColor:GPHexColor(0xFFFFFF) forState:UIControlStateNormal];
        [_buttonSelect setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        
        [_buttonSelect addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewRoundBack setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_viewRoundBack rounded:10 rectCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];
        [_buttonSelect setFrame:RectWithScale(CGRectMake(40, 40, 40, 40), GPCommonLayoutScaleSizeWidthIndex)];
        [_imageViewLeft setFrame:RectWithScale(CGRectMake(120, 40, 40, 40), GPCommonLayoutScaleSizeWidthIndex)];
        [_labelStoreName setFrame:RectWithScale(CGRectMake(180, 40, 800, 40), GPCommonLayoutScaleSizeWidthIndex)];
                
        [self addSubview:_viewRoundBack];
        [self addSubview:_imageViewLeft];
        [self addSubview:_labelStoreName];
        [self addSubview:_buttonSelect];
        
//        [self rounded:10 rectCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];
    }
    return self;
}

- (void)click:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:GetImage(@"选中") forState:(UIControlStateNormal)];
    } else {
        [sender setImage:GetImage(@"椭圆") forState:(UIControlStateNormal)];
    }
    if (self.buttonSelect) {
        self.ClickBlock(sender.selected);
    }
}

- (void)setStoreModel:(StoreModel *)storeModel {
    self.labelStoreName.text = storeModel.store_name;
    self.isClick = storeModel.isSelect;
}

- (void)setIsClick:(BOOL)isClick {
    _isClick = isClick;
    self.buttonSelect.selected = isClick;
    if (isClick) {
        [self.buttonSelect setImage:GetImage(@"选中") forState:(UIControlStateNormal)];
    } else {
        [self.buttonSelect setImage:GetImage(@"椭圆") forState:(UIControlStateNormal)];
    }
}

@end
