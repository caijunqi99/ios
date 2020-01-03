//
//  PointsTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/2.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PointsTableViewCell : UITableViewCell
@property (nonatomic,copy)      NSDictionary    *dic;
@property (nonatomic,strong)    UILabel         *labelTime;
@property (nonatomic,strong)    UILabel         *labelDescribe;
//@property (nonatomic,strong)    UILabel         *labellevel;
//@property (nonatomic,strong)    UILabel         *labeladdtime;
@end

NS_ASSUME_NONNULL_END
