//
//  OrderDetailHeaderView.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/4.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "OrderDetailHeaderView.h"

@implementation OrderDetailHeaderView

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
        _labelStoreName.numberOfLines = 1;
        _labelStoreName.lineBreakMode = NSLineBreakByCharWrapping;
        _labelStoreName.textColor = kColorFontMedium;
        _labelStoreName.backgroundColor = [UIColor clearColor];
        _labelStoreName.textAlignment = NSTextAlignmentLeft;
        [_labelStoreName setFont:FontMediumWithSize(16)];
        
        _labelState = [[UILabelAlignToTopLeft alloc] init];
        _labelState.numberOfLines = 1;
        _labelState.lineBreakMode = NSLineBreakByCharWrapping;
        _labelState.textColor = kColorTheme;
        _labelState.backgroundColor = [UIColor clearColor];
        _labelState.textAlignment = NSTextAlignmentRight;
        [_labelState setFont:FontMediumWithSize(16)];
        
        
        
        [_viewRoundBack setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        [_viewRoundBack rounded:10 rectCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];

        [_imageViewLeft setFrame:RectWithScale(CGRectMake(20, 40, 40, 40), GPCommonLayoutScaleSizeWidthIndex)];
        [_labelStoreName setFrame:RectWithScale(CGRectMake(80, 40, 600, 40), GPCommonLayoutScaleSizeWidthIndex)];
        [_labelState setFrame:RectWithScale(CGRectMake(680, 40, 260, 40), GPCommonLayoutScaleSizeWidthIndex)];
                
        [self addSubview:_viewRoundBack];
        [self addSubview:_imageViewLeft];
        [self addSubview:_labelStoreName];
//        [self addSubview:_labelState];
    }
    return self;
}

-(void)setStore_name:(NSString *)store_name andState:(NSString *)state
{
    self.labelStoreName.text = store_name;
    self.labelState.text = state;
}

@end
