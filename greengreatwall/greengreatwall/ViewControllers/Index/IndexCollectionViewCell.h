//
//  IndexCollectionViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/19.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndexCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy)      NSDictionary    *dic;
@property (nonatomic,strong)    UIImageView     *imageViewLogo;
@property (nonatomic,strong)    UILabel         *labelTitle;
@property (nonatomic,strong)    UILabel         *labelPrice;
@property (nonatomic,strong)    UILabel         *labelPriceOrigin;
@end

NS_ASSUME_NONNULL_END
