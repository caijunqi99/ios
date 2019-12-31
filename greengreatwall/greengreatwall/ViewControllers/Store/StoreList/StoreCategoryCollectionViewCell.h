//
//  StoreCategoryCollectionViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/21.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreCategoryContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreCategoryCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) StoreCategoryContentViewController *contentVC;
@property (nonatomic, copy) NSString  *storeCate_id;
@end

NS_ASSUME_NONNULL_END
