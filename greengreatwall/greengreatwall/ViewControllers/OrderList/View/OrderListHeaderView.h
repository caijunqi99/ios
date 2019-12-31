//
//  OrderListHeaderView.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/29.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderListHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIView        *viewRoundBack;
@property (nonatomic, strong) UILabel       *labelStoreName;
@property (nonatomic, strong) UILabel       *labelState;
@property (nonatomic, strong) UIImageView   *imageViewLeft;
//@property (nonatomic, strong) NSString      *store_name;
-(void)setStore_name:(NSString *)store_name andState:(NSString *)state;
//@property (nonatomic, strong) StoreModel    *storeModel;
@end

NS_ASSUME_NONNULL_END
