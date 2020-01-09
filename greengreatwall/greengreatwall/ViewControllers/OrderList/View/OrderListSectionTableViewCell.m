//
//  OrderListSectionTableViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/9.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "OrderListSectionTableViewCell.h"
#import "OrderListContentTableViewCell.h"
#import "OrderContentHeaderView.h"
#import "OrderDetailViewController.h"
@implementation OrderListSectionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectInset(self.bounds, 0, 0) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.tableView];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.tableView registerClass:[OrderListContentTableViewCell class] forCellReuseIdentifier:@"OrderListContentTableViewCell"];
        
    }
    return self;
}

-(void)buttonClick:(UIButton*)btn
{
    if (self.btnClick) {
        self.btnClick(btn);
    }
}

//MARK: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [NSArray arrayWithArray:_dic[@"order_list"]].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [NSArray arrayWithArray:_dic[@"order_list"][section][@"goods_list"]].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderListContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%f",@"OrderListContentTableViewCell",[[NSDate date] timeIntervalSince1970]]];
    if (cell == nil) {
        cell = [[OrderListContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@%f",@"OrderListContentTableViewCell",[[NSDate date] timeIntervalSince1970]]];
    }
    
    NSArray *arrayGoods = _dic[@"order_list"][indexPath.section][@"goods_list"];
    NSDictionary * dic = arrayGoods[indexPath.row];
    GoodsModel *model = [[GoodsModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    cell.goodsModel = model;
    cell.tag = indexPath.section + 200;
    return cell;
}

//MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListContentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.didSelectRowAtIndexPath) {
        self.didSelectRowAtIndexPath(cell,indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260*GPCommonLayoutScaleSizeWidthIndex;
}

#pragma mark    ----UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100*GPCommonLayoutScaleSizeWidthIndex;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //0:已取消10:未付款;20:已付款;30:已发货;40:已收货;
    NSDictionary *dicorder_state = [NSDictionary dictionaryWithObjectsAndKeys:@"已取消",@"0",@"未付款",@"10",@"已付款",@"20",@"已发货",@"30",@"已收货",@"40", nil];
    NSString *stringorder_state = [NSString stringWithFormat:@"%@",_dic[@"order_list"][section][@"order_state"]];
    NSString *state = [NSString stringWithFormat:@"%@",dicorder_state[stringorder_state]];
    
    if ([state isEqualToString:@"未付款"]||[state isEqualToString:@"已发货"]||[state isEqualToString:@"已收货"]||[state isEqualToString:@"已取消"]) {
        return 70*GPCommonLayoutScaleSizeWidthIndex;
    }
    return 0*GPCommonLayoutScaleSizeWidthIndex;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    OrderContentHeaderView *headerView = [[OrderContentHeaderView alloc]initWithFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [UIColor clearColor];
    
    NSString *store_name = _dic[@"order_list"][section][@"store_name"];
    [headerView setStore_name:store_name];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter = [[UIView alloc]init];
    [viewFooter setFrame:CGRectMake(0, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex)];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [viewFooter addSubview:view];
    [view setFrame:CGRectMake(0, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex)];
    
    NSString *stringorder_id = _dic[@"order_list"][section][@"order_id"];
    
    //0:已取消10:未付款;20:已付款;30:已发货;40:已收货;
    NSDictionary *dicorder_state = [NSDictionary dictionaryWithObjectsAndKeys:@"已取消",@"0",@"未付款",@"10",@"已付款",@"20",@"已发货",@"30",@"已收货",@"40", nil];
    NSString *stringorder_state = [NSString stringWithFormat:@"%@",_dic[@"order_list"][section][@"order_state"]];
    NSString *state = [NSString stringWithFormat:@"%@",dicorder_state[stringorder_state]];
    
    if ([state isEqualToString:@"未付款"]) {
        
        [viewFooter setFrame:CGRectMake(0, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 70*GPCommonLayoutScaleSizeWidthIndex)];
        [view setFrame:CGRectMake(0, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 70*GPCommonLayoutScaleSizeWidthIndex)];
        
        UIButton *_buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonCancel setFrame:RectWithScale(CGRectMake(750, 0, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonCancel setTitle:@"取消订单" forState:UIControlStateNormal];
        [_buttonCancel.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_buttonCancel setTag:[stringorder_id integerValue]+100];
        _buttonCancel.layer.masksToBounds = YES;
        _buttonCancel.clipsToBounds = YES;
        [_buttonCancel.layer setCornerRadius:15.0*GPCommonLayoutScaleSizeWidthIndex];
        [_buttonCancel.layer setBorderColor:[UIColor redColor].CGColor];
        [_buttonCancel.layer setBorderWidth:1];
        [_buttonCancel addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewFooter addSubview:_buttonCancel];
    }
    else if([state isEqualToString:@"已发货"])
    {
        UIButton *_buttonConfirmReceive = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonConfirmReceive setFrame:RectWithScale(CGRectMake(750, 0, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonConfirmReceive setTitle:@"确认收货" forState:UIControlStateNormal];
        [_buttonConfirmReceive.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonConfirmReceive setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_buttonConfirmReceive setTag:[stringorder_id integerValue]+100];
        _buttonConfirmReceive.layer.masksToBounds = YES;
        _buttonConfirmReceive.clipsToBounds = YES;
        [_buttonConfirmReceive.layer setCornerRadius:15.0*GPCommonLayoutScaleSizeWidthIndex];
        [_buttonConfirmReceive.layer setBorderColor:[UIColor redColor].CGColor];
        [_buttonConfirmReceive.layer setBorderWidth:1];
        [_buttonConfirmReceive addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewFooter addSubview:_buttonConfirmReceive];
    }
    else if([state isEqualToString:@"已收货"]||[state isEqualToString:@"已取消"])
    {
        UIButton *_buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonDelete setFrame:RectWithScale(CGRectMake(750, 0, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonDelete setTitle:@"删除订单" forState:UIControlStateNormal];
        [_buttonDelete.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [_buttonDelete setTag:section+100];
        [_buttonDelete setTag:[stringorder_id integerValue]+100];
        _buttonDelete.layer.masksToBounds = YES;
        _buttonDelete.clipsToBounds = YES;
        [_buttonDelete.layer setCornerRadius:15.0*GPCommonLayoutScaleSizeWidthIndex];
        [_buttonDelete.layer setBorderColor:[UIColor redColor].CGColor];
        [_buttonDelete.layer setBorderWidth:1];
        [_buttonDelete addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewFooter addSubview:_buttonDelete];
    }
    
    return viewFooter;
}

//- (void)deselectCell {
//    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
//}
//- (void)selectCell:(NSInteger)row {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//}

@end
