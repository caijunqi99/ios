//
//  ClassificationContentCollectionViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/22.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassificationContentCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy)      NSDictionary    *dic;
@property (nonatomic,strong)    UIImageView     *imageViewLogo;
@property (nonatomic,strong)    UILabel         *labelTitle;
@end

NS_ASSUME_NONNULL_END
