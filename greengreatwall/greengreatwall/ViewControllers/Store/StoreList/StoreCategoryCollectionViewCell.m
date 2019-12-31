//
//  StoreCategoryCollectionViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/21.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "StoreCategoryCollectionViewCell.h"
@implementation StoreCategoryCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        //GPDebugLog(@"%s", __func__);
    }
    return self;
}

-(void)setStoreCate_id:(NSString *)storeCate_id
{
    _storeCate_id = storeCate_id;
    self.contentView.backgroundColor = [UIColor clearColor];
    if (!_contentVC) {
        _contentVC = [[StoreCategoryContentViewController alloc]init];
        _contentVC.view.frame = self.bounds;
        _contentVC.storeCate_id = storeCate_id;
        [self addSubview:_contentVC.view];
    }
}

@end
