//
//  ClassificationContentCollectionHeader.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/25.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassificationContentCollectionHeader : UICollectionReusableView
@property (nonatomic,copy)      NSString        *stringTitle;
@property (nonatomic,strong)    UILabel         *labelTitle;
@end

NS_ASSUME_NONNULL_END
