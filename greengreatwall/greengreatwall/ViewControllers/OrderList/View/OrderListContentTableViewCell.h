//
//  OrderListContentTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/28.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderListContentTableViewCell : UITableViewCell
@property (nonatomic, strong) void ((^btnClick)(UIButton*));

@property (nonatomic,copy)      NSDictionary    *dic;

@property (nonatomic,strong)    UIButton        *buttonToPay;
@property (nonatomic,strong)    UIButton        *buttonConfirmReceipt;
@property (nonatomic,strong)    UIButton        *buttonCancelOrder;
@property (nonatomic,strong)    CALayer         *shadowLayer;


@property (nonatomic, strong) GoodsModel *goodsModel;


@property (nonatomic,strong)    UIImageView     *imageViewLeft;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelTitle;
@property (nonatomic,strong)    UILabel         *labelPrice;
@property (nonatomic,strong)    UILabel         *labelCount;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelGoodsType;

@end

NS_ASSUME_NONNULL_END
