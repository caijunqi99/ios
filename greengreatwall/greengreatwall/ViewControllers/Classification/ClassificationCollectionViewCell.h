//
//  ClassificationCollectionViewCell.h
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/1.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassificationContentViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassificationCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ClassificationContentViewController *contentVC;
@property (nonatomic, copy) NSString  *string_gc_id;

@end

NS_ASSUME_NONNULL_END
