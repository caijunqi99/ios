//
//  StoreViewController.h
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/11.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, StoreContent_Type) {
    StoreContentIndex_Type = 1,
    StoreContentAll_Type = 2,
};
NS_ASSUME_NONNULL_BEGIN

@interface StoreViewController : BaseViewController
@property (nonatomic, copy) NSString  *store_id;
@end

NS_ASSUME_NONNULL_END
