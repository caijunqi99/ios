//
//  ConfirmOrderViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/20.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ConfirmOrderViewController.h"

#import "ConfirmOrderToPayViewController.h"

#import "ShoppingCartModel.h"
#import "ConfirmOrderTableViewCell.h"
#import "ConfirmOrderHeaderView.h"
#import "ConfirmOrderBottomView.h"

#import "AddressListViewController.h"
#import "DeliveryAddressModel.h"

#define kBottomHeightShoppingCart        (180*GPCommonLayoutScaleSizeWidthIndex)
@interface ConfirmOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    
    /**
    *购买商品--第二步，生成订单  生成订单之后直接调用第三步
    *https://shop.bayi-shop.com/index.php/mobile/Memberbuy/buy_step2
    *cart_id   商品  ----    ID|数量,ID|数量,ID|数量
    *ifcart    默认为空，为直接购物，1为从购物车
    *key       token
    *address_id    收货地址ID
    *vat_hash  从第一步接口得到的hash
    *pay_name  支付类型    online
    *invoice_id    默认为0，发票ID，无发票设置
    *voucher   0|店铺ID|0
    *offpay_hash           可以为空
    *offpay_hash_batch     可以为空
    */
    
    NSString *_string_cart_id;
    NSString *_string_ifcart;
    
    NSString *_string_key;
    
    NSString *_string_address_id;
    NSString *_string_vat_hash;
    NSString *_string_pay_name;
    NSString *_string_invoice_id;
    NSString *_string_voucher;
    NSString *_string_offpay_hash;
    NSString *_string_offpay_hash_batch;
    
    NSString *_string_pay_sn;
    
    
    NSMutableArray      *_arrayDataSource;
}
@property (nonatomic, strong) UIView *viewTop;
@property (nonatomic, strong) UIView *viewAddress;
@property (nonatomic, strong) UIImageView *imageViewAddress;
@property (nonatomic, strong) UILabel *labelAddress;
@property (nonatomic, strong) UILabel *labelRealname;
@property (nonatomic, strong) UILabel *labelMobile;
@property (nonatomic, strong) UIImageView *imageViewArrow;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<StoreModel *> *storeArray;
@property (nonatomic, strong) ConfirmOrderBottomView *bottomView;

@property (nonatomic, strong) DeliveryAddressModel *deliveryAddressModelSelected;
/**
 选中的数组
 */
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation ConfirmOrderViewController

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
    [self settingNavTitle:@"确认订单" WithNavTitleColor:[UIColor blackColor]];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.viewTop = [UIView initViewBackColor:[UIColor clearColor]];
    [self.viewTop setFrame:RectWithScale(CGRectMake(0, 0, 980, 270), GPCommonLayoutScaleSizeWidthIndex)];
    [self.view addSubview:self.viewTop];
    
    self.viewAddress = [UIView initViewBackColor:[UIColor whiteColor]];
    [self.viewAddress setFrame:RectWithScale(CGRectMake(0, 40, 980, 190), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewTop addSubview:self.viewAddress];
    [self.viewAddress rounded:5];
    
    
    [self.viewAddress setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.viewAddress addGestureRecognizer:tap];
    
    
    self.imageViewAddress = [UIImageView initImageView:@"地址购物车"];
    [self.imageViewAddress setFrame:RectWithScale(CGRectMake(20, 60, 70, 70), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewAddress addSubview:self.imageViewAddress];
    
    self.imageViewArrow = [UIImageView initImageView:@"黑色右箭头"];
    [self.imageViewArrow setFrame:RectWithScale(CGRectMake(930, 75, 20, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewAddress addSubview:self.imageViewArrow];
    
    
    self.labelAddress = [UILabel initLabelTextFont:FontMediumWithSize(16) textColor:[UIColor blackColor] title:@"请选择地址"];
    [self.labelAddress setFrame:RectWithScale(CGRectMake(120, 45, 800, 45), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewAddress addSubview:self.labelAddress];
    
    
    self.labelRealname = [UILabel initLabelTextFont:FontMediumWithSize(16) textColor:[UIColor grayColor] title:@""];
    [self.labelRealname setFrame:RectWithScale(CGRectMake(120, 100, 200, 45), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewAddress addSubview:self.labelRealname];
    
    
    self.labelMobile = [UILabel initLabelTextFont:FontMediumWithSize(16) textColor:kColorTheme title:@""];
    [self.labelMobile setFrame:RectWithScale(CGRectMake(330, 100, 670, 45), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewAddress addSubview:self.labelMobile];
    
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(50*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, GPScreenHeight - kNavBarAndStatusBarHeight - 0*GPCommonLayoutScaleSizeWidthIndex - kBottomHeightShoppingCart) style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:self.viewTop];
    
    [self.tableView registerClass:[ConfirmOrderTableViewCell class] forCellReuseIdentifier:@"ConfirmOrderTableViewCell"];
    
    [self setupRefreshWithScrollView:self.tableView];
    
    CGFloat _viewh = 0;
    //设置滚动范围偏移200
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    //设置内容范围偏移200
    self.tableView.contentInset = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    
    [self.tableView setContentOffset:CGPointMake(0, -_viewh)];
    
    self.bottomView = [[ConfirmOrderBottomView alloc]initWithFrame:CGRectMake(0, GPScreenHeight - kNavBarAndStatusBarHeight - kBottomHeightShoppingCart, GPScreenWidth, kBottomHeightShoppingCart)];
    [self.view addSubview:self.bottomView];
    
    HPWeak;
    self.bottomView.AccountBlock = ^{
        [weakSelf netRequest];
    };
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCart_id:(NSString *)cart_id andIfcart:(NSString *)ifcart
{
    _string_cart_id = cart_id;
    _string_ifcart = ifcart;
}

-(void)tapClick:(UIGestureRecognizer*)tap
{
    if (tap.view == self.viewAddress) {
        AddressListViewController *vc = [[AddressListViewController alloc]initWithBlock:^(id  _Nonnull obj) {
            
            DeliveryAddressModel *model = (DeliveryAddressModel*)obj;
            
            self.deliveryAddressModelSelected = model;
            
            [self.labelAddress setText:model.address_detail];
            [self.labelRealname setText:model.address_realname];
            [self.labelMobile setText:model.address_mob_phone];
        }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
    
    CGFloat _viewh = 20;
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

- (NSMutableArray *)storeArray {
    if (!_storeArray) {
        self.storeArray = [NSMutableArray new];
    }
    return _storeArray;
}

//下拉刷新
- (void)headerRereshing
{
    [self.storeArray removeAllObjects];
    [self.tableView reloadData];
    
    [HPNetManager POSTWithUrlString:HostMemberbuybuy_step1 isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_string_cart_id,@"cart_id",_string_ifcart,@"ifcart", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            
            [self.storeArray removeAllObjects];
            [self.tableView reloadData];
            
            NSArray *dataArray = [NSArray arrayWithArray:response[@"result"][@"store_cart_list_api"]];
            self->_string_vat_hash = response[@"result"][@"vat_hash"];
            
            NSDictionary *dicAddress = response[@"result"][@"address_info"];
            DeliveryAddressModel *model = [[DeliveryAddressModel alloc]init];
            [model setValuesForKeysWithDictionary:dicAddress];
            
            self.deliveryAddressModelSelected = model;
            
            [self.labelAddress setText:model.address_detail];
            [self.labelRealname setText:model.address_realname];
            [self.labelMobile setText:model.address_mob_phone];
            
            [self.bottomView.labelTotalPrice setText:[NSString stringWithFormat:@"共计 ¥ %@",response[@"result"][@"order_amount"]]];
            
            self->_string_vat_hash = response[@"result"][@"vat_hash"];
            self->_string_pay_name = @"online";
            self->_string_invoice_id = @"0";
            self->_string_voucher = @"0|1|0";
            self->_string_offpay_hash = @"";
            self->_string_offpay_hash_batch = @"";
            
            
            if (dataArray.count) {
                for (NSDictionary *dic in dataArray) {
                    StoreModel *model = [[StoreModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.storeArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self->_tableView.mj_header endRefreshing];
                });
            }else {
                //加载数据为空时的展示
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
    //这里加入的是网络请求，带上相关参数，利用网络工具进行请求。我这里没有网络就模拟一下数据吧。
    //网络不管请求成功还是失败都要结束更新。
    
    //利用延时函数模拟网络加载
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self->_tableView.mj_footer endRefreshing];
    });
}

-(void)netRequest
{
    _string_address_id = self.deliveryAddressModelSelected.address_id;
    
    [HPNetManager POSTWithUrlString:HostMemberbuybuy_step2 isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_string_cart_id,@"cart_id",_string_ifcart,@"ifcart",_string_address_id,@"address_id",_string_vat_hash,@"vat_hash",_string_pay_name,@"pay_name",_string_invoice_id,@"invoice_id",_string_voucher,@"voucher",_string_offpay_hash,@"offpay_hash",_string_offpay_hash_batch,@"offpay_hash_batch", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            
            self->_string_pay_sn = response[@"result"][@"pay_sn"];
            
            ConfirmOrderToPayViewController *vc = [[ConfirmOrderToPayViewController alloc]init];
            vc.string_pay_sn = response[@"result"][@"pay_sn"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {

    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
    
    
    
}

#pragma mark    ----UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.storeArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    StoreModel *storeModel = self.storeArray[section];
    return storeModel.goodsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConfirmOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderTableViewCell"];
    StoreModel *storeModel = self.storeArray[indexPath.section];
    GoodsModel *goodsModel = storeModel.goodsArray[indexPath.row];
    cell.goodsModel = goodsModel;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260*GPCommonLayoutScaleSizeWidthIndex;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100*GPCommonLayoutScaleSizeWidthIndex;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == ([self.storeArray count]-1)) {
//        return 200*GPCommonLayoutScaleSizeWidthIndex;
//    }
    return 100*GPCommonLayoutScaleSizeWidthIndex;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ConfirmOrderHeaderView *headerView = [[ConfirmOrderHeaderView alloc]initWithFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    StoreModel *storeModel = self.storeArray[section];
    headerView.storeModel = storeModel;
    
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 50*GPCommonLayoutScaleSizeWidthIndex)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 50*GPCommonLayoutScaleSizeWidthIndex)];
    view.backgroundColor = [UIColor whiteColor];
    [view rounded:10 rectCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)];
    [viewFooter addSubview:view];
//    if (section == ([self.storeArray count]-1)) {
//        UILabel *labelBottom = [[UILabel alloc]initWithFrame:CGRectMake(0, 50*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 150*GPCommonLayoutScaleSizeWidthIndex)];
//        labelBottom.textColor = [UIColor grayColor];
//        labelBottom.text = @"到底了,再去选点心仪的商品吧";
//        labelBottom.textAlignment = NSTextAlignmentCenter;
//        labelBottom.font = FontRegularWithSize(12);
//        [viewFooter addSubview:labelBottom];
//    }
    return viewFooter;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreModel *storeModel = self.storeArray[indexPath.section];
    GoodsModel *goodsModel = storeModel.goodsArray[indexPath.row];
    
    GoodsViewController *vc = [[GoodsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goods_id = goodsModel.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
