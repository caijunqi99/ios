//
//  OrderListCollectionViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/28.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "OrderListCollectionViewCell.h"

@implementation OrderListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        //GPDebugLog(@"%s", __func__);
    }
    return self;
}

-(void)setOrderState_type:(NSString *)orderState_type
{
    _orderState_type = orderState_type;
    self.contentView.backgroundColor = [UIColor clearColor];
    if (!_contentVC) {
        _contentVC = [[OrderListContentViewController alloc]init];
        _contentVC.view.frame = self.bounds;
        _contentVC.orderState_type = orderState_type;
        [self addSubview:_contentVC.view];
    }
}

@end
