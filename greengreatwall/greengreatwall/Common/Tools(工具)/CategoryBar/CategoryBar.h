//
//  CategoryBar.h
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CategoryBarDelegate <NSObject>

@optional

- (void)itemDidSelectedWithIndex:(NSInteger)index;
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex;

@end

@interface CategoryBar : UIView

@property (nonatomic, weak)    id<CategoryBarDelegate>delegate;
@property (nonatomic, assign)   NSInteger   currentItemIndex;
@property (nonatomic, strong)   NSArray     *itemTitles;
@property (nonatomic, strong)   UIColor     *lineColor;
@property (nonatomic, strong)   UIColor     *titleColor;
@property (nonatomic, strong)   UIColor     *buttonColor;
@property (nonatomic, strong)   UIColor     *buttonColorSelected;
@property (nonatomic, strong)   UIFont      *font;
@property (nonatomic, strong)   UIColor     *titleColorSelected;
@property (nonatomic, strong)   UIFont      *fontSelected;
@property (nonatomic, assign)   CGFloat     buttonInset;
@property (nonatomic , strong)  NSMutableArray  *arrayButton;

@property (nonatomic )  BOOL  isVertical;
@property (nonatomic, assign)   CGFloat     buttonHeight;

@property (nonatomic )  BOOL  isSpread;
//@property (nonatomic, assign)   CGFloat     cellHeight;
- (id)initWithFrame:(CGRect)frame;
- (void)updateData;

@end

NS_ASSUME_NONNULL_END
