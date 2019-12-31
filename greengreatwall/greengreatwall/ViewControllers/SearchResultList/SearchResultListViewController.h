//
//  SearchResultListViewController.h
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/10/24.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, Order_type) {
    Order_Complex = 1,
    Order_Sales = 2,
    Order_Price = 3,
};

@interface SearchResultListViewController : BaseViewController
@property (nonatomic, copy) NSString  *keyword;
@property (nonatomic, copy) NSString  *gc_id;
@end

NS_ASSUME_NONNULL_END
