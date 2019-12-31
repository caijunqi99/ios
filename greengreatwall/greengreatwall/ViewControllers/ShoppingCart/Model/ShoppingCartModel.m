//
//  ShoppingCartModel.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/3.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ShoppingCartModel.h"

@implementation StoreModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.goodsArray = [NSMutableArray new];
    }
    return self;
}

- (void)setGoods:(NSMutableArray<GoodsModel *> *)goods {
    _goods = goods;
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary *dic in goods) {
        GoodsModel *model = [[GoodsModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [tempArray addObject:model];
    }
    self.goodsArray = [NSMutableArray arrayWithArray: tempArray];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end

@implementation GoodsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
