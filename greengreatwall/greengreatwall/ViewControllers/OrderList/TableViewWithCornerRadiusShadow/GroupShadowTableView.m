//
//  GroupShadowTableView.m
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import "GroupShadowTableView.h"
#import "PlainTableViewCell.h"



@interface GroupShadowTableView () <UITableViewDelegate,UITableViewDataSource>
 
@property (nonatomic,weak) PlainTableViewCell *selectedCell;
 
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
 
@end
 
@implementation GroupShadowTableView
 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUI];
    }
    return self;
}
 
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initializeUI];
    }
    return self;
}
 
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeUI];
    }
    return self;
}
 
-(void)initializeUI {
    [self registerClass:[PlainTableViewCell class] forCellReuseIdentifier:@"PlainTableViewCell"];
    self.delegate = self;
    self.dataSource = self;
}
 
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    PlainTableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    [cell.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:animated];
}
 
//MARK: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.numberOfSectionsInGroupShadowTableView) {
        return self.numberOfSectionsInGroupShadowTableView(self);
    }else if (self.groupShadowDataSource && [self.groupShadowDataSource respondsToSelector:@selector(numberOfSectionsInGroupShadowTableView:)]) {
        return [self.groupShadowDataSource numberOfSectionsInGroupShadowTableView:self];
    }
    return 0;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlainTableViewCell"];
    cell.showSeparator = self.showSeparator;
    cell.tableView.separatorInset = self.separatorInset;
    if (self.groupShadowDelegate && [self.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:canSelectAtSection:)]) {
        cell.tableView.allowsSelection = [self.groupShadowDelegate groupShadowTableView:self canSelectAtSection:indexPath.section];
    }else {
        cell.tableView.allowsSelection = self.allowsSelection;
    }
    cell.tag = indexPath.section + 100; //标记是第几组
    __weak typeof(self) weakSelf = self;
    [cell setNumberOfRowsInSection:^NSInteger(PlainTableViewCell *plainTableViewCell, NSInteger section) {
        if (weakSelf.numberOfRowsInSection) {
            return weakSelf.numberOfRowsInSection(weakSelf,section);
        }else if (weakSelf.groupShadowDataSource && [weakSelf.groupShadowDataSource respondsToSelector:@selector(groupShadowTableView:numberOfRowsInSection:)]) {
            return [weakSelf.groupShadowDataSource groupShadowTableView:weakSelf numberOfRowsInSection:section];
        }
        return 0;
    }];
     
    [cell setHeightForRowAtIndexPath:^CGFloat(PlainTableViewCell *plainTableViewCell, NSIndexPath *indexPath) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:plainTableViewCell.tag - 100];
        if (weakSelf.heightForRowAtIndexPath) {
            return  weakSelf.heightForRowAtIndexPath(weakSelf,newIndexPath);
        }else if (weakSelf.groupShadowDelegate && [weakSelf.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:heightForRowAtIndexPath:)]) {
            return [weakSelf.groupShadowDelegate groupShadowTableView:weakSelf heightForRowAtIndexPath:newIndexPath];
        }
        return 0;
    }];
     
    [cell setCellForRowAtIndexPath:^UITableViewCell *(PlainTableViewCell *plainTableViewCell, NSIndexPath *indexPath) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:plainTableViewCell.tag - 100];
        if (weakSelf.cellForRowAtIndexPath) {
            return  weakSelf.cellForRowAtIndexPath(weakSelf,newIndexPath);
        }else if (weakSelf.groupShadowDataSource && [weakSelf.groupShadowDataSource respondsToSelector:@selector(groupShadowTableView:cellForRowAtIndexPath:)]) {
            return [weakSelf.groupShadowDataSource groupShadowTableView:weakSelf cellForRowAtIndexPath:newIndexPath];
        }
        return nil;
    }];
     
    [cell setDidSelectRowAtIndexPath:^(PlainTableViewCell *plainTableViewCell, NSIndexPath *indexPath) {
         
        NSInteger actualSection = plainTableViewCell.tag - 100;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:actualSection];
        if (weakSelf.selectedCell && weakSelf.selectedCell != plainTableViewCell) {
            [weakSelf.selectedCell deselectCell];
        }
        if (weakSelf.didSelectRowAtIndexPath) {
            weakSelf.didSelectRowAtIndexPath(weakSelf,newIndexPath);
        }else if (weakSelf.groupShadowDelegate && [weakSelf.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:didSelectRowAtIndexPath:)]) {
            [weakSelf.groupShadowDelegate groupShadowTableView:weakSelf didSelectRowAtIndexPath:newIndexPath];
        }
        self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:actualSection];
        self.selectedCell = plainTableViewCell;
    }];
    return cell;
}
 
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    PlainTableViewCell *ptCell = (PlainTableViewCell *)cell;
    [ptCell.tableView reloadData];
    if (indexPath.section == self.selectedIndexPath.section) {
        [self.selectedCell selectCell:self.selectedIndexPath.row];
    }
}
 
//MARK: - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    NSInteger totalRows = 0;
    if (self.numberOfRowsInSection) {
        totalRows = self.numberOfRowsInSection(self,indexPath.section);
    }else if (self.groupShadowDataSource && [self.groupShadowDataSource respondsToSelector:@selector(groupShadowTableView:numberOfRowsInSection:)]) {
        totalRows = [self.groupShadowDataSource groupShadowTableView:self numberOfRowsInSection:indexPath.section];
    }
     
    CGFloat totalHeight = 0;
    for (int i = 0; i < totalRows; i ++) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        if (self.heightForRowAtIndexPath) {
            totalHeight += self.heightForRowAtIndexPath(self,newIndexPath);
        }else if (self.groupShadowDelegate && [self.groupShadowDelegate respondsToSelector:@selector(groupShadowTableView:heightForRowAtIndexPath:)]) {
            totalHeight += [self.groupShadowDelegate groupShadowTableView:self heightForRowAtIndexPath:newIndexPath];
        }
    }
    return totalHeight;
}
 
@end
 

