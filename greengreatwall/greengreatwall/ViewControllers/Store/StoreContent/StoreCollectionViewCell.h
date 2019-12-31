//
//  StoreCollectionViewCell.h
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/11.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreViewController.h"
#import "StoreGoodsListAllViewController.h"
#import "StoreGoodsIndexViewController.h"
NS_ASSUME_NONNULL_BEGIN
/**
 *！先设置store_id
 *再设置storeContentType
 *
 */
@interface StoreCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) BaseViewController *contentVC;
@property (nonatomic, assign) StoreContent_Type  storeContentType;
@property (nonatomic, copy) NSString  *store_id;
@end

NS_ASSUME_NONNULL_END
