//
//  AddressListViewController.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/16.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressListViewController : BaseViewController
typedef void (^AddOverBlock)(id obj);
- (instancetype)initWithBlock:(AddOverBlock)block;
@end

NS_ASSUME_NONNULL_END
