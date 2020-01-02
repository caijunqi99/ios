//
//  GoodsViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/3.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "GoodsViewController.h"
#import "SimpleWebViewWithHeaderAndFooter.h"
#import "GoodsBottomView.h"
#import "SDPhotoBrowser.h"
#import "UILabelAlignToTopLeft.h"
#import "ShoppingCartViewController.h"
#import "StoreViewController.h"
#import "AppDelegate.h"
#import "IndexTabBarViewController.h"

#import "ProAttrSelectView.h"
#import "ConfirmOrderViewController.h"

#define kBottomHeightCommon        (130*GPCommonLayoutScaleSizeWidthIndex)

@interface GoodsViewController ()<SDCycleScrollViewDelegate,SDPhotoBrowserDelegate,ProAttrSelectViewDelegate>
{
    UIView              *_viewTop;
    UIView              *_viewFooter;
    UILabelAlignToTopLeft             *_labelTitle;
    UILabelAlignToTopLeft             *_labelAdv;
    UILabelAlignToTopLeft             *_labelPrice;
    
    SimpleWebViewWithHeaderAndFooter           *_webView;
    GoodsBottomView     *_bottomView;
    
    UIButton            *_buttonBack;
    
    NSString            *_htmlString;
    NSDictionary        *_dicDataSource;
    NSMutableArray      *_arrayDataSource;
}
//轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleSV;

//图片浏览器
@property (strong, nonatomic) SDPhotoBrowser *photoBrowser;

@end

@implementation GoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    [self netRequest];
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
    self.navigationController.navigationBar.hidden = YES;
    [self updateInterface];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)updateInterface
{
    CGFloat navAndStatusBarHeight = kNavBarAndStatusBarHeight;
    CGFloat tabbarHeight = kTabBarHeight;
    navAndStatusBarHeight = 0;
    tabbarHeight = kBottomSafeHeight;
    
    [_bottomView setFrame:CGRectMake(0, GPScreenHeight - kBottomHeightCommon - tabbarHeight - navAndStatusBarHeight, GPScreenWidth, kBottomHeightCommon)];
    [_webView setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kBottomHeightCommon - tabbarHeight - navAndStatusBarHeight)];
}

#pragma  mark --------------------- UI ------------------
- (void)configInterface
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    
    
    _webView = [[SimpleWebViewWithHeaderAndFooter alloc] initWithFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight - kTabBarHeight - kBottomHeightCommon)];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_webView];
    
    [self setupRefreshWithScrollView:_webView.scrollView];
    
    
    
    _viewTop = [[UIView alloc]init];
    [_viewTop setBackgroundColor:[UIColor whiteColor]];
    [_viewTop setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenWidth + 110)];
    
    
    _viewFooter = [[UIView alloc]init];
    [_viewFooter setBackgroundColor:[UIColor clearColor]];
    CGFloat height_viewFooter = 0;//arc4random()%40
    [_viewFooter setFrame:CGRectMake(0, 0, GPScreenWidth, height_viewFooter)];
    
    
    
    _cycleSV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, _viewTop.width, _viewTop.width) delegate:self placeholderImage:defaultImage];
    _cycleSV.autoScrollTimeInterval = 3;
    _cycleSV.backgroundColor = [UIColor clearColor];
    _cycleSV.infiniteLoop = YES;
    _cycleSV.localizationImageNamesGroup = @[@"1",@"2",@"3"];
    _cycleSV.imageURLStringsGroup = _arrayDataSource;
    [_viewTop addSubview:_cycleSV];
    
    _labelTitle = [[UILabelAlignToTopLeft alloc]init];
    _labelTitle.frame = CGRectMake(10, _cycleSV.bottom +10, _viewTop.width -20, 40);
    _labelTitle.textColor = [UIColor blackColor];
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    _labelTitle.font = FontMediumWithSize(12);
    _labelTitle.numberOfLines = 2;
    _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewTop addSubview:_labelTitle];
    _labelTitle.text = @"这是标题";
    
    _labelAdv = [[UILabelAlignToTopLeft alloc]init];
    _labelAdv.frame = CGRectMake(10, _labelTitle.bottom+10, _viewTop.width-20-100, 40);
    _labelAdv.textColor = [UIColor grayColor];
    _labelAdv.textAlignment = NSTextAlignmentLeft;
    _labelAdv.font = FontMediumWithSize(12);
    _labelAdv.numberOfLines = 2;
    _labelAdv.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewTop addSubview:_labelAdv];
    _labelAdv.text = @"这是广告词";
    
    _labelPrice = [[UILabelAlignToTopLeft alloc]init];
    _labelPrice.frame = CGRectMake(_viewTop.width - 110, _labelTitle.bottom+10, 100, 20);
    _labelPrice.textColor = [UIColor redColor];
    _labelPrice.textAlignment = NSTextAlignmentRight;
    _labelPrice.font = FontMediumWithSize(16);
    [_viewTop addSubview:_labelPrice];
    _labelPrice.text = @"这是价格¥299.9";
    
    _buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonBack setFrame:CGRectMake(10,kStatusBarHeight+10,40,40)];
    [_buttonBack setImage:GetImage(@"返回") forState:UIControlStateNormal];
    [_buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [_buttonBack setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_buttonBack setTag:99];
    [_buttonBack addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonBack];
    
    _bottomView = [[GoodsBottomView alloc]initWithFrame:CGRectMake(0, GPScreenHeight - kNavBarAndStatusBarHeight - kTabBarHeight - kBottomHeightCommon, GPScreenWidth, kBottomHeightCommon)];
    
    _bottomView.layer.masksToBounds = NO;
    _bottomView.clipsToBounds = NO;
    //全选
    [self clickAllSelectBottomView:_bottomView];
    
    [self.view addSubview:_bottomView];
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)netRequest
{
    [HPNetManager GETWithUrlString:Hostgoodsgoods_detail isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_goods_id,@"goods_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            self->_dicDataSource = response[@"result"];
            NSDictionary *dicStoreInfo = response[@"result"][@"goods_info"];
            [self->_labelTitle setText:dicStoreInfo[@"goods_name"]];
            [self->_labelAdv setText:dicStoreInfo[@"goods_advword"]];
            [self->_labelPrice setText:[NSString stringWithFormat:@"¥%@",dicStoreInfo[@"goods_price"]]];
            self->_htmlString = dicStoreInfo[@"mobile_body"];
            [self->_webView setHeaderView:self->_viewTop andFooterView:self->_viewFooter withHtmlString:self->_htmlString andTitle:dicStoreInfo[@"goods_name"]];
            self->_cycleSV.imageURLStringsGroup = [NSArray arrayWithArray:self->_dicDataSource[@"goods_image"]];
            self->_arrayDataSource = [NSMutableArray arrayWithArray:self->_dicDataSource[@"goods_image"]];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

-(void)putInShoppingCartWithAmount:(NSString *)amount AndGoodsID:(NSString *)goodsId
{
    [HPNetManager POSTWithUrlString:Hostmembercartcart_add isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:goodsId,@"goods_id",amount,@"quantity",[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"加入购物车成功" buttonTitle:nil buttonStyle:HPAlertActionStyleDefault];
            self->_bottomView.buttonToShoppingCart.badgeStyle = BadgeStyleNumber;
            self->_bottomView.buttonToShoppingCart.badgeValue =  [NSString stringWithFormat:@"%@",response[@"result"][@"num"]];
            
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

-(void)purchase
{
    
    [HPNetManager GETWithUrlString:Hostgoodsgoods_detail isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_goods_id,@"goods_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            self->_dicDataSource = response[@"result"];
            NSDictionary *dicStoreInfo = response[@"result"][@"goods_info"];
            [self->_labelTitle setText:dicStoreInfo[@"goods_name"]];
            [self->_labelAdv setText:dicStoreInfo[@"goods_advword"]];
            [self->_labelPrice setText:[NSString stringWithFormat:@"¥%@",dicStoreInfo[@"goods_price"]]];
            self->_htmlString = dicStoreInfo[@"mobile_body"];
            [self->_webView setHeaderView:self->_viewTop andFooterView:self->_viewFooter withHtmlString:self->_htmlString andTitle:dicStoreInfo[@"goods_name"]];
            self->_cycleSV.imageURLStringsGroup = [NSArray arrayWithArray:self->_dicDataSource[@"goods_image"]];
            self->_arrayDataSource = [NSMutableArray arrayWithArray:self->_dicDataSource[@"goods_image"]];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}



- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    _photoBrowser = [[SDPhotoBrowser alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _photoBrowser.delegate = self;
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor blackColor];
    _photoBrowser.imageCount = _arrayDataSource.count;
    
    _photoBrowser.sourceImagesContainerView = cycleScrollView;
    _photoBrowser.currentImageIndex = index;
    
    [_photoBrowser show];
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImage *image = defaultImage;
    if (browser == self.photoBrowser) {
        return image;
    }
    return image;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSURL *url = URL(@"1");
    if (browser == self.photoBrowser) {
        return _arrayDataSource[index];
    }
    return url;
}

-(SDPhotoBrowser *)photoBrowser
{
    if (!_photoBrowser) {
        _photoBrowser = [[SDPhotoBrowser alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _photoBrowser;
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
    [_webView.scrollView.mj_header endRefreshing];
    return;
    [HPNetManager GETWithUrlString:HostStorestore_goods isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys: nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"goods_list"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"goods_list"]]];
                [self->_webView reload];
                [self->_webView.scrollView.mj_header endRefreshing];
            }
            else
            {
                [self->_webView.scrollView.mj_header endRefreshing];
            }
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



/**
 全选点击---逻辑处理
 @param bottomView 底部的View
 */
- (void)clickAllSelectBottomView:(GoodsBottomView *)bottomView {
    //    HPWeakSelf(self);
    //    HPStrongSelf(self);
    bottomView.ToStoreBlock = ^(void) {
        NSString *storeID = self->_dicDataSource[@"store_info"][@"store_id"];
        StoreViewController *vc = [[StoreViewController alloc]init];
        vc.store_id = storeID;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    bottomView.ToCallBlock = ^(void) {
        //        [self callPhoneString:@"17777868624"];
        NSString *stringPhoneNumber = StringNullOrNot(self->_dicDataSource[@"store_info"][@"store_phone"]);
        if (IsStringEmptyOrNull(stringPhoneNumber)) {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"商家没有留下联系方式" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        else{
            [self callPhoneString:stringPhoneNumber];
        }
    };
    
    bottomView.ToShoppingCartBlock = ^(void) {
        
        //设置indextabbar为主窗口的根视图控制器
        [self.navigationController popToRootViewControllerAnimated:NO];
        IndexTabBarViewController *vc = [IndexTabBarViewController shareInstance];
        [vc setSelectedIndex:3];
    };
    
    bottomView.PutInShoppingCartBlock = ^(void) {
        
        ProAttrSelectView *view = [[ProAttrSelectView alloc]initWithImageUrlString:self->_dicDataSource[@"goods_image"][0] andGoodsName:self->_dicDataSource[@"goods_info"][@"goods_name"]];
        view.delegate = self;
        view.tag = 200;
        [view show];
    };
    
    bottomView.PurchaseBlock = ^{
//        ProAttrSelectView *view = [[ProAttrSelectView alloc]initWithData:@[
//            @{@"颜色":@[@"红色",@"白色",@"黑色",@"金色"]},
//            @{@"内存":@[@"16GB",@"32GB",@"64GB",@"128GB",@"256GB",@"512GB"]},
//            @{@"处理器":@[@"1代",@"2代"]}
//        ]];
        ProAttrSelectView *view = [[ProAttrSelectView alloc]initWithImageUrlString:self->_dicDataSource[@"goods_image"][0] andGoodsName:self->_dicDataSource[@"goods_info"][@"goods_name"]];
        view.delegate = self;
        view.tag = 100;
        [view show];
    };
}

- (void)proAttrSelectView:(ProAttrSelectView *)view didClickSureWithAttrs:(NSMutableArray *)attrs count:(NSInteger)count {
    //GPDebugLog(@"%@:%ld",attrs,count);
    if (view.tag == 100) {
        ConfirmOrderViewController *vc = [[ConfirmOrderViewController alloc]init];
        [vc setCart_id:[NSString stringWithFormat:@"%@|%ld",_goods_id,(long)count] andIfcart:@"0"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (view.tag == 200)
    {
        [self putInShoppingCartWithAmount:[NSString stringWithFormat:@"%ld",(long)count] AndGoodsID:_goods_id];
    }
}


@end
