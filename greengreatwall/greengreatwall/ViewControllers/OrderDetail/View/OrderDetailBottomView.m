//
//  OrderDetailBottomView.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/4.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "OrderDetailBottomView.h"

@implementation OrderDetailBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _arrayButton = [NSMutableArray array];
        
        [self setBackgroundColor:([UIColor whiteColor])];
        
        NSArray *arrbtnTitle = @[@"删除订单",@"确认收货",@"取消订单",@"去付款",@"查看物流"];
        
        for (NSInteger i = 0; i < arrbtnTitle.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:arrbtnTitle[i] forState:UIControlStateNormal];
            [btn.titleLabel setFont:FontRegularWithSize(12)];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setTag:i + 100];
            btn.layer.masksToBounds = YES;
            btn.clipsToBounds = YES;
            [btn.layer setCornerRadius:50.0*GPCommonLayoutScaleSizeWidthIndex];
            [btn.layer setBorderColor:[UIColor redColor].CGColor];
            [btn.layer setBorderWidth:1];
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btn setFrame:RectWithScale(CGRectMake(800 - (330 * i), 40, 300, 100), GPCommonLayoutScaleSizeWidthIndex)];
            [btn setHidden:YES];
            [_arrayButton addObject:btn];
        }
        _buttonDelete = _arrayButton[0];
        _buttonConfirm = _arrayButton[1];
        _buttonCancel = _arrayButton[2];
        _buttonToPay = _arrayButton[3];
        _buttonViewExpress = _arrayButton[4];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setStyle:(NSString *)style
{
    if ([style isEqualToString:@"未付款"]) {
        [_buttonCancel setFrame:RectWithScale(CGRectMake(800 , 40, 200, 100), GPCommonLayoutScaleSizeWidthIndex)];
//        [_buttonToPay setFrame:RectWithScale(CGRectMake(800, 40, 200, 100), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonToPay setHidden:YES];
        [_buttonCancel setHidden:NO];
        [_buttonDelete setHidden:YES];
        [_buttonConfirm setHidden:YES];
        [_buttonViewExpress setHidden:YES];
        
    }else if ([style isEqualToString:@"已付款"]){
    }else if ([style isEqualToString:@"已发货"]){
        
        [_buttonViewExpress setFrame:RectWithScale(CGRectMake(800 - 250, 40, 200, 100), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonConfirm setFrame:RectWithScale(CGRectMake(800, 40, 200, 100), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonToPay setHidden:YES];
        [_buttonCancel setHidden:YES];
        [_buttonDelete setHidden:YES];
        [_buttonConfirm setHidden:NO];
        [_buttonViewExpress setHidden:NO];
    }else if ([style isEqualToString:@"已收货"]){
        [_buttonViewExpress setFrame:RectWithScale(CGRectMake(800 - 250, 40, 200, 100), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonDelete setFrame:RectWithScale(CGRectMake(800, 40, 200, 100), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonToPay setHidden:YES];
        [_buttonCancel setHidden:YES];
        [_buttonDelete setHidden:NO];
        [_buttonConfirm setHidden:YES];
        [_buttonViewExpress setHidden:NO];
    }else if ([style isEqualToString:@"已取消"]){
        [_buttonDelete setFrame:RectWithScale(CGRectMake(800, 40, 200, 100), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonToPay setHidden:YES];
        [_buttonCancel setHidden:YES];
        [_buttonDelete setHidden:NO];
        [_buttonConfirm setHidden:YES];
        [_buttonViewExpress setHidden:YES];
    }
}

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
    
    if (self.btnClick) {
        self.btnClick(btn);
    }
    if ([buttonName containsString:@"日常保洁"])
    {
        
    }
    else if([buttonName containsString:@"深度保洁"])
    {
        
    }
}

@end
