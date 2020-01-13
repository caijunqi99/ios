//
//  PointsViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/2.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "PointsViewController.h"

#import "PointsTableViewCell.h"
#import "WithdrawViewController.h"
#import "PointTransformViewController.h"
@interface PointsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView                  *_viewTemp;
    
    //    UIView                  *_viewBack;
    UIView                  *_viewInfo;
    UIView                  *_viewTransform;
    UIView                  *_viewWithdraw;
    UITableView             *_tableViewTemp;
    
    UILabel                 *_labelTemp[7];
    UIImageView             *_imageViewTemp[3];
    
    //    NSMutableArray          *_arrayButtonTitle;
    //    NSMutableArray          *_arrayButtonImageName;
    
    NSMutableArray          *_arrayDataSource;
    
    NSString                *_strParameter;
    NSString                *_stringInviterlink;
}


@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation PointsViewController

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
        //        _arrayButtonTitle = [[NSMutableArray alloc]initWithObjects:@"充值",@"提现",@"互转",@"储值卡",@"认筹股",@"积分",@"实名",@"团队",@"邀请好友", nil];//@"商学院",@"视频",
        //        _arrayButtonImageName = [[NSMutableArray alloc]initWithObjects:@"充值",@"提现",@"互转",@"储值卡",@"认筹股",@"积分",@"实名",@"团队",@"邀请好友", nil];//@"商学院",@"视频",
    }
    return self;
}

-(void)dealloc
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:CreateImageWithColor([UIColor whiteColor]) forBarMetrics:UIBarMetricsDefault];
}

- (void)configInterface
{
    viewSetBackgroundColor(kColorTheme);
    
    _viewTemp = [UIView initViewBackColor:[UIColor clearColor]];
    [self.view addSubview:_viewTemp];
    [_viewTemp setFrame:CGRectMake(0, kStatusBarHeight, GPScreenWidth, 690*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    UIImage *backButtonImage = GetImage(@"白色左按钮-1");
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:CGRectMake(20, 0, 30, 44)];
    [navButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navButton setImage:backButtonImage forState:UIControlStateNormal];
    navButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [navButton addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [_viewTemp addSubview:navButton];
    [_viewTemp bringSubviewToFront:navButton];
    
    _viewInfo = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewTemp addSubview:_viewInfo];
    [_viewInfo setFrame:RectWithScale(CGRectMake(0, 570, 1080, 120), GPCommonLayoutScaleSizeWidthIndex)];
    
    _viewTransform = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewTemp addSubview:_viewTransform];
    [_viewTransform setFrame:RectWithScale(CGRectMake(0, 420, 540, 150), GPCommonLayoutScaleSizeWidthIndex)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_viewTransform addGestureRecognizer:tap];
    [_viewTransform setUserInteractionEnabled:YES];
    
    _viewWithdraw = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewTemp addSubview:_viewWithdraw];
    [_viewWithdraw setFrame:RectWithScale(CGRectMake(540, 420, 540, 150), GPCommonLayoutScaleSizeWidthIndex)];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_viewWithdraw addGestureRecognizer:tap1];
    [_viewWithdraw setUserInteractionEnabled:YES];
    
    _imageViewTemp[1] = [[UIImageView alloc]initWithImage:GetImage(@"互转")];
    [_viewTransform addSubview:_imageViewTemp[1]];
    [_imageViewTemp[1] setFrame:RectWithScale(CGRectMake(200, 55, 50, 40),GPCommonLayoutScaleSizeWidthIndex)];
    
    _imageViewTemp[2] = [[UIImageView alloc]initWithImage:GetImage(@"提现")];
    [_viewWithdraw addSubview:_imageViewTemp[2]];
    [_imageViewTemp[2] setFrame:RectWithScale(CGRectMake(200, 55, 50, 40),GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    NSArray *arrayLabelText = @[@"冻结积分",@"0.00",@"可用积分",@"0.00",@"收支记录",@"互转",@"提现"];
    for (NSInteger i = 0; i < arrayLabelText.count; i++) {
        
        _labelTemp[i] = [UILabel initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:arrayLabelText[i]];
        _labelTemp[i].lineBreakMode = LineBreakModeDefault;
        _labelTemp[i].backgroundColor = [UIColor clearColor];
        [_labelTemp[i] setTextColor:[UIColor blackColor]];
        _labelTemp[i].textAlignment = NSTextAlignmentLeft;
        [_labelTemp[i] setFont:FontRegularWithSize(20)];
    }
    
    [_labelTemp[0] setFrame:RectWithScale(CGRectMake(0, 150, 540, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[0]];
    [_labelTemp[0] setTextColor:[UIColor whiteColor]];
    _labelTemp[0].textAlignment = NSTextAlignmentCenter;
    
    [_labelTemp[1] setFrame:RectWithScale(CGRectMake(0, 240, 540, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[1]];
    [_labelTemp[1] setTextColor:[UIColor whiteColor]];
    _labelTemp[1].textAlignment = NSTextAlignmentCenter;
    
    [_labelTemp[2] setFrame:RectWithScale(CGRectMake(540, 150, 540, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[2]];
    [_labelTemp[2] setTextColor:[UIColor whiteColor]];
    _labelTemp[2].textAlignment = NSTextAlignmentCenter;
    
    [_labelTemp[3] setFrame:RectWithScale(CGRectMake(540, 240, 540, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[3]];
    [_labelTemp[3] setTextColor:[UIColor whiteColor]];
    _labelTemp[3].textAlignment = NSTextAlignmentCenter;
    
    [_labelTemp[4] setFrame:RectWithScale(CGRectMake(60, 35, 400, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewInfo addSubview:_labelTemp[4]];
    [_labelTemp[4] setTextColor:[UIColor grayColor]];
    _labelTemp[4].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[5] setFrame:RectWithScale(CGRectMake(260, 50, 240, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTransform addSubview:_labelTemp[5]];
    [_labelTemp[5] setTextColor:[UIColor blackColor]];
    _labelTemp[5].textAlignment = NSTextAlignmentLeft;
    [_labelTemp[5] setFont:FontRegularWithSize(16)];
    
    [_labelTemp[6] setFrame:RectWithScale(CGRectMake(260, 50, 240, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewWithdraw addSubview:_labelTemp[6]];
    [_labelTemp[6] setTextColor:[UIColor blackColor]];
    _labelTemp[6].textAlignment = NSTextAlignmentLeft;
    [_labelTemp[6] setFont:FontRegularWithSize(16)];
    
    
    
    _tableViewTemp = [[UITableView alloc]initWithFrame:CGRectMake(0, _viewInfo.bottom + kStatusBarHeight, GPScreenWidth, GPScreenHeight - kStatusBarHeight - _viewInfo.bottom) style:UITableViewStylePlain];// + kStatusBarHeight //- kStatusBarHeight
    _tableViewTemp.showsVerticalScrollIndicator = NO;
    _tableViewTemp.showsHorizontalScrollIndicator = NO;
    _tableViewTemp.dataSource = self;
    _tableViewTemp.delegate = self;
    _tableViewTemp.backgroundColor = rgb(246, 247, 248);
    [self.view addSubview:_tableViewTemp];
    
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
    
    [HPNetManager POSTWithUrlString:Hostmembermy_asset isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",@"available",@"fields", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 200) {
            [self updateInterfaceWithDic:response[@"result"]];
        }
        //实名认证
        else if([response[@"code"] integerValue] == 10086)
        {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:response[@"message"] callbackBlock:^(NSInteger btnIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil];
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
    NSDictionary *datainfo = dic;
    
    NSString *stringpoint = [NSString stringWithFormat:@"%@",datainfo[@"point"]];
    _labelTemp[1].text = stringpoint;
    
    NSString *stringavailable = [NSString stringWithFormat:@"%@",datainfo[@"available"]];
    _labelTemp[3].text = stringavailable;
}

-(void)tapClick:(UIGestureRecognizer*)tap
{
    if (tap.view == _viewTransform) {
        PointTransformViewController *vc = [[PointTransformViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tap.view == _viewWithdraw){
        WithdrawViewController *vc = [[WithdrawViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
    if ([buttonName containsString:@"充值"])
    {
        
    }
    else if([buttonName containsString:@"提现"])
    {
        
    }
    else if([buttonName containsString:@"互转"])
    {
        
    }
    else if([buttonName containsString:@"储值卡"])
    {
        
    }
    else if([buttonName containsString:@"认筹股"])
    {
        
    }
    else if([buttonName containsString:@"积分"])
    {
        
    }
    else if([buttonName containsString:@"实名"])
    {
        
    }
    else if([buttonName containsString:@"团队"])
    {
        
    }
    else if([buttonName containsString:@"邀请好友"])
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
    [self netRequest];
    _strParameter = @"1";
    [_arrayDataSource removeAllObjects];
    [_tableViewTemp reloadData];
    
    [HPNetManager POSTWithUrlString:Hostmemberpointspointslog isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_strParameter,@"page",@"10",@"pagesize", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 200) {
            
            if ([[NSArray arrayWithArray:response[@"result"][@"log_list"]] count]) {
                [self->_arrayDataSource removeAllObjects];
                [self->_tableViewTemp reloadData];
                
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"log_list"]]];
                [self->_tableViewTemp reloadData];
                [self->_tableViewTemp.mj_header endRefreshing];
                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
            }
            else
            {
                [self->_tableViewTemp.mj_header endRefreshing];
            }
        }
        //实名认证
        else if([response[@"code"] integerValue] == 10086)
        {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:response[@"message"] callbackBlock:^(NSInteger btnIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil];
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
    [HPNetManager POSTWithUrlString:Hostmemberpointspointslog isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_strParameter,@"page",@"10",@"pagesize", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"log_list"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"log_list"]]];
                [self->_tableViewTemp reloadData];
                [self->_tableViewTemp.mj_footer endRefreshing];
                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
            }
            else
            {
                [self->_tableViewTemp.mj_footer endRefreshing];
            }
        }
        //实名认证
        else if([response[@"code"] integerValue] == 10086)
        {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:response[@"message"] callbackBlock:^(NSInteger btnIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil];
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
    return 90.0*GPCommonLayoutScaleSizeWidthIndex;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PointsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentify];
    if(!cell){
        cell = [[PointsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentify];
    }
    NSDictionary * dic = _arrayDataSource[indexPath.row];
    cell.dic = dic;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
