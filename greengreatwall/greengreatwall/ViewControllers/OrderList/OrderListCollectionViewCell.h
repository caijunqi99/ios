//
//  OrderListCollectionViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/28.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListContentViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) OrderListContentViewController *contentVC;
@property (nonatomic, copy) NSString  *orderState_type;
@end

NS_ASSUME_NONNULL_END
