//
//  ConfirmOrderTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/20.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOrderTableViewCell : UITableViewCell
@property (nonatomic, strong) GoodsModel *goodsModel;


@property (nonatomic,strong)    UIImageView     *imageViewLeft;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelTitle;
@property (nonatomic,strong)    UILabel         *labelPrice;
@property (nonatomic,strong)    UILabel         *labelCount;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelGoodsType;

@end

NS_ASSUME_NONNULL_END
