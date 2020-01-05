//
//  TransationViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/2.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "TransationViewController.h"

#import "TransationTableViewCell.h"
@interface TransationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView                  *_viewTemp;
    
    //    UIView                  *_viewBack;
    UIView                  *_viewInfo;
    UITableView             *_tableViewTemp;
    
    UILabel                 *_labelTemp[3];
    UIImageView             *_imageViewTemp[1];
    
    //    NSMutableArray          *_arrayButtonTitle;
    //    NSMutableArray          *_arrayButtonImageName;
    
    NSMutableArray          *_arrayDataSource;
    
    NSString                *_strParameter;
    NSString                *_stringInviterlink;
}


@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation TransationViewController

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
        //        _arrayButtonTitle = [[NSMutableArray alloc]initWithObjects:@"充值",@"提现",@"互转",@"储值卡",@"交易码",@"积分",@"实名",@"团队",@"邀请好友", nil];//@"商学院",@"视频",
        //        _arrayButtonImageName = [[NSMutableArray alloc]initWithObjects:@"充值",@"提现",@"互转",@"储值卡",@"交易码",@"积分",@"实名",@"团队",@"邀请好友", nil];//@"商学院",@"视频",
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)configInterface
{
    viewSetBackgroundColor(kColorTheme);
    
    _viewTemp = [UIView initViewBackColor:[UIColor clearColor]];
    [self.view addSubview:_viewTemp];
    [_viewTemp setFrame:CGRectMake(0, kStatusBarHeight, GPScreenWidth, 540*GPCommonLayoutScaleSizeWidthIndex)];
    
    UIImage *tmpImage = GetImage(@"白色左箭头");
    CGSize newSize = CGSizeMake(14, 24);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    [tmpImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:CGRectMake(20, 10, 14, 24)];
    [navButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navButton setImage:backButtonImage forState:UIControlStateNormal];
    navButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [navButton addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [_viewTemp addSubview:navButton];
    [_viewTemp bringSubviewToFront:navButton];
    
    _viewInfo = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewTemp addSubview:_viewInfo];
    [_viewInfo setFrame:RectWithScale(CGRectMake(0, 420, 1080, 120), GPCommonLayoutScaleSizeWidthIndex)];
    
    
    _imageViewTemp[0] = [[UIImageView alloc]initWithImage:GetImage(@"数字币")];
    [_viewTemp addSubview:_imageViewTemp[0]];
    [_imageViewTemp[0] setFrame:RectWithScale(CGRectMake(430, 140, 60, 60),GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    NSArray *arrayLabelText = @[@"交易码",@"50.00",@"收支记录"];
    for (NSInteger i = 0; i < arrayLabelText.count; i++) {
        
        _labelTemp[i] = [UILabel initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:arrayLabelText[i]];
        _labelTemp[i].lineBreakMode = NSLineBreakByCharWrapping;
        _labelTemp[i].backgroundColor = [UIColor clearColor];
        [_labelTemp[i] setTextColor:[UIColor blackColor]];
        _labelTemp[i].textAlignment = NSTextAlignmentLeft;
        [_labelTemp[i] setFont:FontRegularWithSize(20)];
    }
    
    [_labelTemp[0] setFrame:RectWithScale(CGRectMake(500, 150, 400, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[0]];
    [_labelTemp[0] setTextColor:[UIColor whiteColor]];
    _labelTemp[0].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[1] setFrame:RectWithScale(CGRectMake(340, 240, 400, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[1]];
    [_labelTemp[1] setTextColor:[UIColor whiteColor]];
    _labelTemp[1].textAlignment = NSTextAlignmentCenter;
    
    [_labelTemp[2] setFrame:RectWithScale(CGRectMake(60, 35, 400, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewInfo addSubview:_labelTemp[2]];
    [_labelTemp[2] setTextColor:[UIColor grayColor]];
    _labelTemp[2].textAlignment = NSTextAlignmentLeft;
    
    
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
    
    [HPNetManager POSTWithUrlString:Hostmembermy_asset isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",@"transaction",@"fields", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 200) {
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
    NSDictionary *datainfo = dic;
    
    NSString *stringavailable = [NSString stringWithFormat:@"%@",datainfo[@"transaction"]];
    _labelTemp[1].text = stringavailable;
}

-(void)tapClick:(UIGestureRecognizer*)tap
{
    NSString *stringlink = [NSString stringWithFormat:@"%@?key=%@",member_inviter_poster,[HPUserDefault objectForKey:@"token"]];
    
    HPBaseWKWebViewController *vc = [[HPBaseWKWebViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.urlStr = stringlink;
    [self.navigationController pushViewController:vc animated:YES];
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
    else if([buttonName containsString:@"交易码"])
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
    
    [HPNetManager POSTWithUrlString:Hostmemberfundtransactionlog isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_strParameter,@"page",@"5",@"pagesize", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 200) {
            
            if ([[NSArray arrayWithArray:response[@"result"][@"list"]] count]) {
                [self->_arrayDataSource removeAllObjects];
                [self->_tableViewTemp reloadData];
                
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
        //实名认证
        else if([response[@"code"] integerValue] == 10086)
        {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:response[@"message"] callbackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
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
    [HPNetManager POSTWithUrlString:Hostmemberfundtransactionlog isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_strParameter,@"page",@"5",@"pagesize", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
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
        //实名认证
        else if([response[@"code"] integerValue] == 10086)
        {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:response[@"message"] callbackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
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
    TransationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentify];
    if(!cell){
        cell = [[TransationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentify];
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
