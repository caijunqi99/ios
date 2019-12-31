//
//  ShoppingCartHeaderView.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/3.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCartHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView        *viewRoundBack;
@property (nonatomic, strong) UIButton      *buttonSelect;
@property (nonatomic, strong) UILabel       *labelStoreName;
@property (nonatomic, strong) UIImageView   *imageViewLeft;

@property (nonatomic, strong) StoreModel    *storeModel;
@property (nonatomic, copy) void (^ClickBlock)(BOOL isClick);
@property (nonatomic, assign) BOOL          isClick;
@end

NS_ASSUME_NONNULL_END
