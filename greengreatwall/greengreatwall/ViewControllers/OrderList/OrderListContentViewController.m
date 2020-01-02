//
//  OrderListContentViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/28.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "OrderListContentViewController.h"

#import "OrderListContentTableViewCell.h"
#import "OrderListHeaderView.h"
#import "ConfirmOrderToPayViewController.h"
@interface OrderListContentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView         *_tableView;
    
    NSMutableArray      *_arrayDataSource;
    
    NSString            *_strParameter;
}

@end
static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation OrderListContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    //        [self footerRereshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)init
{
    self = [super init];
    if (self)
    {
        _arrayDataSource = [[NSMutableArray alloc]initWithCapacity:0];
        _strParameter = @"1";
        HPNOTIF_ADD(@"orderPaySuccess", headerRereshing);
        HPNOTIF_ADD(@"orderPayCancel", headerRereshing);

    }
    return self;
}

-(void)dealloc
{
    HPNOTIF_REMV();
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)configInterface
{
    viewSetBackgroundColor(kColorBasic);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(50*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex , GPScreenHeight - kNavBarAndStatusBarHeight - 30) style:(UITableViewStyleGrouped)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[OrderListContentTableViewCell class] forCellReuseIdentifier:@"OrderListContentTableViewCell"];
    
    [self setupRefreshWithScrollView:_tableView];
    
    CGFloat _viewh = 20;
    //设置滚动范围偏移200
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    //设置内容范围偏移200
    _tableView.contentInset = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    
    [_tableView setContentOffset:CGPointMake(0, -_viewh)];
    
}

- (void)setupRefreshWithScrollView:(UIScrollView *)scrollView
{
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    // Set title
    [header setTitle:@"下拉加载最新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [header setLastUpdatedTimeText:^NSString *(NSDate *lastUpdatedTime) {
        NSDate *lastTime = lastUpdatedTime;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        NSInteger hour = [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:lastTime];
        if (hour >12) {
            fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss 下午";
        }else{
            fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss 上午";
        }
        NSString *timeStr = [fmt stringFromDate:lastTime];
        return timeStr;
    }];
    
    // Set font
    header.stateLabel.font = FontRegularWithSize(15);
    header.lastUpdatedTimeLabel.font = FontRegularWithSize(14);
    
    // Set textColor
    header.stateLabel.textColor = kColorFontRegular;
    header.lastUpdatedTimeLabel.textColor = kColorFontRegular;
    
    //头部刷新控件
    scrollView.mj_header = header;
    
    CGFloat _viewh = 0;
    scrollView.mj_header.ignoredScrollViewContentInsetTop = _viewh + kScrollViewHeaderIgnored;
    
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    // Set title
    [footer setTitle:@"点击或上拉加载更多数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
    // Set font
    footer.stateLabel.font = FontRegularWithSize(17);
    
    // Set textColor
    footer.stateLabel.textColor = kColorFontRegular;
    
    //尾部刷新控件
    scrollView.mj_footer = footer;
    scrollView.mj_footer.ignoredScrollViewContentInsetBottom = kScrollViewFooterIgnored;
}



//下拉刷新
- (void)headerRereshing
{
    [_arrayDataSource removeAllObjects];
    [_tableView reloadData];
    
    _strParameter = @"1";
    [HPNetManager POSTWithUrlString:HostMemberorderorder_list isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",@"5",@"pagesize",_strParameter,@"page",_strParameter,@"page",_orderState_type,@"state_type", nil] successBlock:^(id response) {
        //        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"order_group_list"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"order_group_list"]]];
                [self->_tableView reloadData];
                [self->_tableView.mj_header endRefreshing];
                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
            }
            else
            {
                [self->_tableView.mj_header endRefreshing];
            }
        }
        else
        {
            [self->_tableView.mj_header endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_tableView.mj_header endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

//上拉加载更多
- (void)footerRereshing
{
    [HPNetManager POSTWithUrlString:HostMemberorderorder_list isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",@"5",@"pagesize",_strParameter,@"page",_strParameter,@"page",_orderState_type,@"state_type", nil] successBlock:^(id response) {
        //        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"order_group_list"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"order_group_list"]]];
                [self->_tableView reloadData];
                [self->_tableView.mj_footer endRefreshing];
                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
            }
            else
            {
                [self->_tableView.mj_footer endRefreshing];
            }
        }
        else
        {
            [self->_tableView.mj_footer endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_tableView.mj_footer endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

-(void)leftClick
{
    
}

-(void)rightClick
{
    
}

-(void)orderPaySuccess
{
    
}

-(void)setOrderState_type:(NSString *)orderState_type
{
    if (_orderState_type != orderState_type) {
        _orderState_type = orderState_type;
        [self headerRereshing];
    }
}

-(void)buttonClickToPay:(UIButton*)btn
{
    NSInteger section = btn.tag - 100;
    NSString *pay_sn = _arrayDataSource[section][@"pay_sn"];
    
    ConfirmOrderToPayViewController *vc = [[ConfirmOrderToPayViewController alloc]init];
    vc.string_pay_sn = pay_sn;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
*修改订单状态 - 取消订单 删除订单 确认收货
*https://shop.bayi-shop.com/mobile/memberorder/change_state
*order_id     订单ID
*state_type
*order_cancel ：取消订单
order_delete  ：删除订单
order_receive  : 确认收货
*key           token值
*state_info    取消原因，由用户填写，可以为空
*state_info1   取消原因，由用户选择，可以为空
*/
-(void)buttonClickCancel:(UIButton*)btn
{
    [HPAlertTools showAlertWith:self title:@"提示信息" message:@"确认取消此订单?" callbackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            NSInteger section = btn.tag - 100;
            NSString *order_id = self->_arrayDataSource[section][@"order_list"][0][@"order_id"];
            [self dealWithOrderByType:@"order_cancel" andOrderID:order_id];
        }else if (btnIndex == 0) {
            
        }
    } cancelButtonTitle:@"容我三思" destructiveButtonTitle:@"我意已决" otherButtonTitles:nil];
}

-(void)buttonClickConfirmReceive:(UIButton*)btn
{
    [HPAlertTools showAlertWith:self title:@"提示信息" message:@"确认收货?" callbackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            NSInteger section = btn.tag - 100;
            NSString *order_id = self->_arrayDataSource[section][@"order_list"][0][@"order_id"];
            [self dealWithOrderByType:@"order_receive" andOrderID:order_id];
        }else if (btnIndex == 0) {
            
        }
    } cancelButtonTitle:@"容我三思" destructiveButtonTitle:@"我意已决" otherButtonTitles:nil];
}

-(void)buttonClickDelete:(UIButton*)btn
{
    [HPAlertTools showAlertWith:self title:@"提示信息" message:@"确认删除此订单?" callbackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            NSInteger section = btn.tag - 100;
            NSString *order_id = self->_arrayDataSource[section][@"order_list"][0][@"order_id"];
            [self dealWithOrderByType:@"order_delete" andOrderID:order_id];
        }else if (btnIndex == 0) {
            
        }
    } cancelButtonTitle:@"容我三思" destructiveButtonTitle:@"我意已决" otherButtonTitles:nil];
}

- (void)dealWithOrderByType:(NSString *)state_type andOrderID:(NSString *)order_id
{
    [HPNetManager POSTWithUrlString:Hostmemberorderchange_state isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",order_id,@"order_id",state_type,@"state_type", nil] successBlock:^(id response) {
        //        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            [self headerRereshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}



#pragma mark    ----UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arrayDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arrayGoods = _arrayDataSource[section][@"order_list"][0][@"extend_order_goods"];
    return arrayGoods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListContentTableViewCell"];
    //    StoreModel *storeModel = self.storeArray[indexPath.section];
    //    GoodsModel *goodsModel = storeModel.goodsArray[indexPath.row];
    //    cell.goodsModel = goodsModel;
    NSArray *arrayGoods = _arrayDataSource[indexPath.section][@"order_list"][0][@"extend_order_goods"];
    NSDictionary * dic = arrayGoods[indexPath.row];
    GoodsModel *model = [[GoodsModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    cell.goodsModel = model;
    cell.dic = dic;
    cell.btnClick = ^(UIButton *btn) {
        //GPDebugLog(@"indexPath.row:%ld",(long)indexPath.row);
        //GPDebugLog(@"btn.tag:%ld",(long)btn.tag);
        //        EditDeliveryAddressViewController *vc = [[EditDeliveryAddressViewController alloc]init];
        //        vc.hidesBottomBarWhenPushed = YES;
        //        vc.addressModel = model;
        //        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260*GPCommonLayoutScaleSizeWidthIndex;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100*GPCommonLayoutScaleSizeWidthIndex;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    if (section == ([self.storeArray count]-1)) {
    //        return 200*GPCommonLayoutScaleSizeWidthIndex;
    //    }
    NSString *state = _arrayDataSource[section][@"order_list"][0][@"state_desc"];
    
    if ([state isEqualToString:@"待付款"]) {
        return 130*GPCommonLayoutScaleSizeWidthIndex;
    }
    return 100*GPCommonLayoutScaleSizeWidthIndex;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    OrderListHeaderView *headerView = [[OrderListHeaderView alloc]initWithFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    //    StoreModel *storeModel = self.storeArray[section];
    //    headerView.storeModel = storeModel;
    
    NSString *store_name = _arrayDataSource[section][@"order_list"][0][@"store_name"];
    NSString *state = _arrayDataSource[section][@"order_list"][0][@"state_desc"];
    [headerView setStore_name:store_name andState:state];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter = [[UIView alloc]init];
    [viewFooter setFrame:CGRectMake(0, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 80*GPCommonLayoutScaleSizeWidthIndex)];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [viewFooter addSubview:view];
    [view setFrame:CGRectMake(0, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 80*GPCommonLayoutScaleSizeWidthIndex)];
    [view rounded:10 rectCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)];
    
    
    NSString *state = _arrayDataSource[section][@"order_list"][0][@"state_desc"];
    
    if ([state isEqualToString:@"待付款"]) {
        UIButton *_buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonCancel setFrame:RectWithScale(CGRectMake(500, 0, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonCancel setTitle:@"取消订单" forState:UIControlStateNormal];
        [_buttonCancel.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_buttonCancel setTag:section+100];
        _buttonCancel.layer.masksToBounds = YES;
        _buttonCancel.clipsToBounds = YES;
        [_buttonCancel.layer setCornerRadius:15.0*GPCommonLayoutScaleSizeWidthIndex];
        [_buttonCancel.layer setBorderColor:[UIColor redColor].CGColor];
        [_buttonCancel.layer setBorderWidth:1];
        [_buttonCancel addTarget:self action:@selector(buttonClickCancel:) forControlEvents:UIControlEventTouchUpInside];
        [viewFooter addSubview:_buttonCancel];
        
        UIButton *_buttonToPay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonToPay setFrame:RectWithScale(CGRectMake(750, 0, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonToPay setTitle:@"去付款" forState:UIControlStateNormal];
        [_buttonToPay.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonToPay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_buttonToPay setTag:section+100];
        _buttonToPay.layer.masksToBounds = YES;
        _buttonToPay.clipsToBounds = YES;
        [_buttonToPay.layer setCornerRadius:15.0*GPCommonLayoutScaleSizeWidthIndex];
        [_buttonToPay.layer setBorderColor:[UIColor redColor].CGColor];
        [_buttonToPay.layer setBorderWidth:1];
        [_buttonToPay addTarget:self action:@selector(buttonClickToPay:) forControlEvents:UIControlEventTouchUpInside];
        [viewFooter addSubview:_buttonToPay];
    }
    else if([state isEqualToString:@"待收货"])
    {
        UIButton *_buttonConfirmReceive = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonConfirmReceive setFrame:RectWithScale(CGRectMake(750, 0, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonConfirmReceive setTitle:@"确认收货" forState:UIControlStateNormal];
        [_buttonConfirmReceive.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonConfirmReceive setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_buttonConfirmReceive setTag:section+100];
        _buttonConfirmReceive.layer.masksToBounds = YES;
        _buttonConfirmReceive.clipsToBounds = YES;
        [_buttonConfirmReceive.layer setCornerRadius:15.0*GPCommonLayoutScaleSizeWidthIndex];
        [_buttonConfirmReceive.layer setBorderColor:[UIColor redColor].CGColor];
        [_buttonConfirmReceive.layer setBorderWidth:1];
        [_buttonConfirmReceive addTarget:self action:@selector(buttonClickConfirmReceive:) forControlEvents:UIControlEventTouchUpInside];
        [viewFooter addSubview:_buttonConfirmReceive];
    }
    else if([state isEqualToString:@"交易完成"]||[state isEqualToString:@"已取消"])
    {
        UIButton *_buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonDelete setFrame:RectWithScale(CGRectMake(750, 0, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonDelete setTitle:@"删除订单" forState:UIControlStateNormal];
        [_buttonDelete.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_buttonDelete setTag:section+100];
        _buttonDelete.layer.masksToBounds = YES;
        _buttonDelete.clipsToBounds = YES;
        [_buttonDelete.layer setCornerRadius:15.0*GPCommonLayoutScaleSizeWidthIndex];
        [_buttonDelete.layer setBorderColor:[UIColor redColor].CGColor];
        [_buttonDelete.layer setBorderWidth:1];
        [_buttonDelete addTarget:self action:@selector(buttonClickDelete:) forControlEvents:UIControlEventTouchUpInside];
        [viewFooter addSubview:_buttonDelete];
    }
//    else if([state isEqualToString:@"已取消"])
//    {
//        UIButton *_buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_buttonDelete setFrame:RectWithScale(CGRectMake(750, 0, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
//        [_buttonDelete setTitle:@"删除订单" forState:UIControlStateNormal];
//        [_buttonDelete.titleLabel setFont:FontRegularWithSize(12)];
//        [_buttonDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [_buttonDelete setTag:section+100];
//        _buttonDelete.layer.masksToBounds = YES;
//        _buttonDelete.clipsToBounds = YES;
//        [_buttonDelete.layer setCornerRadius:15.0*GPCommonLayoutScaleSizeWidthIndex];
//        [_buttonDelete.layer setBorderColor:[UIColor redColor].CGColor];
//        [_buttonDelete.layer setBorderWidth:1];
//        [_buttonDelete addTarget:self action:@selector(buttonClickDelete:) forControlEvents:UIControlEventTouchUpInside];
//        [viewFooter addSubview:_buttonDelete];
//    }


    return viewFooter;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayGoods = _arrayDataSource[indexPath.section][@"order_list"][0][@"extend_order_goods"];
    NSDictionary * dic = arrayGoods[indexPath.row];
    GoodsModel *goodsModel = [[GoodsModel alloc] init];
    [goodsModel setValuesForKeysWithDictionary:dic];
    
    
    GoodsViewController *vc = [[GoodsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goods_id = goodsModel.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
