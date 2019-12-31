//
//  NoticeViewController.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/12.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView         *_tableView;
    
    NSMutableArray      *_arrayDataSource;
    NSString            *_strParameter;
}

@end

@implementation NoticeViewController

static NSString * const ReuseIdentify = @"ReuseIdentify";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    [self headerRereshing];
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
        _arrayDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

-(void)dealloc
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
    [self settingNavTitle:@"通知消息" WithNavTitleColor:[UIColor blackColor]];
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    viewSetBackgroundColor(kColorBasic);
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth,  GPScreenHeight - kNavBarAndStatusBarHeight) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [self setupRefreshWithScrollView:_tableView];
    [self.view addSubview:_tableView];
    
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{

}



-(void)refresh
{
    [_arrayDataSource removeAllObjects];
    [_tableView reloadData];
    [self footerRereshing];
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
    
    [HPNetManager POSTWithUrlString:HostMembermessagesystemmsg isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page",[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
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
    } failureBlock:^(NSError *error) {
        [self->_tableView.mj_header endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

//上拉加载更多
- (void)footerRereshing
{
    [HPNetManager POSTWithUrlString:HostMembermessagesystemmsg isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page",[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
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
    } failureBlock:^(NSError *error) {
        [self->_tableView.mj_footer endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//
//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel * label = [[UILabel alloc] init];
//    label.frame = CGRectMake((tableView.width-141)/2.0, 10, 141, 24);
//    label.backgroundColor = GPHexColor(0xDDDDDD);
//    label.font = FontRegularWithSize(12);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.text = [NSString stringWithFormat:@"2019-10-29 11:08:32"];
//    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 44)];
//    [sectionView setBackgroundColor:kColorBasic];
//    [sectionView addSubview:label];
//    return sectionView;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_arrayDataSource count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentify ];
    if(!cell){
        cell = [[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentify];
    }
    NSDictionary * dic = _arrayDataSource[indexPath.section];
    cell.dic = dic;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentify];
    
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
