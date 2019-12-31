//
//  TeamTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/30.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeamTableViewCell : UITableViewCell
@property (nonatomic,copy)      NSDictionary    *dic;
@property (nonatomic,strong)    UILabel         *labelMobile;
@property (nonatomic,strong)    UILabel         *labelexppoints;
@property (nonatomic,strong)    UILabel         *labellevel;
@property (nonatomic,strong)    UILabel         *labeladdtime;
@end

NS_ASSUME_NONNULL_END
