//
//  NoticeTableViewCell.h
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/12.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTableViewCell : UITableViewCell

@property (nonatomic,copy)      NSDictionary    *dic;
@property (nonatomic,strong)    UIView          *viewBack;
@property (nonatomic,strong)    UILabel         *labelTitle;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelContent;

@property (nonatomic,strong)    UILabel         *labelTime;

@end

NS_ASSUME_NONNULL_END
