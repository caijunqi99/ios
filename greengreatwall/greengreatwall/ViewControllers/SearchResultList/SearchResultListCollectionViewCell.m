//
//  SearchResultListCollectionViewCell.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/2.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "SearchResultListCollectionViewCell.h"

@implementation SearchResultListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //        //GPDebugLog(@"%s", __func__);
        
    }
    return self;
}

-(SearchResultListContentViewController *)contentVC
{
    if (!_contentVC) {
        _contentVC = [[SearchResultListContentViewController alloc]init];
        _contentVC.view.frame = self.bounds;
        [_contentVC.view setWidth:GPScreenWidth];
        [self addSubview:_contentVC.view];
    }
    return _contentVC;
}

-(void)setGc_id:(NSString *)gc_id andKeyword:(NSString *)keyword andOrderType:(Order_type)orderType
{
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentVC setGc_id:gc_id andKeyword:keyword andOrderType:orderType];
}

@end
