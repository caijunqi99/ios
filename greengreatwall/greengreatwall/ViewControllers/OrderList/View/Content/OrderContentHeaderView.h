//
//  OrderContentHeaderView.h
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/9.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderContentHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIView        *viewRoundBack;
@property (nonatomic, strong) UILabel       *labelStoreName;
@property (nonatomic, strong) UIImageView   *imageViewLeft;
-(void)setStore_name:(NSString *)store_name;
@end

NS_ASSUME_NONNULL_END
