//
//  OrderListHeaderView.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/29.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "OrderListHeaderView.h"

@implementation OrderListHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _viewRoundBack = [UIView initViewBackColor:[UIColor whiteColor]];
        
        _labelState = [[UILabelAlignToTopLeft alloc] init];
        _labelState.numberOfLines = 1;
        _labelState.lineBreakMode = NSLineBreakByCharWrapping;
        _labelState.textColor = kColorTheme;
        _labelState.backgroundColor = [UIColor whiteColor];
        _labelState.textAlignment = NSTextAlignmentRight;
        [_labelState setFont:FontMediumWithSize(16)];
        
        
        
        [_viewRoundBack setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_viewRoundBack rounded:10 rectCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];

        [_labelState setFrame:RectWithScale(CGRectMake(680, 40, 260, 40), GPCommonLayoutScaleSizeWidthIndex)];
                
        [self addSubview:_viewRoundBack];
        [self addSubview:_labelState];
    }
    return self;
}

-(void)setState:(NSString *)state
{
    self.labelState.text = state;
}

@end
