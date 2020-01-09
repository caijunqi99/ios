//
//  OrderContentHeaderView.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/9.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "OrderContentHeaderView.h"

@implementation OrderContentHeaderView

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
        
        
        
        [_viewRoundBack setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        [_viewRoundBack rounded:10 rectCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];

        [_imageViewLeft setFrame:RectWithScale(CGRectMake(20, 40, 40, 40), GPCommonLayoutScaleSizeWidthIndex)];
        [_labelStoreName setFrame:RectWithScale(CGRectMake(80, 40, 600, 40), GPCommonLayoutScaleSizeWidthIndex)];
                
        [self addSubview:_viewRoundBack];
        [self addSubview:_imageViewLeft];
        [self addSubview:_labelStoreName];
    }
    return self;
}

-(void)setStore_name:(NSString *)store_name
{
    self.labelStoreName.text = store_name;
}

@end
