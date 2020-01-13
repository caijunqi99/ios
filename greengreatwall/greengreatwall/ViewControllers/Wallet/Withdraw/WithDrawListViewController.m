//
//  WithDrawListViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/5.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "WithDrawListViewController.h"


#import "WithDrawTableViewCell.h"
@interface WithDrawListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIView               *_viewTemp;
    
    UILabel              *_labelPhoneIntro;
    UILabel              *_labelShipping_codeIntro;
    
    UILabel              *_labelPhone;
    UILabel              *_labelShipping_code;
    
    UITableView          *_tableViewTemp;
    
    NSMutableDictionary *_cellDic;
    NSMutableArray      *_arrayDataSource;
    
    NSString            *_strParameter;
    NSString            *_string_express_code;
    NSString            *_string_shipping_code;
    NSString            *_string_phone;
}



@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation WithDrawListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    [self headerRereshing];
}

-(instancetype)init
{
    if (self = [super init]) {
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
    self.navigationController.navigationBar.hidden = NO;
    _labelPhone.text = _string_phone;
    _labelShipping_code.text = _string_shipping_code;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)configInterface
{
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    [self settingNavTitle:@"提现申请列表"];
    viewSetBackgroundColor(kColorBasic);
    
    
    _viewTemp = [UIView initViewBackColor:[UIColor whiteColor]];
    //    [self.view addSubview:_viewTemp];
    [_viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, 300*GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelPhoneIntro = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor grayColor] title:@"收货人电话:"];
    _labelPhoneIntro.lineBreakMode = LineBreakModeDefault;
    _labelPhoneIntro.backgroundColor = [UIColor clearColor];
    [_viewTemp addSubview:_labelPhoneIntro];
    [_labelPhoneIntro setFrame:RectWithScale(CGRectMake(50, 50, 200, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelShipping_codeIntro = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor grayColor] title:@"物流号:"];
    _labelShipping_codeIntro.lineBreakMode = LineBreakModeDefault;
    _labelShipping_codeIntro.backgroundColor = [UIColor clearColor];
    [_viewTemp addSubview:_labelShipping_codeIntro];
    [_labelShipping_codeIntro setFrame:RectWithScale(CGRectMake(50, 150, 200, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelPhone = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor grayColor] title:@""];
    _labelPhone.lineBreakMode = LineBreakModeDefault;
    _labelPhone.backgroundColor = [UIColor clearColor];
    [_viewTemp addSubview:_labelPhone];
    [_labelPhone setFrame:RectWithScale(CGRectMake(300, 50, 700, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelShipping_code = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor grayColor] title:@""];
    _labelShipping_code.lineBreakMode = LineBreakModeDefault;
    _labelShipping_code.backgroundColor = [UIColor clearColor];
    [_viewTemp addSubview:_labelShipping_code];
    [_labelShipping_code setFrame:RectWithScale(CGRectMake(300, 150, 700, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    
    _tableViewTemp = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight) style:UITableViewStylePlain];
    _tableViewTemp.showsVerticalScrollIndicator = NO;
    _tableViewTemp.showsHorizontalScrollIndicator = NO;
    _tableViewTemp.dataSource = self;
    _tableViewTemp.delegate = self;
    
    _tableViewTemp.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableViewTemp];
    //    _tableViewTemp.tableHeaderView = _viewTemp;
    
    [self setupRefreshWithScrollView:_tableViewTemp];
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    
}

-(void)setExpress_code:(NSString *)express_code Shipping_code:(NSString *)shipping_code Phone:(NSString *)phone
{
    _string_express_code = express_code;
    _string_shipping_code = shipping_code;
    _string_phone = phone;
}

-(void)netRequest
{
    [HPNetManager POSTWithUrlString:HostMemberorderget_express isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_string_express_code,@"express_code",_string_shipping_code,@"shipping_code",_string_phone,@"phone", nil]  successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 200) {
            //            self->_arrayDataSource = [NSMutableArray arrayWithArray:response[@"result"][@"goods_image"]];
            
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
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
    [_tableViewTemp reloadData];
    
    _strParameter = @"1";
    [HPNetManager POSTWithUrlString:Hostmemberfundpdcashlist isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",@"10",@"pagesize",_strParameter,@"page", nil] successBlock:^(id response) {
        //        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"list"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"list"]]];
                [self->_tableViewTemp reloadData];
                [self->_tableViewTemp.mj_header endRefreshing];
                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
            }
            else
            {
                [self->_tableViewTemp.mj_header endRefreshing];
            }
        }
        else
        {
            [self->_tableViewTemp.mj_header endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_tableViewTemp.mj_header endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

//上拉加载更多
- (void)footerRereshing
{
    [HPNetManager POSTWithUrlString:Hostmemberfundpdcashlist isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",@"10",@"pagesize",_strParameter,@"page", nil] successBlock:^(id response) {
        //        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"list"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"list"]]];
                [self->_tableViewTemp reloadData];
                [self->_tableViewTemp.mj_footer endRefreshing];
                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
            }
            else
            {
                [self->_tableViewTemp.mj_footer endRefreshing];
            }
        }
        else
        {
            [self->_tableViewTemp.mj_footer endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_tableViewTemp.mj_footer endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - scrollViewDelegate
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

/** 手指滑动CollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_tableViewTemp]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

/** 手指点击smallScrollView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    //    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    //GPDebugLog(@"ScrollIndex:%ld",(long)index);
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
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithDrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentify];
    if(!cell){
        cell = [[WithDrawTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentify];
    }
    NSDictionary * dic = _arrayDataSource[indexPath.row];
    cell.dic = dic;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    GoodsViewController *vc = [[GoodsViewController alloc]init];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    vc.goods_id = _arrayDataSource[indexPath.row][@"goods_id"];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - lazy load懒加载

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
