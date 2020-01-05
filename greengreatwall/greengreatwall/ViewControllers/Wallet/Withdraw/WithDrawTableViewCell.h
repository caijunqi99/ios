//
//  WithDrawTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/5.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithDrawTableViewCell : UITableViewCell
@property (nonatomic,copy)      NSDictionary    *dic;
@property (nonatomic,strong)    UIView          *viewBack;
@property (nonatomic,strong)    UILabel         *labelTitle;
@property (nonatomic,strong)    UILabel         *labelTime;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelContent;


@end

NS_ASSUME_NONNULL_END
