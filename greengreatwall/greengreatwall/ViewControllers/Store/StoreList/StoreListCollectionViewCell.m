//
//  StoreListCollectionViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/20.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "StoreListCollectionViewCell.h"

@implementation StoreListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        //GPDebugLog(@"%s", __func__);
    }
    return self;
}

-(void)setStoreListType:(StoreList_Type)storeListType
{
    _storeListType = storeListType;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    switch (storeListType) {
        case StoreListRecommend_Type:
            {
                if (!_contentVC) {
                    _contentVC = [[StoreRecommendViewController alloc]init];
                    _contentVC.view.frame = self.bounds;
                    [self addSubview:_contentVC.view];
                }
            }
            break;
        case StoreListCategory_Type:
            {
                if (!_contentVC) {
                    _contentVC = [[StoreCategoryViewController alloc]init];
                    _contentVC.view.frame = self.bounds;
                    [self addSubview:_contentVC.view];
                }
            }
            break;
            
        default:
            break;
    }
}

@end
