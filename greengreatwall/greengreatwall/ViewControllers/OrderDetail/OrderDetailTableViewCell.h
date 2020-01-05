//
//  OrderDetailTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/4.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailTableViewCell : UITableViewCell
@property (nonatomic,copy)      NSDictionary    *dic;
@property (nonatomic, strong) GoodsModel *goodsModel;

@property (nonatomic,strong)    UIImageView     *imageViewLeft;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelTitle;
@property (nonatomic,strong)    UILabel         *labelPrice;
@property (nonatomic,strong)    UILabel         *labelCount;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelGoodsType;
@end

NS_ASSUME_NONNULL_END
