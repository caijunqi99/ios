//
//  StoreListCollectionViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/20.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreListViewController.h"
#import "StoreCategoryViewController.h"
#import "StoreRecommendViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface StoreListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) BaseViewController *contentVC;
@property (nonatomic, assign) StoreList_Type  storeListType;
@end

NS_ASSUME_NONNULL_END
