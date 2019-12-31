//
//  ConfirmOrderHeaderView.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/20.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShoppingCartModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOrderHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIView        *viewRoundBack;
@property (nonatomic, strong) UILabel       *labelStoreName;
@property (nonatomic, strong) UIImageView   *imageViewLeft;

@property (nonatomic, strong) StoreModel    *storeModel;
@end

NS_ASSUME_NONNULL_END
