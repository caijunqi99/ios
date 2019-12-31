//
//  ShoppingCartTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/3.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCartTableViewCell : UITableViewCell

@property (nonatomic, strong) GoodsModel *goodsModel;

@property (nonatomic, copy) void (^ClickRowBlock)(BOOL isClick);
@property (nonatomic, copy) void (^AddBlock)(UILabel *labelCount);
@property (nonatomic, copy) void (^CutBlock)(UILabel *labelCount);

@property (nonatomic,strong)    UIButton        *buttonSelect;


@property (nonatomic,strong)    UIImageView     *imageViewLeft;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelTitle;
@property (nonatomic,strong)    UILabel         *labelPrice;
@property (nonatomic,strong)    UILabel         *labelCount;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelGoodsType;

@property (nonatomic,strong)    UIButton        *buttonAdd;
@property (nonatomic,strong)    UIButton        *buttonCut;
@end

NS_ASSUME_NONNULL_END
