//
//  OrderListSectionTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/9.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderListContentTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class OrderListSectionTableViewCell;
@protocol OrderListSectionTableViewCellDelegate <NSObject>
 
- (NSInteger)OrderListSectionTableViewCell:(OrderListContentTableViewCell *)cell numberOfRowsInSection:(NSInteger)section;
 
- (CGFloat)OrderListSectionTableViewCell:(OrderListContentTableViewCell *)cell heightForRowAtIndexPath:(NSIndexPath *)indexPath;
 
- (UITableViewCell *)OrderListSectionTableViewCell:(OrderListContentTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
 
@end
 
@interface OrderListSectionTableViewCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) void ((^btnClick)(UIButton*));

@property (nonatomic,copy)      NSDictionary    *dic;
 
@property (nonatomic,weak,nullable) id<OrderListSectionTableViewCellDelegate> delegate;
 
@property (nonatomic,assign) BOOL showSeparator;
 
@property (nonatomic,strong) UITableView *tableView;
 
@property (nonatomic,copy) NSInteger (^numberOfRowsInSection)(OrderListContentTableViewCell *plainCell,NSInteger section);
 
@property (nonatomic,copy) UITableViewCell * (^cellForRowAtIndexPath)(OrderListContentTableViewCell *plainCell,NSIndexPath *indexPath);
 
@property (nonatomic,copy) CGFloat (^heightForRowAtIndexPath)(OrderListContentTableViewCell *plainCell,NSIndexPath *indexPath);
 
@property (nonatomic,copy) void (^didSelectRowAtIndexPath)(OrderListContentTableViewCell *plainCell,NSIndexPath *indexPath);
 
- (void)deselectCell;
 
- (void)selectCell:(NSInteger)row;
 
@end

NS_ASSUME_NONNULL_END
