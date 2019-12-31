//
//  PlainTableViewCell.m
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import "PlainTableViewCell.h"
#import "UIView+Add.h"


//MARK: - PlainTableViewCell
@implementation PlainTableViewCell
 
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
         
        self.tableView = [[UITableView alloc]initWithFrame:CGRectInset(self.bounds, 15, 0) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.tableView];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
         
    }
    return self;
}
 
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.tableView setCornerRadius:8 withShadow:YES withOpacity:0.6];
}
 
//MARK: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.numberOfRowsInSection) {
        return self.numberOfRowsInSection(self,self.tag-100);
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(plainTableViewCell:numberOfRowsInSection:)]) {
            return  [self.delegate plainTableViewCell:self numberOfRowsInSection:self.tag -100];
        }
    }
    return 0;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (self.cellForRowAtIndexPath) {
        cell = self.cellForRowAtIndexPath(self,indexPath);
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(plainTableViewCell:cellForRowAtIndexPath:)]) {
            cell = [self.delegate plainTableViewCell:self cellForRowAtIndexPath:indexPath];
        }
    }
    NSAssert(cell, @"Cell不能为空");
    return cell;
}
 
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
     
    CGFloat cornerRadius = 8.f;
    cell.backgroundColor = UIColor.clearColor;
     
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = cell.bounds;
     
    NSInteger numberOfRows = 0;
    if (self.numberOfRowsInSection) {
        numberOfRows = self.numberOfRowsInSection(self,self.tag -100);
    }
     
    BOOL needSeparator = NO;
     
    if (indexPath.row == 0 && numberOfRows == 1) {
        CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    }else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
         
        needSeparator = YES;
         
    } else if (indexPath.row == numberOfRows -1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        CGPathAddRect(pathRef, nil, bounds);
        needSeparator = YES;
    }
     
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    CFRelease(pathRef);
    layer.fillColor = [UIColor whiteColor].CGColor;
     
    if (self.showSeparator && needSeparator) {
        CALayer *lineLayer = [[CALayer alloc] init];
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        lineLayer.frame = CGRectMake(self.separatorInset.left, bounds.size.height - lineHeight, bounds.size.width - (self.separatorInset.left + self.separatorInset.right), lineHeight);
        lineLayer.backgroundColor = self.tableView.separatorColor.CGColor;
        [layer addSublayer:lineLayer];
    }
     
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = roundView;
     
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    backgroundLayer.fillColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer below:cell.layer];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
}
 
//MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectRowAtIndexPath) {
        self.didSelectRowAtIndexPath(self,indexPath);
    }
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.heightForRowAtIndexPath) {
        return self.heightForRowAtIndexPath(self,indexPath);
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(plainTableViewCell:heightForRowAtIndexPath:)]) {
            return  [self.delegate plainTableViewCell:self heightForRowAtIndexPath:indexPath];
        }
    }
    return 0;
}
 
- (void)deselectCell {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
}
 
- (void)selectCell:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
 
@end
