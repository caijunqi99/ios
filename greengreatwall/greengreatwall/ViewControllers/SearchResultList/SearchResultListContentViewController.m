//
//  SearchResultListContentViewController.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/2.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "SearchResultListContentViewController.h"
#import "SearchResultListViewController.h"
#import "SearchResultListTableViewCell.h"
#import "GoodsViewController.h"
@interface SearchResultListContentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView              *_viewTop;
    UIView              *_viewBusiness;
    UIButton            *_button[10];
    UITableView         *_tableView;
    
    NSMutableArray      *_arrayDataSourceComplex;
    NSMutableArray      *_arrayDataSourceSales;
    NSMutableArray      *_arrayDataSourcePrice;
    NSMutableArray      *_arrayDataSource;
    
    
    NSString            *_strParameter;
}
@property (nonatomic, copy) NSString  *keyword;
@property (nonatomic, copy) NSString  *gc_id;
@property (nonatomic, assign) Order_type  orderType;
@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

static NSString * const OrderUnpaidReuseIdentify = @"OrderUnpaidReuseIdentify";
static NSString * const OrderToAppraiseReuseIdentify = @"OrderToAppraiseReuseIdentify";
static NSString * const OrderProcessingReuseIdentify = @"OrderProcessingReuseIdentify";

static NSString * const OrderReuseIdentify = @"OrderReuseIdentify";

@implementation SearchResultListContentViewController

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
        _strParameter = @"1";
        
        _arrayDataSource = [[NSMutableArray alloc]initWithCapacity:0];
        
        _arrayDataSourceComplex = [[NSMutableArray alloc]initWithCapacity:0];
        
        _arrayDataSourceSales = [[NSMutableArray alloc]initWithCapacity:0];
        
        _arrayDataSourcePrice = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

-(void)dealloc
{
    
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
    
    _tableView = [[UITableView alloc]init];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [self setupRefreshWithScrollView:_tableView];
    [self.view addSubview:_tableView];
    [_tableView setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight - 44)];
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
    _strParameter = @"1";
    [_arrayDataSource removeAllObjects];
    [_arrayDataSourceComplex removeAllObjects];
    [_arrayDataSourceSales removeAllObjects];
    [_arrayDataSourcePrice removeAllObjects];
    [_tableView reloadData];
    
    
    //在这里上拉加载更多，将加载的数据拼接在数据源后面就可以了。
    //利用延时函数模拟网络加载
    NSString *stringType = @"";
    switch (_orderType) {
        case Order_Complex:
        {
            stringType = @"0";
        }
            break;
            
        case Order_Sales:
        {
            stringType = @"3";
        }
            break;
            
        case Order_Price:
        {
            stringType = @"2";
        }
            break;
            
        default:
            break;
    }
    
    
    [HPNetManager POSTWithUrlString:Hostgoodsgoods_list isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page",StringNullOrNot(_keyword),@"keyword",StringNullOrNot(_gc_id),@"gc_id",StringNullOrNot(stringType),@"key", nil] successBlock:^(id response) {
        //        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"goods_list"]] count]) {
                
                switch (self->_orderType) {
                    case Order_Complex:
                    {
                        [self->_arrayDataSourceComplex addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"goods_list"]]];
                        self->_arrayDataSource = self->_arrayDataSourceComplex;
                    }
                        break;
                        
                    case Order_Sales:
                    {
                        [self->_arrayDataSourceSales addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"goods_list"]]];
                        self->_arrayDataSource = self->_arrayDataSourceSales;
                    }
                        break;
                        
                    case Order_Price:
                    {
                        [self->_arrayDataSourcePrice addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"goods_list"]]];
                        self->_arrayDataSource = self->_arrayDataSourcePrice;
                    }
                        break;
                        
                    default:
                        break;
                }
                
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
    //在这里上拉加载更多，将加载的数据拼接在数据源后面就可以了。
    //利用延时函数模拟网络加载
    NSString *stringType = @"";
    switch (_orderType) {
        case Order_Complex:
        {
            stringType = @"0";
        }
            break;
            
        case Order_Sales:
        {
            stringType = @"3";
        }
            break;
            
        case Order_Price:
        {
            stringType = @"2";
        }
            break;
            
        default:
            break;
    }
    
    
    [HPNetManager POSTWithUrlString:Hostgoodsgoods_list isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page",StringNullOrNot(_keyword),@"keyword",StringNullOrNot(_gc_id),@"gc_id",StringNullOrNot(stringType),@"key", nil] successBlock:^(id response) {
        //        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"goods_list"]] count]) {
                
                switch (self->_orderType) {
                    case Order_Complex:
                    {
                        [self->_arrayDataSourceComplex addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"goods_list"]]];
                        self->_arrayDataSource = self->_arrayDataSourceComplex;
                    }
                        break;
                        
                    case Order_Sales:
                    {
                        [self->_arrayDataSourceSales addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"goods_list"]]];
                        self->_arrayDataSource = self->_arrayDataSourceSales;
                    }
                        break;
                        
                    case Order_Price:
                    {
                        [self->_arrayDataSourcePrice addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"goods_list"]]];
                        self->_arrayDataSource = self->_arrayDataSourcePrice;
                    }
                        break;
                        
                    default:
                        break;
                }
                
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

-(void)refresh
{
    _strParameter = @"1";
    [_arrayDataSource removeAllObjects];
    [_arrayDataSourceComplex removeAllObjects];
    [_arrayDataSourceSales removeAllObjects];
    [_arrayDataSourcePrice removeAllObjects];
    [_tableView reloadData];
    
    [self footerRereshing];
}

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
    
    if ([buttonName containsString:@"日常保洁"])
    {
        
    }
    else if([buttonName containsString:@"深度保洁"])
    {
        
    }
}

-(void)setGc_id:(NSString *)gc_id andKeyword:(NSString *)keyword andOrderType:(Order_type)orderType
{
    _orderType = orderType;
    _gc_id = gc_id;
    _keyword = keyword;
    [self headerRereshing];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360.0*GPCommonLayoutScaleSizeWidthIndex;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderUnpaidReuseIdentify];
    if(!cell){
        cell = [[SearchResultListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderUnpaidReuseIdentify];
    }
    NSDictionary * dic = _arrayDataSource[indexPath.row];
    cell.dic = dic;
    cell.btnClick = ^(UIButton*btn){
        //GPDebugLog(@"indexPath.row:%ld",(long)indexPath.row);
        //GPDebugLog(@"btn.tag:%ld",btn.tag);
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsViewController *vc = [[GoodsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goods_id = _arrayDataSource[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
