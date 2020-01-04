//
//  TeamViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/29.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "TeamViewController.h"

#import "TeamTableViewCell.h"
@interface TeamViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIView                  *_viewTemp;
    
    UIView                  *_viewGray;
    UIView                  *_viewInvite;
    UITableView             *_tableViewTemp;
    
    UILabel                 *_labelTemp[9];
    UIImageView             *_imageViewTemp[3];
    
//    NSMutableArray          *_arrayButtonTitle;
//    NSMutableArray          *_arrayButtonImageName;
    
    NSMutableArray          *_arrayDataSource;
    
//    NSString                *_strParameter;
    NSString                *_stringInviterlink;
}


@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation TeamViewController

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
//        _strParameter = @"1";
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
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)configInterface
{
    
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    [self settingNavTitle:@"我的团队"];
    viewSetBackgroundColor(kColorBasic);
    
    _viewTemp = [UIView initViewBackColor:[UIColor whiteColor]];
    [self.view addSubview:_viewTemp];
    [_viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, 680*GPCommonLayoutScaleSizeWidthIndex)];
    
    _viewGray = [UIView initViewBackColor:rgb(246, 247, 248)];
    [_viewTemp addSubview:_viewGray];
    [_viewGray setFrame:RectWithScale(CGRectMake(0, 500, 1080, 30), GPCommonLayoutScaleSizeWidthIndex)];
//    [_viewGray rounded:25*GPCommonLayoutScaleSizeWidthIndex];
//    [_viewGray shadow:[UIColor blackColor] opacity:1 radius:10 offset:CGSizeMake(0, 0)];
    
    
    _viewInvite = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewTemp addSubview:_viewInvite];
    [_viewInvite setFrame:RectWithScale(CGRectMake(0, 380, 1080, 120), GPCommonLayoutScaleSizeWidthIndex)];
//    [_viewInvite rounded:25*GPCommonLayoutScaleSizeWidthIndex];
//    [_viewInvite shadow:[UIColor blackColor] opacity:1 radius:10 offset:CGSizeMake(0, 0)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_viewInvite addGestureRecognizer:tap];
    [_viewInvite setUserInteractionEnabled:YES];
    
    _imageViewTemp[0] = [[UIImageView alloc]initWithImage:GetImage(@"直推人数")];
    [_viewTemp addSubview:_imageViewTemp[0]];
    [_imageViewTemp[0] setFrame:RectWithScale(CGRectMake(45, 75, 480, 255),GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[0] rounded:42*GPCommonLayoutScaleSizeWidthIndex];
    
    _imageViewTemp[1] = [[UIImageView alloc]initWithImage:GetImage(@"团队人数")];
    [_viewTemp addSubview:_imageViewTemp[1]];
    [_imageViewTemp[1] setFrame:RectWithScale(CGRectMake(555, 75, 480, 255),GPCommonLayoutScaleSizeWidthIndex)];
    
    _imageViewTemp[2] = [[UIImageView alloc]initWithImage:GetImage(@"邀请好友下一步")];
    [_viewInvite addSubview:_imageViewTemp[2]];
    [_imageViewTemp[2] setFrame:RectWithScale(CGRectMake(980, 40, 40, 40),GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    NSArray *arrayLabelText = @[@"直推人数",@"",@"团队人数",@"",@"邀请好友",@"手机号",@"经验值",@"代数",
                                @"注册时间"];
    for (NSInteger i = 0; i < arrayLabelText.count; i++) {
        
        _labelTemp[i] = [UILabel initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:arrayLabelText[i]];
        _labelTemp[i].lineBreakMode = NSLineBreakByCharWrapping;
        _labelTemp[i].backgroundColor = [UIColor clearColor];
        [_labelTemp[i] setTextColor:[UIColor blackColor]];
        _labelTemp[i].textAlignment = NSTextAlignmentLeft;
        [_labelTemp[i] setFont:FontRegularWithSize(16)];
    }
    
    [_labelTemp[0] setFrame:RectWithScale(CGRectMake(60, 70, 400, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[0] addSubview:_labelTemp[0]];
    [_labelTemp[0] setTextColor:[UIColor whiteColor]];
    _labelTemp[0].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[1] setFrame:RectWithScale(CGRectMake(60, 140, 400, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[0] addSubview:_labelTemp[1]];
    [_labelTemp[1] setTextColor:[UIColor whiteColor]];
    _labelTemp[1].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[2] setFrame:RectWithScale(CGRectMake(60, 70, 400, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[1] addSubview:_labelTemp[2]];
    [_labelTemp[2] setTextColor:[UIColor whiteColor]];
    _labelTemp[2].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[3] setFrame:RectWithScale(CGRectMake(60, 140, 400, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewTemp[1] addSubview:_labelTemp[3]];
    [_labelTemp[3] setTextColor:[UIColor whiteColor]];
    _labelTemp[3].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[4] setFrame:RectWithScale(CGRectMake(45, 40, 350, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewInvite addSubview:_labelTemp[4]];
    [_labelTemp[4] setTextColor:[UIColor blackColor]];
    _labelTemp[4].textAlignment = NSTextAlignmentLeft;
    
    
    [_labelTemp[5] setFrame:RectWithScale(CGRectMake(40, 530 + 45, 360, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[5]];
    [_labelTemp[5] setTextColor:[UIColor blackColor]];
    _labelTemp[5].textAlignment = NSTextAlignmentCenter;
    [_labelTemp[5] setFont:FontRegularWithSize(16)];
    
    [_labelTemp[6] setFrame:RectWithScale(CGRectMake(400, 530 + 45, 150, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[6]];
    [_labelTemp[6] setTextColor:[UIColor blackColor]];
    _labelTemp[6].textAlignment = NSTextAlignmentCenter;
    [_labelTemp[6] setFont:FontRegularWithSize(16)];
    
    [_labelTemp[7] setFrame:RectWithScale(CGRectMake(550, 530 + 45, 100, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[7]];
    [_labelTemp[7] setTextColor:[UIColor blackColor]];
    _labelTemp[7].textAlignment = NSTextAlignmentCenter;
    [_labelTemp[7] setFont:FontRegularWithSize(16)];
    
    [_labelTemp[8] setFrame:RectWithScale(CGRectMake(650, 530 + 45, 390, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTemp addSubview:_labelTemp[8]];
    [_labelTemp[8] setTextColor:[UIColor blackColor]];
    _labelTemp[8].textAlignment = NSTextAlignmentCenter;
    [_labelTemp[8] setFont:FontRegularWithSize(16)];
    
    
    _tableViewTemp = [[UITableView alloc]initWithFrame:CGRectMake(0, _viewTemp.height, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight - _viewTemp.height) style:UITableViewStylePlain];
    _tableViewTemp.showsVerticalScrollIndicator = NO;
    _tableViewTemp.showsHorizontalScrollIndicator = NO;
    _tableViewTemp.dataSource = self;
    _tableViewTemp.delegate = self;
    _tableViewTemp.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableViewTemp];
//    [_tableViewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight)];
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

-(void)netRequest
{
    [HPNetManager POSTWithUrlString:Hostmemberinviter isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 200) {
            self->_arrayDataSource = [NSMutableArray arrayWithArray:response[@"result"][@"datainfo"]];
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
    
    NSString *stringcountOne = [NSString stringWithFormat:@"%@",datainfo[@"countOne"]];
    _labelTemp[1].text = stringcountOne;
    
    NSString *stringcountAll = [NSString stringWithFormat:@"%@",datainfo[@"countAll"]];
    _labelTemp[3].text = stringcountAll;//[NSString stringWithFormat:@"推荐码:%@",stringcountAll];
    
    _stringInviterlink = [NSString stringWithFormat:@"%@",datainfo[@"inviterlink"]];
}

-(void)tapClick:(UIGestureRecognizer*)tap
{
//    NSString *stringlink = [NSString stringWithFormat:@"%@?key=%@",member_inviter_poster,_stringInviterlink];
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
    
    CGFloat _viewh = _viewTemp.bottom;
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
//    _strParameter = @"1";
    [_arrayDataSource removeAllObjects];
    [_tableViewTemp reloadData];
    
    [HPNetManager POSTWithUrlString:Hostmemberinviter isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 200) {
//            self->_arrayDataSource = [NSMutableArray arrayWithArray:response[@"result"][@"datainfo"]];
            [self updateInterfaceWithDic:response[@"result"]];
            
            if ([[NSArray arrayWithArray:response[@"result"][@"datainfo"]] count]) {
                [self->_arrayDataSource removeAllObjects];
                [self->_tableViewTemp reloadData];
                
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"datainfo"]]];
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
//    [HPNetManager GETWithUrlString:HostIndexgetCommendGoods isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page", nil] successBlock:^(id response) {
//        //GPDebugLog(@"response:%@",response);
//        if ([response[@"code"] integerValue] == 200) {
//            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
//                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"]]];
//                [self->_tableViewTemp reloadData];
//                [self->_tableViewTemp.mj_footer endRefreshing];
//                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
//            }
//            else
//            {
//                [self->_tableViewTemp.mj_footer endRefreshing];
//            }
//        }
//        else
//        {
//            [self->_tableViewTemp.mj_footer endRefreshing];
//            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
//        }
//    } failureBlock:^(NSError *error) {
//        [self->_tableViewTemp.mj_footer endRefreshing];
//    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//
//    }];
    
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
    return 70.0*GPCommonLayoutScaleSizeWidthIndex;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentify];
    if(!cell){
        cell = [[TeamTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentify];
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
