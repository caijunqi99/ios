//
//  SearchResultListContentViewController.h
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/2.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchResultListViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchResultListContentViewController : BaseViewController
-(void)setGc_id:(NSString *)gc_id andKeyword:(NSString *)keyword andOrderType:(Order_type)orderType;
@end

NS_ASSUME_NONNULL_END