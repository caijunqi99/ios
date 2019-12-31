//
//  StoreListViewController.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/20.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, StoreList_Type) {
    StoreListRecommend_Type = 1,
    StoreListCategory_Type = 2,
};

@interface StoreListViewController : BaseViewController

@end

NS_ASSUME_NONNULL_END
