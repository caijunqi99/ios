//
//  OrderDetailViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/4.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "OrderDetailViewController.h"

#import "OrderDetailBottomView.h"

#import "OrderDetailTableViewCell.h"
#import "OrderDetailHeaderView.h"

#import "ConfirmOrderToPayViewController.h"
#import "ExpressViewController.h"
@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIView               *_viewHeader;
    
    UIView               *_viewState;
    UILabelAlignToTopLeft              *_labelState;
    UILabelAlignToTopLeft              *_labelDescribe;
    
    UIView               *_viewExpress;
    UIImageView          *_imageViewExpress;
    UILabelAlignToTopLeft              *_labelExpressState;
    UILabelAlignToTopLeft              *_labelExpressTime;
    UIImageView          *_imageViewExpressArrow;
    
    UIView               *_viewDelivery;
    UIImageView          *_imageViewDelivery;
    UILabelAlignToTopLeft              *_labelDeliveryName;
    UILabelAlignToTopLeft              *_labelDeliveryMobile;
    UILabelAlignToTopLeft              *_labelDeliveryAddress;
    
    UIView               *_viewFooter;
    UILabelAlignToTopLeft              *_labelOrderIntro;
    UILabelAlignToTopLeft              *_labelOrderIDIntro;
    UILabelAlignToTopLeft              *_labelOrderID;
    UILabelAlignToTopLeft              *_labelOrderCreateTimeIntro;
    UILabelAlignToTopLeft              *_labelOrderCreateTime;
    UILabelAlignToTopLeft              *_labelOrderPriceIntro;
    UILabelAlignToTopLeft              *_labelOrderPrice;
    
    OrderDetailBottomView   *_bottomView;
    
    UITableView          *_tableViewOrder;
    NSMutableArray      *_arrayDataSource;
    NSDictionary        *_dicDataSource;
    NSString            *_string_express_code;
    NSString            *_string_shipping_code;
    NSString            *_string_phone;
}



@end

static NSString * const ReuseIdentify = @"ReuseIdentify";
#define kBottomHeightShoppingCart        (180*GPCommonLayoutScaleSizeWidthIndex)

@implementation OrderDetailViewController

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
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    viewSetBackgroundColor(kColorTheme);
    
    _viewHeader = [UIView initViewBackColor:[UIColor clearColor]];
    [self.view addSubview:_viewHeader];
    [_viewHeader setFrame:RectWithScale(CGRectMake(0, 0, 1080, 810 - 190), GPCommonLayoutScaleSizeWidthIndex)];
    
    _viewState = [UIView initViewBackColor:kColorTheme];
    [_viewHeader addSubview:_viewState];
    [_viewState setFrame:RectWithScale(CGRectMake(0, 0-1000, 1080, 380+1000), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelState = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor whiteColor] title:@"卖家已发货"];
    _labelState.lineBreakMode = NSLineBreakByCharWrapping;
    _labelState.backgroundColor = [UIColor clearColor];
    [_viewState addSubview:_labelState];
    [_labelState setFrame:RectWithScale(CGRectMake(120, 170+1000, 840, 60), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelDescribe = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor whiteColor] title:@""];
    _labelDescribe.lineBreakMode = NSLineBreakByCharWrapping;
    _labelDescribe.backgroundColor = [UIColor clearColor];
    //    [_viewState addSubview:_labelDescribe];
    [_labelDescribe setFrame:RectWithScale(CGRectMake(120, 230+1000, 840, 120), GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    _viewExpress = [UIView initViewBackColor:[UIColor whiteColor]];
    //    [_viewHeader addSubview:_viewExpress];
    [_viewExpress setFrame:RectWithScale(CGRectMake(0, 370, 1080, 190), GPCommonLayoutScaleSizeWidthIndex)];
    
    _imageViewExpress = [UIImageView initImageView:@"1"];
    [_viewExpress addSubview:_imageViewExpress];
    [_imageViewExpress setFrame:RectWithScale(CGRectMake(30, 50, 90, 90), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelExpressState = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:rgb(38, 152, 217) title:@"到达【河南省邮件处理中心】（经转）"];
    _labelExpressState.lineBreakMode = NSLineBreakByCharWrapping;
    _labelExpressState.backgroundColor = [UIColor clearColor];
    [_viewExpress addSubview:_labelExpressState];
    [_labelExpressState setFrame:RectWithScale(CGRectMake(150, 50, 780, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelExpressTime = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:rgb(152, 152, 152) title:@"2020-01-04 09:30:00"];
    _labelExpressTime.lineBreakMode = NSLineBreakByCharWrapping;
    _labelExpressTime.backgroundColor = [UIColor clearColor];
    [_viewExpress addSubview:_labelExpressTime];
    [_labelExpressTime setFrame:RectWithScale(CGRectMake(150, 100, 780, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    _imageViewExpressArrow = [UIImageView initImageView:@"1"];
    [_viewExpress addSubview:_imageViewExpressArrow];
    [_imageViewExpressArrow setFrame:RectWithScale(CGRectMake(1020, 75, 30, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    
    _viewDelivery = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewHeader addSubview:_viewDelivery];
    [_viewDelivery setFrame:RectWithScale(CGRectMake(0, 560-190, 1080, 230), GPCommonLayoutScaleSizeWidthIndex)];
    
    _imageViewDelivery = [UIImageView initImageView:@"地址商品详情"];
    [_viewDelivery addSubview:_imageViewDelivery];
    [_imageViewDelivery setFrame:RectWithScale(CGRectMake(30, 75, 60, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelDeliveryName = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:@"葛朋"];
    _labelDeliveryName.lineBreakMode = NSLineBreakByCharWrapping;
    _labelDeliveryName.backgroundColor = [UIColor clearColor];
    [_viewDelivery addSubview:_labelDeliveryName];
    [_labelDeliveryName setFrame:RectWithScale(CGRectMake(150, 50, 300, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelDeliveryMobile = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:rgb(152, 152, 152) title:@"17777868624"];
    _labelDeliveryMobile.lineBreakMode = NSLineBreakByCharWrapping;
    _labelDeliveryMobile.backgroundColor = [UIColor clearColor];
    [_viewDelivery addSubview:_labelDeliveryMobile];
    [_labelDeliveryMobile setFrame:RectWithScale(CGRectMake(450, 50, 600, 40), GPCommonLayoutScaleSizeWidthIndex)];
    _labelDeliveryMobile.textAlignment = NSTextAlignmentRight;
    
    _labelDeliveryAddress = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:@"河北省 廊坊市 三河市"];
    _labelDeliveryAddress.lineBreakMode = NSLineBreakByCharWrapping;
    _labelDeliveryAddress.backgroundColor = [UIColor clearColor];
    [_viewDelivery addSubview:_labelDeliveryAddress];
    [_labelDeliveryAddress setFrame:RectWithScale(CGRectMake(150, 100, 780, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    _viewFooter = [UIView initViewBackColor:[UIColor whiteColor]];
    [self.view addSubview:_viewFooter];
    [_viewFooter setFrame:RectWithScale(CGRectMake(0, 830, 1080, 400), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelOrderIntro = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:@"订单信息"];
    _labelOrderIntro.lineBreakMode = NSLineBreakByCharWrapping;
    _labelOrderIntro.backgroundColor = [UIColor clearColor];
    [_viewFooter addSubview:_labelOrderIntro];
    [_labelOrderIntro setFrame:RectWithScale(CGRectMake(40, 40, 1000, 50), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelOrderIDIntro = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor grayColor] title:@"订单编号:"];
    _labelOrderIDIntro.lineBreakMode = NSLineBreakByCharWrapping;
    _labelOrderIDIntro.backgroundColor = [UIColor clearColor];
    [_viewFooter addSubview:_labelOrderIDIntro];
    [_labelOrderIDIntro setFrame:RectWithScale(CGRectMake(40, 120, 260, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelOrderID = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor grayColor] title:@"1234567"];
    _labelOrderID.lineBreakMode = NSLineBreakByCharWrapping;
    _labelOrderID.backgroundColor = [UIColor clearColor];
    [_viewFooter addSubview:_labelOrderID];
    [_labelOrderID setFrame:RectWithScale(CGRectMake(300, 120, 700, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelOrderCreateTimeIntro = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor grayColor] title:@"订单创建时间:"];
    _labelOrderCreateTimeIntro.lineBreakMode = NSLineBreakByCharWrapping;
    _labelOrderCreateTimeIntro.backgroundColor = [UIColor clearColor];
    [_viewFooter addSubview:_labelOrderCreateTimeIntro];
    [_labelOrderCreateTimeIntro setFrame:RectWithScale(CGRectMake(40, 200, 260, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelOrderCreateTime = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor grayColor] title:@"2020-01-04 09:30:00"];
    _labelOrderCreateTime.lineBreakMode = NSLineBreakByCharWrapping;
    _labelOrderCreateTime.backgroundColor = [UIColor clearColor];
    [_viewFooter addSubview:_labelOrderCreateTime];
    [_labelOrderCreateTime setFrame:RectWithScale(CGRectMake(300, 200, 700, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelOrderPriceIntro = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor grayColor] title:@"订单总价:"];
    _labelOrderPriceIntro.lineBreakMode = NSLineBreakByCharWrapping;
    _labelOrderPriceIntro.backgroundColor = [UIColor clearColor];
    [_viewFooter addSubview:_labelOrderPriceIntro];
    [_labelOrderPriceIntro setFrame:RectWithScale(CGRectMake(40, 280, 260, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelOrderPrice = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor grayColor] title:@"¥ 200"];
    _labelOrderPrice.lineBreakMode = NSLineBreakByCharWrapping;
    _labelOrderPrice.backgroundColor = [UIColor clearColor];
    [_viewFooter addSubview:_labelOrderPrice];
    [_labelOrderPrice setFrame:RectWithScale(CGRectMake(300, 280, 700, 80), GPCommonLayoutScaleSizeWidthIndex)];
    
    
    _bottomView = [[OrderDetailBottomView alloc]initWithFrame:CGRectMake(0, GPScreenHeight - kBottomHeightShoppingCart, GPScreenWidth, kBottomHeightShoppingCart)];
    [self.view addSubview:_bottomView];
    
    HPWeakSelf(self);
//    NSArray *arrbtnTitle = @[@"删除订单",@"确认收货",@"取消订单",@"去付款",@"查看物流"];
    _bottomView.btnClick = ^(UIButton * btn) {
        HPStrongSelf(self)
        GPDebugLog(@"btn.tag = %ld",(long)btn.tag);
        switch (btn.tag - 100) {
            case 0:
            {
                [self buttonClickDelete];
            }
                break;
            case 1:
            {
                [self buttonClickConfirmReceive];
            }
                break;
            case 2:
            {
                [self buttonClickCancel];
            }
                break;
            case 3:
            {
                [self buttonClickToPay];
            }
                break;
            case 4:
            {
                ExpressViewController *vc = [[ExpressViewController alloc]init];
                [vc setExpress_code:self->_string_express_code Shipping_code:self->_string_shipping_code Phone:self->_string_phone];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    
    _tableViewOrder = [[UITableView alloc] initWithFrame:CGRectMake(0, - kStatusBarHeight, GPScreenWidth, GPScreenHeight - kBottomHeightShoppingCart + kStatusBarHeight) style:UITableViewStylePlain];
    _tableViewOrder.dataSource = self;
    _tableViewOrder.delegate = self;
    _tableViewOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewOrder.showsVerticalScrollIndicator = NO;
    _tableViewOrder.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableViewOrder];
    [_tableViewOrder registerClass:[OrderDetailTableViewCell class] forCellReuseIdentifier:@"OrderDetailTableViewCell"];
    [_tableViewOrder setBackgroundColor:rgb(242, 242, 242)];
    
    _tableViewOrder.tableHeaderView = _viewHeader;
    _tableViewOrder.tableFooterView = _viewFooter;
    
    [self setupRefreshWithScrollView:_tableViewOrder];
    
    CGFloat _viewh = 20;
    //设置滚动范围偏移200
    _tableViewOrder.scrollIndicatorInsets = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    //设置内容范围偏移200
    _tableViewOrder.contentInset = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    
    [_tableViewOrder setContentOffset:CGPointMake(0, -_viewh)];
    
    
    UIImage *tmpImage = GetImage(@"白色左箭头");
    CGSize newSize = CGSizeMake(14, 24);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    [tmpImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:CGRectMake(20, kStatusBarHeight +10, 14, 24)];
    [navButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navButton setImage:backButtonImage forState:UIControlStateNormal];
    navButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [navButton addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navButton];
    [self.view bringSubviewToFront:navButton];
    
    CGRect titleLabelRect = CGRectMake(90, kStatusBarHeight + 7, self.view.frame.size.width-180, 30);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelRect];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = FontMediumWithSize(18);
    titleLabel.numberOfLines = 1;
    titleLabel.text = @"订单详情";
    titleLabel.clipsToBounds = YES;
    [self.view addSubview:titleLabel];
    [self.view bringSubviewToFront:titleLabel];
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    
}

-(UIImage*)convertViewToImage:(UIView*)v
{
    CGSize s = v.bounds.size;// 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需 要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s,YES, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
    
    CGFloat _viewh = _viewHeader.height;
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
    [HPNetManager POSTWithUrlString:HostMemberorderorder_info isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_string_order_id,@"order_id", nil] successBlock:^(id response) {
        //        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            
            self->_dicDataSource = response[@"result"];
            [self updateInterfaceWithDic:response[@"result"]];
            
            self->_string_express_code = response[@"result"][@"express_info"][@"express_code"];
            self->_string_shipping_code = response[@"result"][@"shipping_code"];
            self->_string_phone = response[@"result"][@"extend_order_common"][@"reciver_info"][@"phone"];
            
            
            if ([[NSArray arrayWithArray:response[@"result"][@"goods_list"]] count]) {
                [self->_arrayDataSource removeAllObjects];
                [self->_tableViewOrder reloadData];
                
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"goods_list"]]];
                [self->_tableViewOrder reloadData];
                [self->_tableViewOrder.mj_header endRefreshing];
            }
            else
            {
                [self->_tableViewOrder.mj_header endRefreshing];
            }
        }
        else
        {
            [self->_tableViewOrder.mj_header endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_tableViewOrder.mj_header endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

//上拉加载更多
- (void)footerRereshing
{
    [HPNetManager POSTWithUrlString:HostMemberorderorder_info isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_string_order_id,@"order_id", nil] successBlock:^(id response) {
        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            
        }
        else
        {
            [self->_tableViewOrder.mj_footer endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_tableViewOrder.mj_footer endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}

-(void)updateInterfaceWithDic:(NSDictionary*)dic
{
    //0:已取消10:未付款;20:已付款;30:已发货;40:已收货;
    NSDictionary *dicorder_state = [NSDictionary dictionaryWithObjectsAndKeys:@"已取消",@"0",@"未付款",@"10",@"已付款",@"20",@"已发货",@"30",@"已收货",@"40", nil];
    NSString *stringorder_state = [NSString stringWithFormat:@"%@",dic[@"order_state"]];
    NSString *stringstate_desc = [NSString stringWithFormat:@"%@",dicorder_state[stringorder_state]];
    [_labelState setText:stringstate_desc];
    
    if ([stringstate_desc isEqualToString:@"未付款"]) {
        [_bottomView setStyle:@"未付款"];
    }else if ([stringstate_desc isEqualToString:@"已付款"]) {
        
        [_tableViewOrder setFrame:CGRectMake(0, - kStatusBarHeight, GPScreenWidth, GPScreenHeight + kStatusBarHeight)];
        [_bottomView setHidden:YES];
    }else if ([stringstate_desc isEqualToString:@"已发货"]) {
        [_bottomView setStyle:@"已发货"];
    }else if ([stringstate_desc isEqualToString:@"已收货"]) {
        [_bottomView setStyle:@"已收货"];
    }else if ([stringstate_desc isEqualToString:@"已取消"]) {
        [_bottomView setStyle:@"已取消"];
    }
    _labelDeliveryMobile.text = [NSString stringWithFormat:@"%@",dic[@"extend_order_common"][@"reciver_info"][@"phone"]];
    _labelDeliveryAddress.text = [NSString stringWithFormat:@"%@",dic[@"extend_order_common"][@"reciver_info"][@"address"]];
    _labelDeliveryName.text = [NSString stringWithFormat:@"%@",dic[@"extend_order_common"][@"reciver_name"]];
    
    NSString *intervalString = [NSString stringWithFormat:@"%@",dic[@"add_time"]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[intervalString doubleValue]+3600*0];// 加上八小时的时间差值
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringadd_time = [dateFormatter stringFromDate:date];
    //GPDebugLog(@"时间戳转换为时间是 %@",stringadd_time);
    
    _labelOrderCreateTime.text = stringadd_time;
    _labelOrderID.text = [NSString stringWithFormat:@"%@",dic[@"order_sn"]];
    _labelOrderPrice.text = [NSString stringWithFormat:@"%@",dic[@"order_amount"]];
}

-(void)buttonClickToPay
{
    NSString *pay_sn = _dicDataSource[@"pay_sn"];
    
    ConfirmOrderToPayViewController *vc = [[ConfirmOrderToPayViewController alloc]init];
    vc.string_pay_sn = pay_sn;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)buttonClickCancel
{
    [HPAlertTools showAlertWith:self title:@"提示信息" message:@"确认取消此订单?" callbackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            NSString *order_id = self->_dicDataSource[@"order_id"];
            [self dealWithOrderByType:@"order_cancel" andOrderID:order_id];
        }else if (btnIndex == 0) {
            
        }
    } cancelButtonTitle:@"容我三思" destructiveButtonTitle:@"我意已决" otherButtonTitles:nil];
}

-(void)buttonClickConfirmReceive
{
    [HPAlertTools showAlertWith:self title:@"提示信息" message:@"确认收货?" callbackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            NSString *order_id = self->_dicDataSource[@"order_id"];
            [self dealWithOrderByType:@"order_receive" andOrderID:order_id];
        }else if (btnIndex == 0) {
            
        }
    } cancelButtonTitle:@"容我三思" destructiveButtonTitle:@"我意已决" otherButtonTitles:nil];
}

-(void)buttonClickDelete
{
    [HPAlertTools showAlertWith:self title:@"提示信息" message:@"确认删除此订单?" callbackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            NSString *order_id = self->_dicDataSource[@"order_id"];
            [self dealWithOrderByType:@"order_delete" andOrderID:order_id];
        }else if (btnIndex == 0) {
            
        }
    } cancelButtonTitle:@"容我三思" destructiveButtonTitle:@"我意已决" otherButtonTitles:nil];
}

- (void)dealWithOrderByType:(NSString *)state_type andOrderID:(NSString *)order_id
{
    [HPNetManager POSTWithUrlString:Hostmemberorderchange_state isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",order_id,@"order_id",state_type,@"state_type", nil] successBlock:^(id response) {
        //        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            [self headerRereshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        
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
    if ([scrollView isEqual:_tableViewOrder]) {
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


#pragma mark    ----UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_arrayDataSource.count) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTableViewCell"];
    
    NSDictionary * dic = _arrayDataSource[indexPath.row];
    GoodsModel *model = [[GoodsModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    cell.goodsModel = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260*GPCommonLayoutScaleSizeWidthIndex;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100*GPCommonLayoutScaleSizeWidthIndex;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0*GPCommonLayoutScaleSizeWidthIndex;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    OrderDetailHeaderView *headerView = [[OrderDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth, 100*GPCommonLayoutScaleSizeWidthIndex)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSString *store_name = _dicDataSource[@"store_name"];
    NSString *state = _dicDataSource[@"state_desc"];
    [headerView setStore_name:store_name andState:state];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter = [[UIView alloc]init];
    [viewFooter setFrame:CGRectMake(0, 0, GPScreenWidth, 0*GPCommonLayoutScaleSizeWidthIndex)];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [viewFooter addSubview:view];
    [view setFrame:CGRectMake(0, 0, GPScreenWidth, 0*GPCommonLayoutScaleSizeWidthIndex)];
    //    [view rounded:10 rectCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)];
    
    return viewFooter;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _arrayDataSource[indexPath.row];
    GoodsModel *goodsModel = [[GoodsModel alloc] init];
    [goodsModel setValuesForKeysWithDictionary:dic];
    
    GoodsViewController *vc = [[GoodsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goods_id = goodsModel.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
