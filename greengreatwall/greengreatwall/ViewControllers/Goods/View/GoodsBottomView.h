//
//  GoodsBottomView.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/4.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsBottomView : UIView


@property (nonatomic, strong) UIButton *buttonToStore;
@property (nonatomic, strong) UIButton *buttonToCall;
@property (nonatomic, strong) UIButton *buttonToShoppingCart;
@property (nonatomic, strong) UIButton *buttonPutInShoppingCart;
@property (nonatomic, strong) UIButton *buttonPurchase;

@property (nonatomic, copy) void (^ToStoreBlock)(void);
@property (nonatomic, copy) void (^ToCallBlock)(void);
@property (nonatomic, copy) void (^ToShoppingCartBlock)(void);
@property (nonatomic, copy) void (^PutInShoppingCartBlock)(void);
@property (nonatomic, copy) void (^PurchaseBlock)(void);


-(instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
