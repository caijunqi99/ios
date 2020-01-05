//
//  WalletViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/25.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "WalletViewController.h"

#import "RechargeViewController.h"

#import "WithdrawViewController.h"
#import "PointTransformViewController.h"
#import "FundpredepositViewController.h"
#import "TransationViewController.h"
#import "PointsViewController.h"


#import "VerifiedViewController.h"
#import "TeamViewController.h"

#import "CollegeTableViewCell.h"
#import "CollegeContentViewController.h"
@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CategoryBarDelegate>
{
    UIView                  *_viewTemp;
    
    UIView                  *_viewShadowUserLv;
    UIView                  *_viewShadowCompany;
    UITableView             *_tableViewTemp;
    UIScrollView            *_scrollViewTemp;
    
    CategoryBar             *_categoryBarTemp;
    
    UILabel                 *_labelTemp[11];
    UIImageView             *_imageViewTemp[4];
    
    UIButton                *_buttonFunc[11];
    UILabel                 *_labelFunc[11];
    
    NSMutableArray          *_arrayButtonTitle;
    NSMutableArray          *_arrayButtonImageName;
    
    NSMutableDictionary     *_cellDic;
    NSMutableArray          *_arrayDataSource;
    
    NSString                *_strParameter;
    NSString                *_stringInviterlink;
}


@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation WalletViewController

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
        _arrayButtonTitle = [[NSMutableArray alloc]initWithObjects:@"充值",@"提现",@"互转",@"储值卡",@"交易码",@"积分",@"实名",@"团队",@"邀请好友", nil];//@"提现",@"互转",@"储值卡",@"交易码",@"积分",           @"商学院",@"视频",
        _arrayButtonImageName = [[NSMutableArray alloc]initWithObjects:@"充值钱包",@"提现钱包",@"互转钱包",@"储值卡",@"交易码",@"积分钱包",@"实名",@"团队钱包",@"邀请好友钱包", nil];//@"提现",@"互转",@"储值卡",@"交易码",@"积分",           @"商学院",@"视频",
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

- (void)configInterface
{
    
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    [self settingNavTitle:@"我的钱包"];
    viewSetBackgroundColor(kColorBasic);
    
    _viewTemp = [UIView initViewBackColor:[UIColor whiteColor]];
    [self.view addSubview:_viewTemp];
    [_viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, 1200*GPCommonLayoutScaleSizeWidthIndex)];
    
    _viewShadowUserLv = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewTemp addSubview:_viewShadowUserLv];
    [_viewShadowUserLv setFrame:RectWithScale(CGRectMake(480, 40, 240, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewShadowUserLv rounded:25*GPCommonLayoutScaleSizeWidthIndex];
    [_viewShadowUserLv shadow:[UIColor blackColor] opacity:1 radius:10 offset:CGSizeMake(0, 0)];
    
    
    _viewShadowCompany = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewTemp addSubview:_viewShadowCompany];
    [_viewShadowCompany setFrame:RectWithScale(CGRectMake(740, 40, 300, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewShadowCompany rounded:25*GPCommonLayoutScaleSizeWidthIndex];
    [_viewShadowCompany shadow:[UIColor blackColor] opacity:1 radius:10 offset:CGSizeMake(0, 0)];
    
    _imageViewTemp[0] = [[UIImageView alloc]initWithImage:defaultImage];
    [_viewTemp addSubview:_imageViewTemp[0]];
    [_imageViewTemp[0] setFrame:RectWithScale(CGRectMake(40, 40, 100, 100),GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[0] rounded:42*GPCommonLayoutScaleSizeWidthIndex];
    
    _imageViewTemp[1] = [[UIImageView alloc]initWithImage:GetImage(@"会员(2)")];
    [_viewShadowUserLv addSubview:_imageViewTemp[1]];
    [_imageViewTemp[1] setFrame:RectWithScale(CGRectMake(20, 10, 33, 27),GPCommonLayoutScaleSizeWidthIndex)];
    
    _imageViewTemp[2] = [[UIImageView alloc]initWithImage:GetImage(@"公司")];
    [_viewShadowCompany addSubview:_imageViewTemp[2]];
    [_imageViewTemp[2] setFrame:RectWithScale(CGRectMake(20, 10, 30, 30),GPCommonLayoutScaleSizeWidthIndex)];
    
    _imageViewTemp[3] = [[UIImageView alloc]initWithImage:GetImage(@"钱包背景图")];
    [_viewTemp addSubview:_imageViewTemp[3]];
    [_imageViewTemp[3] setFrame:RectWithScale(CGRectMake(40, 180, 1000, 378),GPCommonLayoutScaleSizeWidthIndex)];//1976 748
    
    
    NSArray *arrayLabelText = @[@"昵称",@"(推荐码:)",@"手机号",@"用户级别",@"公司级别",@"储值卡余额",@"可用积分",@"冻结积分",
                                @"储值卡(元)",@"可用积分",@"冻结积分"];
    for (NSInteger i = 0; i<11; i++) {
        
        _labelTemp[i] = [UILabel initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:arrayLabelText[i]];
        _labelTemp[i].lineBreakMode = NSLineBreakByCharWrapping;
        _labelTemp[i].backgroundColor = [UIColor clearColor];
    }
    
    [_labelTemp[0] setFrame:RectWithScale(CGRectMake(160, 40, 300, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[0]];
    [_labelTemp[0] setTextColor:[UIColor blackColor]];
    _labelTemp[0].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[1] setFrame:RectWithScale(CGRectMake(500, 90, 440, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[1]];
    [_labelTemp[1] setTextColor:[UIColor blackColor]];
    _labelTemp[1].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[2] setFrame:RectWithScale(CGRectMake(160, 90, 300, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[2]];
    [_labelTemp[2] setTextColor:[UIColor blackColor]];
    _labelTemp[2].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[3] setFrame:RectWithScale(CGRectMake(70, 0, 120, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewShadowUserLv addSubview:_labelTemp[3]];
    [_labelTemp[3] setTextColor:[UIColor blackColor]];
    _labelTemp[3].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[4] setFrame:RectWithScale(CGRectMake(70, 0, 200, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewShadowCompany addSubview:_labelTemp[4]];
    [_labelTemp[4] setTextColor:[UIColor blackColor]];
    _labelTemp[4].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[5] setFrame:RectWithScale(CGRectMake(40, 100, 900, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[3] addSubview:_labelTemp[5]];
    [_labelTemp[5] setTextColor:[UIColor whiteColor]];
    _labelTemp[5].textAlignment = NSTextAlignmentLeft;
    [_labelTemp[5] setFont:FontRegularWithSize(18)];
    
    [_labelTemp[6] setFrame:RectWithScale(CGRectMake(220, 240, 200, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[3] addSubview:_labelTemp[6]];
    [_labelTemp[6] setTextColor:rgb(99, 234, 208)];
    _labelTemp[6].textAlignment = NSTextAlignmentLeft;
    [_labelTemp[6] setFont:FontRegularWithSize(14)];
    
    [_labelTemp[7] setFrame:RectWithScale(CGRectMake(740, 240, 200, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[3] addSubview:_labelTemp[7]];
    [_labelTemp[7] setTextColor:rgb(99, 234, 208)];
    _labelTemp[7].textAlignment = NSTextAlignmentLeft;
    [_labelTemp[7] setFont:FontRegularWithSize(14)];
    
    
    
    [_labelTemp[8] setFrame:RectWithScale(CGRectMake(40, 55, 160, 30), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[3] addSubview:_labelTemp[8]];
    [_labelTemp[8] setTextColor:rgb(99, 234, 208)];
    _labelTemp[8].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[9] setFrame:RectWithScale(CGRectMake(40, 250, 160, 30), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[3] addSubview:_labelTemp[9]];
    [_labelTemp[9] setTextColor:rgb(99, 234, 208)];
    _labelTemp[9].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[10] setFrame:RectWithScale(CGRectMake(540, 250, 160, 30), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[3] addSubview:_labelTemp[10]];
    [_labelTemp[10] setTextColor:rgb(99, 234, 208)];
    _labelTemp[10].textAlignment = NSTextAlignmentLeft;
    
    
    for (NSInteger i = 0; i<_arrayButtonTitle.count; i++)
    {
        _buttonFunc[i]=[UIButton buttonWithType:UIButtonTypeCustom];
        _buttonFunc[i].frame=RectWithScale(CGRectMake(140-10+340*(i%3), 610+195*(i/3), 95+20,95+20), GPCommonLayoutScaleSizeWidthIndex);
        [_buttonFunc[i] setImage:GetImage([_arrayButtonImageName objectAtIndex:i]) forState:UIControlStateNormal];
        [_buttonFunc[i] setTitle:[_arrayButtonTitle objectAtIndex:i] forState:UIControlStateNormal];
        [_buttonFunc[i] setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_buttonFunc[i] setTag:i];
        [_buttonFunc[i] addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewTemp addSubview:_buttonFunc[i]];
        
        _labelFunc[i]=[[UILabel alloc]init];
        _labelFunc[i].frame = RectWithScale(CGRectMake(100-10+340*(i%3), 740+195*(i/3), 175+20,40), GPCommonLayoutScaleSizeWidthIndex);
        _labelFunc[i].text = [_arrayButtonTitle objectAtIndex:i];
        _labelFunc[i].textColor = kColorFontMedium;
        _labelFunc[i].textAlignment = NSTextAlignmentCenter;
        _labelFunc[i].font = FontRegularWithSize(14);
        [_viewTemp addSubview:_labelFunc[i]];
    }
    
    
    
    _tableViewTemp = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight) style:UITableViewStylePlain];
    _tableViewTemp.showsVerticalScrollIndicator = NO;
    _tableViewTemp.showsHorizontalScrollIndicator = NO;
    _tableViewTemp.dataSource = self;
    _tableViewTemp.delegate = self;
    _tableViewTemp.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableViewTemp];
    _tableViewTemp.tableHeaderView = _viewTemp;
    
    [self setupRefreshWithScrollView:_tableViewTemp];
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    
}

-(void)netRequest
{
    [HPNetManager POSTWithUrlString:Hostmemberwallet isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 200) {
            //            self->_arrayDataSource = [NSMutableArray arrayWithArray:response[@"result"][@"goods_image"]];
            [self updateInterfaceWithDic:response[@"result"]];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

-(void)updateInterfaceWithDic:(NSDictionary*)dic
{
    NSDictionary *dicMemberInfo = dic[@"member_info"];
    
    _stringInviterlink = dicMemberInfo[@"inviter_code"];
    
    NSString *stringusername = dicMemberInfo[@"user_name"];
    _labelTemp[0].text = stringusername;
    
    NSString *stringinviter_code = dicMemberInfo[@"inviter_code"];
    _labelTemp[1].text = [NSString stringWithFormat:@"推荐码:%@",stringinviter_code];
    
    NSString *stringmobile = dicMemberInfo[@"mobile"];
    _labelTemp[2].text = stringmobile;
    
    NSString *stringlevel_name = dicMemberInfo[@"level_name"];
    _labelTemp[3].text = stringlevel_name;
    
    if ([[dicMemberInfo allKeys]containsObject:@"company_level"]&&(![[NSString stringWithFormat:@"%@",dicMemberInfo[@"company_level"]] isEqualToString:@"0"])) {
        [_viewShadowCompany setHidden:NO];
        NSString *stringcompany_level = dicMemberInfo[@"company_level"];
        _labelTemp[4].text = stringcompany_level;
    }else{
        [_viewShadowCompany setHidden:YES];
    }
    
    
    NSString *stringavailable_predeposit = dicMemberInfo[@"available_predeposit"];
    _labelTemp[5].text = stringavailable_predeposit;
    
    NSString *stringmember_points_available = dicMemberInfo[@"member_points_available"];
    _labelTemp[6].text = stringmember_points_available;
    
    NSString *stringmember_points = dicMemberInfo[@"member_points"];
    _labelTemp[7].text = stringmember_points;
    
    NSString *stringavator = dicMemberInfo[@"avator"];
    [_imageViewTemp[0] sd_setImageWithURL:URL(stringavator) placeholderImage:defaultImage];
}

-(void)tapClick:(UIGestureRecognizer*)tap
{
    NSString *strurl = @"asd";
    if (!IsStringEmptyOrNull(strurl))
    {
        
    }
}

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
    if ([buttonName containsString:@"充值"])
    {
        RechargeViewController *vc = [[RechargeViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"提现"])
    {
        WithdrawViewController *vc = [[WithdrawViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"互转"])
    {
        PointTransformViewController *vc = [[PointTransformViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"储值卡"])
    {
        FundpredepositViewController *vc = [[FundpredepositViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"交易码"])
    {
        TransationViewController *vc = [[TransationViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"积分"])
    {
        PointsViewController *vc = [[PointsViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"实名"])
    {
        VerifiedViewController *vc = [[VerifiedViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"团队"])
    {
        TeamViewController *vc = [[TeamViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"邀请好友"])
    {
        //        NSString *stringlink = [NSString stringWithFormat:@"%@?key=%@",member_inviter_poster,_stringInviterlink];
        NSString *stringlink = [NSString stringWithFormat:@"%@?key=%@",member_inviter_poster,[HPUserDefault objectForKey:@"token"]];
        
        HPBaseWKWebViewController *vc = [[HPBaseWKWebViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.urlStr = stringlink;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"商学院"])
    {
        
    }
    else if([buttonName containsString:@"视频"])
    {
        
    }
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
    
    CGFloat _viewh = _viewTemp.height;
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
    //    scrollView.mj_footer = footer;
    //    scrollView.mj_footer.ignoredScrollViewContentInsetBottom = kScrollViewFooterIgnored;
}



//下拉刷新
- (void)headerRereshing
{
    [self netRequest];
    
    _strParameter = @"1";
    [_arrayDataSource removeAllObjects];
    [_tableViewTemp reloadData];
    
    [HPNetManager POSTWithUrlString:Hostcollegecollege isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"article_type", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
                [self->_arrayDataSource removeAllObjects];
                [self->_tableViewTemp reloadData];
                
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"]]];
                [self->_tableViewTemp reloadData];
                [self->_tableViewTemp.mj_header endRefreshing];
                //                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
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
    [HPNetManager POSTWithUrlString:HostIndexgetCommendGoods isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"]]];
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
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    //GPDebugLog(@"ScrollIndex:%ld",(long)index);
}





#pragma mark - UITableViewDelegate, UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120*GPCommonLayoutScaleSizeWidthIndex;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth , 50*GPCommonLayoutScaleSizeWidthIndex)];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth, 50*GPCommonLayoutScaleSizeWidthIndex)];
//    view.backgroundColor = [UIColor whiteColor];
//    [view rounded:10 rectCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)];
//    [viewHeader addSubview:view];
    
    UILabel *labelHeader = [[UILabel alloc]initWithFrame:CGRectMake(55*GPCommonLayoutScaleSizeWidthIndex, 35*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth - 110*GPCommonLayoutScaleSizeWidthIndex, 50*GPCommonLayoutScaleSizeWidthIndex)];
    labelHeader.textColor = kColorTheme;
    labelHeader.text = @"商学院";
    labelHeader.textAlignment = NSTextAlignmentLeft;
    labelHeader.font = FontRegularWithSize(16);
    [viewHeader addSubview:labelHeader];
    
    
    return viewHeader;
}

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
    return 240.0*GPCommonLayoutScaleSizeWidthIndex;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollegeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentify];
    if(!cell){
        cell = [[CollegeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentify];
    }
    NSDictionary * dic = _arrayDataSource[indexPath.row];
    cell.dic = dic;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollegeContentViewController *vc = [[CollegeContentViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.string_article_id = _arrayDataSource[indexPath.row][@"article_id"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
