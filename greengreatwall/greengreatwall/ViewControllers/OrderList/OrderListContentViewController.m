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

#import "OrderDetailViewController.h"

#import "GroupShadowTableView.h"
#import "OrderListSectionTableViewCell.h"

@interface OrderListContentViewController ()<UITableViewDelegate,UITableViewDataSource>//,GroupShadowTableViewDelegate,GroupShadowTableViewDataSource
{
    UITableView         *_tableView;
    
    NSMutableArray      *_arrayDataSource;
    
    NSString            *_strParameter;
}
//@property (strong, nonatomic)  GroupShadowTableView *tableView;
@property (nonatomic,weak) OrderListContentTableViewCell *selectedCell;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@end
static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation OrderListContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
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
//    [self headerRereshing];
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
    viewSetBackgroundColor([UIColor groupTableViewBackgroundColor]);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(50*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex , GPScreenHeight - kNavBarAndStatusBarHeight - 30) style:(UITableViewStyleGrouped)];//UITableViewStyleGrouped
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[OrderListSectionTableViewCell class] forCellReuseIdentifier:@"OrderListSectionTableViewCell"];
    
    [self setupRefreshWithScrollView:_tableView];
    
    CGFloat _viewh = 20*GPCommonLayoutScaleSizeWidthIndex;
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
    [HPNetManager POSTWithUrlString:HostMemberorderorder_list isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",@"5",@"pagesize",_strParameter,@"page",_orderState_type,@"state_type", nil] successBlock:^(id response) {
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
    [HPNetManager POSTWithUrlString:HostMemberorderorder_list isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",@"5",@"pagesize",_strParameter,@"page",_orderState_type,@"state_type", nil] successBlock:^(id response) {
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
    _orderState_type = orderState_type;
    [self headerRereshing];
}

-(void)buttonClickToPay:(UIButton*)btn
{
    NSInteger section = btn.tag - 100;
    NSString *pay_sn = _arrayDataSource[section][@"pay_sn"];
    
    ConfirmOrderToPayViewController *vc = [[ConfirmOrderToPayViewController alloc]init];
    vc.string_pay_sn = pay_sn;
    [self.navigationController pushViewController:vc animated:YES];
}

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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%@",@"OrderListSectionTableViewCell",_orderState_type]];
    if (cell == nil) {
        cell = [[OrderListSectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@%@",@"OrderListSectionTableViewCell",_orderState_type]];
    }
    cell.dic = _arrayDataSource[indexPath.section];

    HPWeak;
    [cell setDidSelectRowAtIndexPath:^(OrderListContentTableViewCell *SectionTableViewCell, NSIndexPath *indexPath1) {
        NSInteger section = indexPath.section;
        NSInteger row = SectionTableViewCell.tag - 200;
        
        GPDebugLog(@"indexPath.sec:%ld    ,indexPath.row:%ld",(long)section,(long)row);
        
        OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.string_order_id = self->_arrayDataSource[section][@"order_list"][row][@"order_id"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
    cell.btnClick = ^(UIButton * btn) {
        NSString *stringorder_id = [NSString stringWithFormat:@"%d",(btn.tag -100)];
        
        if ([btn.titleLabel.text isEqualToString:@"取消订单"]) {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"确认取消此订单?" callbackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self dealWithOrderByType:@"order_cancel" andOrderID:stringorder_id];
                }else if (btnIndex == 0) {
                    
                }
            } cancelButtonTitle:@"容我三思" destructiveButtonTitle:@"我意已决" otherButtonTitles:nil];
        }else if ([btn.titleLabel.text isEqualToString:@"确认收货"]){
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"确认收货?" callbackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self dealWithOrderByType:@"order_receive" andOrderID:stringorder_id];
                }else if (btnIndex == 0) {
                    
                }
            } cancelButtonTitle:@"容我三思" destructiveButtonTitle:@"我意已决" otherButtonTitles:nil];
        }else if ([btn.titleLabel.text isEqualToString:@"删除订单"]){
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"确认删除此订单?" callbackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self dealWithOrderByType:@"order_delete" andOrderID:stringorder_id];
                }else if (btnIndex == 0) {
                    
                }
            } cancelButtonTitle:@"容我三思" destructiveButtonTitle:@"我意已决" otherButtonTitles:nil];
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //0:已取消10:未付款;20:已付款;30:已发货;40:已收货;
    NSDictionary *dicorder_state = [NSDictionary dictionaryWithObjectsAndKeys:@"已取消",@"0",@"未付款",@"10",@"已付款",@"20",@"已发货",@"30",@"已收货",@"40", nil];
    
    CGFloat totalHeight = 0;
    NSDictionary *dic = _arrayDataSource[indexPath.section];
    
    
    
    for (NSDictionary *dicOrderList in dic[@"order_list"]) {
        totalHeight += 100*GPCommonLayoutScaleSizeWidthIndex;
        
        totalHeight += 260*GPCommonLayoutScaleSizeWidthIndex*[NSArray arrayWithArray:dicOrderList[@"goods_list"]].count;
        
        NSString *stringorder_state = [NSString stringWithFormat:@"%@",dicOrderList[@"order_state"]];
        
        NSString *state = [NSString stringWithFormat:@"%@",dicorder_state[stringorder_state]];
        if ([state isEqualToString:@"未付款"]||[state isEqualToString:@"已发货"]||[state isEqualToString:@"已收货"]||[state isEqualToString:@"已取消"]) {
            totalHeight += 70*GPCommonLayoutScaleSizeWidthIndex;
            continue;
        }
    }
    return totalHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListSectionTableViewCell *ptCell = (OrderListSectionTableViewCell *)cell;
    [ptCell.tableView reloadData];
    [ptCell.tableView layoutIfNeeded];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100*GPCommonLayoutScaleSizeWidthIndex;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    //0:已取消10:未付款;20:已付款;30:已发货;40:已收货;
    NSDictionary *dicorder_state = [NSDictionary dictionaryWithObjectsAndKeys:@"已取消",@"0",@"未付款",@"10",@"已付款",@"20",@"已发货",@"30",@"已收货",@"40", nil];
    NSString *stringorder_state = [NSString stringWithFormat:@"%@",_arrayDataSource[section][@"order_state"]];
    NSString *state = [NSString stringWithFormat:@"%@",dicorder_state[stringorder_state]];
    if ([state isEqualToString:@"未付款"]) {
        return 170*GPCommonLayoutScaleSizeWidthIndex;
    }
    return 100*GPCommonLayoutScaleSizeWidthIndex;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    OrderListHeaderView *headerView = [[OrderListHeaderView alloc]initWithFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSString *state = _arrayDataSource[section][@"state_desc"];
    [headerView setState:state];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter = [[UIView alloc]init];
    
    
    //0:已取消10:未付款;20:已付款;30:已发货;40:已收货;
    NSDictionary *dicorder_state = [NSDictionary dictionaryWithObjectsAndKeys:@"已取消",@"0",@"未付款",@"10",@"已付款",@"20",@"已发货",@"30",@"已收货",@"40", nil];
    NSString *stringorder_state = [NSString stringWithFormat:@"%@",_arrayDataSource[section][@"order_state"]];
    NSString *state = [NSString stringWithFormat:@"%@",dicorder_state[stringorder_state]];
    
    if ([state isEqualToString:@"未付款"]) {
        [viewFooter setFrame:CGRectMake(0, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 170*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [viewFooter addSubview:view];
        [view setFrame:CGRectMake(0, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 140*GPCommonLayoutScaleSizeWidthIndex)];
        [view rounded:10 rectCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)];
        NSString *stringAmount = _arrayDataSource[section][@"order_amount"];
        UILabel *labelAmount = [[UILabel alloc]init];
        [labelAmount setText:[NSString stringWithFormat:@"订单总价:%@",stringAmount]];
        [labelAmount setFrame:RectWithScale(CGRectMake(200, 0, 750, 60), GPCommonLayoutScaleSizeWidthIndex)];
        [labelAmount setTextAlignment:NSTextAlignmentRight];
        [viewFooter addSubview:labelAmount];
        [labelAmount setFont:FontMediumWithSize(12)];
        
        
        
        UIButton *_buttonToPay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonToPay setFrame:RectWithScale(CGRectMake(750, 70, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
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
    }else{
        [viewFooter setFrame:CGRectMake(0, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [viewFooter addSubview:view];
        [view setFrame:CGRectMake(0, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 70*GPCommonLayoutScaleSizeWidthIndex)];
        [view rounded:10 rectCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)];
        NSString *stringAmount = _arrayDataSource[section][@"order_amount"];
        UILabel *labelAmount = [[UILabel alloc]init];
        [labelAmount setText:[NSString stringWithFormat:@"订单总价:%@",stringAmount]];
        [labelAmount setFrame:RectWithScale(CGRectMake(200, 0, 750, 60), GPCommonLayoutScaleSizeWidthIndex)];
        [labelAmount setTextAlignment:NSTextAlignmentRight];
        [viewFooter addSubview:labelAmount];
        [labelAmount setFont:FontMediumWithSize(12)];
    }
    return viewFooter;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.string_order_id = _arrayDataSource[indexPath.section][@"order_list"][indexPath.row][@"order_id"];
//    [getCurrentViewController().navigationController pushViewController:vc animated:YES];
}

@end
