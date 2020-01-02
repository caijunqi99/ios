//
//  StoreRecommendViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/20.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "StoreRecommendViewController.h"
#import "StoreListTableViewCell.h"
#import "StoreViewController.h"
@interface StoreRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView         *_tableView;
    
    NSMutableArray      *_arrayDataSource;
    
    NSString            *_strParameter;
}
@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation StoreRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    [self footerRereshing];
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
    [_tableView setFrame:CGRectMake(0, 0, GPScreenWidth , GPScreenHeight - kStatusBarHeight - kTabBarHeight - 70)];
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
    [HPNetManager GETWithUrlString:HostStorelistindex isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page",@"0",@"cate_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"]]];
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
    [HPNetManager GETWithUrlString:HostStorelistindex isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page",@"0",@"cate_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"]]];
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
    [_arrayDataSource removeAllObjects];
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
    return GPScreenWidth*(275.0/540.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentify];
    if (!cell) {
        cell = [[StoreListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentify];
    }
    cell.btnClick = ^(UIButton*btn){
        GPDebugLog(@"indexPath.row:%ld",(long)indexPath.row);
        GPDebugLog(@"btn.tag:%ld",(long)btn.tag);
        
        GoodsViewController *vc = [[GoodsViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.goods_id = self->_arrayDataSource[indexPath.row][@"search_list_goods"][btn.tag-1][@"goods_id"];
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.dic = _arrayDataSource[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreViewController *vc = [[StoreViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.store_id = _arrayDataSource[indexPath.row][@"store_id"];
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
