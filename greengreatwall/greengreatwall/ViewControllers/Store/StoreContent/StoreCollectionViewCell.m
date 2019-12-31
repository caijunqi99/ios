//
//  StoreCollectionViewCell.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/11.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "StoreCollectionViewCell.h"

@implementation StoreCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        //GPDebugLog(@"%s", __func__);
    }
    return self;
}

-(void)setStoreContentType:(StoreContent_Type)storeContentType
{
    _storeContentType = storeContentType;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    switch (storeContentType) {
        case StoreContentIndex_Type:
            {
                if (!_contentVC) {
                    _contentVC = [[StoreGoodsIndexViewController alloc]init];
                    _contentVC.view.frame = self.bounds;
                    ((StoreGoodsIndexViewController*)_contentVC).store_id = _store_id;
                    [self addSubview:_contentVC.view];
                }
            }
            break;
        case StoreContentAll_Type:
            {
                if (!_contentVC) {
                    _contentVC = [[StoreGoodsListAllViewController alloc]init];
                    _contentVC.view.frame = self.bounds;
                    ((StoreGoodsListAllViewController*)_contentVC).store_id = _store_id;
                    [self addSubview:_contentVC.view];
                }
            }
            break;
            
        default:
            break;
    }
}

-(void)setStore_id:(NSString *)store_id
{
    _store_id = store_id;
    if (_storeContentType) {
        switch (_storeContentType) {
            case StoreContentIndex_Type:
                {
                    if (!_contentVC) {
                        _contentVC = [[StoreGoodsIndexViewController alloc]init];
                        _contentVC.view.frame = self.bounds;
                        ((StoreGoodsIndexViewController*)_contentVC).store_id = _store_id;
                        [self addSubview:_contentVC.view];
                    }
                    else
                    {
                        ((StoreGoodsIndexViewController*)_contentVC).store_id = _store_id;
                    }
                }
                break;
            case StoreContentAll_Type:
                {
                    if (!_contentVC) {
                        _contentVC = [[StoreGoodsListAllViewController alloc]init];
                        _contentVC.view.frame = self.bounds;
                        ((StoreGoodsListAllViewController*)_contentVC).store_id = _store_id;
                        [self addSubview:_contentVC.view];
                    }
                    else
                    {
                        ((StoreGoodsListAllViewController*)_contentVC).store_id = _store_id;
                    }
                }
                break;
                
            default:
                break;
        }
    }
}

@end
