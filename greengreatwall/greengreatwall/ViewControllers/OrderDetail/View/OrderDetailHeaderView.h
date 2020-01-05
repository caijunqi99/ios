//
//  OrderDetailHeaderView.h
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/4.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIView        *viewRoundBack;
@property (nonatomic, strong) UILabel       *labelStoreName;
@property (nonatomic, strong) UILabel       *labelState;
@property (nonatomic, strong) UIImageView   *imageViewLeft;
-(void)setStore_name:(NSString *)store_name andState:(NSString *)state;
@end

NS_ASSUME_NONNULL_END
