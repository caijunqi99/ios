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
@property (nonatomic, strong) UILabel       *labelState;
-(void)setState:(NSString *)state;

@end

NS_ASSUME_NONNULL_END
