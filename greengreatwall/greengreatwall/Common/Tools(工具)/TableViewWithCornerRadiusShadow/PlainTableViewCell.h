//
//  PlainTableViewCell.h
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PlainTableViewCell;
@protocol PlainTableViewCellDelegate <NSObject>
 
- (NSInteger)plainTableViewCell:(PlainTableViewCell *)cell numberOfRowsInSection:(NSInteger)section;
 
- (CGFloat)plainTableViewCell:(PlainTableViewCell *)cell heightForRowAtIndexPath:(NSIndexPath *)indexPath;
 
- (UITableViewCell *)plainTableViewCell:(PlainTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
 
@end
 
@interface PlainTableViewCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate>
 
@property (nonatomic,weak,nullable) id<PlainTableViewCellDelegate> delegate;
 
@property (nonatomic,assign) BOOL showSeparator;
 
@property (nonatomic,strong) UITableView *tableView;
 
@property (nonatomic,copy) NSInteger (^numberOfRowsInSection)(PlainTableViewCell *plainCell,NSInteger section);
 
@property (nonatomic,copy) UITableViewCell * (^cellForRowAtIndexPath)(PlainTableViewCell *plainCell,NSIndexPath *indexPath);
 
@property (nonatomic,copy) CGFloat (^heightForRowAtIndexPath)(PlainTableViewCell *plainCell,NSIndexPath *indexPath);
 
@property (nonatomic,copy) void (^didSelectRowAtIndexPath)(PlainTableViewCell *plainCell,NSIndexPath *indexPath);
 
- (void)deselectCell;
 
- (void)selectCell:(NSInteger)row;
 
@end

NS_ASSUME_NONNULL_END
