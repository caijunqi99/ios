//
//  CollegeContentViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/2.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "CollegeContentViewController.h"
#import "SimpleWebViewWithHeaderAndFooter.h"

#define kBottomHeightCommon        (130*GPCommonLayoutScaleSizeWidthIndex)

@interface CollegeContentViewController ()
{
    UIView              *_viewTop;
    UIView              *_viewFooter;
    UILabelAlignToTopLeft             *_labelTitle;
    UILabelAlignToTopLeft             *_labelAdv;
    UILabelAlignToTopLeft             *_labelPrice;
    
    SimpleWebViewWithHeaderAndFooter           *_webView;
    
    UIButton            *_buttonBack;
    
    NSString            *_htmlString;
    NSDictionary        *_dicDataSource;
    NSMutableArray      *_arrayDataSource;
}

@end

@implementation CollegeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    //    [self headerRereshing];
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
        _arrayDataSource = [NSMutableArray arrayWithObjects:@"https://shop.bayi-shop.com/uploads/home/store/goods/1/1_2017092901284880537.jpg",@"https://shop.bayi-shop.com/uploads/home/store/goods/1/1_2017092901271966752.jpg",@"https://shop.bayi-shop.com/uploads/home/store/goods/1/1_2017092901314252467.jpg", nil];
        
        _htmlString  = @"<img src=\"https://shop.bayi-shop.com/uploads/home/store/goods/1/1_2017092901284880537.jpg\"><img src=\"https://shop.bayi-shop.com/uploads/home/store/goods/1/1_2017092901271966752.jpg\"><img src=\"https://shop.bayi-shop.com/uploads/home/store/goods/1/1_2017092901314252467.jpg\"><div>啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊</div><div>啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊范德萨范德萨发多少阿凡达范德萨范德萨发送到范德萨范德萨富士达发送到范德萨</div>";
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
    [self headerRereshing];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma  mark --------------------- UI ------------------
- (void)configInterface
{
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    viewSetBackgroundColor(kColorViewBackground);
    
    _webView = [[SimpleWebViewWithHeaderAndFooter alloc] initWithFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight)];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_webView];
    
    [self setupRefreshWithScrollView:_webView.scrollView];
    
    
    
    _viewTop = [[UIView alloc]init];
    [_viewTop setBackgroundColor:[UIColor whiteColor]];
    [_viewTop setFrame:CGRectMake(0, 0, GPScreenWidth, 0)];//GPScreenWidth + 110
    
    
    _viewFooter = [[UIView alloc]init];
    [_viewFooter setBackgroundColor:[UIColor clearColor]];
    CGFloat height_viewFooter = 0;//arc4random()%40
    [_viewFooter setFrame:CGRectMake(0, 0, GPScreenWidth, height_viewFooter)];
    
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [HPNetManager GETWithUrlString:Hostcollegedetail isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_string_article_id,@"article_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 200) {
            self->_dicDataSource = response[@"result"];
            
            self->_htmlString = response[@"result"][@"article_content"];
            [self->_webView setHeaderView:self->_viewTop andFooterView:self->_viewFooter withHtmlString:self->_htmlString andTitle:response[@"result"][@"article_title"]];
            
            [self settingNavTitle:response[@"result"][@"article_title"]];
            [self->_webView.scrollView.mj_header endRefreshing];
        }
        else
        {
            [self->_webView.scrollView.mj_header endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        [self->_webView.scrollView.mj_header endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

//上拉加载更多
- (void)footerRereshing
{
    //这里加入的是网络请求，带上相关参数，利用网络工具进行请求。我这里没有网络就模拟一下数据吧。
    //网络不管请求成功还是失败都要结束更新。
    
    //利用延时函数模拟网络加载
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self->_webView.scrollView.mj_footer endRefreshing];
    });
}

@end
