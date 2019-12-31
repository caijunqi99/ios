//
//  AddressListViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/16.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "AddressListViewController.h"

#import "AddressListTableViewCell.h"
#import "NewDeliveryAddressViewController.h"
#import "EditDeliveryAddressViewController.h"

#import "DeliveryAddressModel.h"
@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray      *_arrayDataSource;
}
@property(nonatomic,strong)UIButton             *buttonTemp;

@property(nonatomic,strong)UIScrollView         *scrollViewTemp;
@property(nonatomic,strong)UIView               *viewTemp;
@property(nonatomic,strong)UILabel              *labelTemp;
@property(nonatomic,strong)UIImageView          *imageViewTemp;

@property(nonatomic,strong)UITableView          *tableViewTemp;

@property (nonatomic ,copy) AddOverBlock backBlock;

@end

#define kBottomHeightCommon        (130*GPCommonLayoutScaleSizeWidthIndex)

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    [self headerRereshing];
}

- (instancetype)initWithBlock:(AddOverBlock)block
{
    if (self = [super init]) {
        self.backBlock = block;
        _arrayDataSource = [[NSMutableArray alloc]initWithCapacity:0];
        HPNOTIF_ADD(@"refreshAddressList", refresh);
    }
    return self;
}

-(instancetype)init
{
    if (self = [super init]) {
        _arrayDataSource = [[NSMutableArray alloc]initWithCapacity:0];
        HPNOTIF_ADD(@"refreshAddressList", refresh);
    }
    return self;
}



-(void)dealloc
{
    HPNOTIF_REMV();
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
    [self settingNavTitle:@"收货地址"];
    
    viewSetBackgroundColor(kColorBasic);
    
    [self.view addSubview:self.scrollViewTemp];
    [self.scrollViewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight - kBottomHeightCommon)];
    
    [self.scrollViewTemp addSubview:self.imageViewTemp];
    
    [self.imageViewTemp setFrame:CGRectMake(self.scrollViewTemp.centerX - 20, self.scrollViewTemp.centerY - 200, 40, 40)];
    
    [self.scrollViewTemp addSubview:self.labelTemp];
    [self.labelTemp setFrame:CGRectMake(self.scrollViewTemp.centerX - 50, self.imageViewTemp.bottom + 10, 100, 30)];
    [self.labelTemp setText:@"暂无收货地址"];
    
    [self setupRefreshWithScrollView:self.scrollViewTemp];
    
    [self.scrollViewTemp setHidden:YES];
    
    [self.view addSubview:self.buttonTemp];
    [self.buttonTemp setFrame:CGRectMake(0, GPScreenHeight - kBottomHeightCommon - kNavBarAndStatusBarHeight, GPScreenWidth, kBottomHeightCommon)];
    
    [self.view addSubview:self.tableViewTemp];
    [self.tableViewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight - kBottomHeightCommon)];
    [self.tableViewTemp setHidden:YES];
    
    [self setupRefreshWithScrollView:self.tableViewTemp];
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    
}

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
    if ([buttonName containsString:@"添加收货地址"])
    {
        NewDeliveryAddressViewController *vc = [[NewDeliveryAddressViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)refresh
{
    [self headerRereshing];
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
    [_arrayDataSource removeAllObjects];
    [_tableViewTemp reloadData];
    
    [HPNetManager POSTWithUrlString:HostMemberaddressaddress_list isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"address_list"]] count]) {
                [self.tableViewTemp setHidden:NO];
                [self.scrollViewTemp setHidden:YES];
                
                [self->_arrayDataSource removeAllObjects];
                [self.tableViewTemp reloadData];
                
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"address_list"]]];
                [self.tableViewTemp reloadData];
                [self.tableViewTemp.mj_header endRefreshing];
                [self.scrollViewTemp.mj_header endRefreshing];
            }
            else
            {
                [self.tableViewTemp setHidden:YES];
                [self.scrollViewTemp setHidden:NO];
                [self.tableViewTemp.mj_header endRefreshing];
                [self.scrollViewTemp.mj_header endRefreshing];
            }
        }
        else
        {
            [self.tableViewTemp.mj_header endRefreshing];
            [self.scrollViewTemp.mj_header endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self.tableViewTemp.mj_header endRefreshing];
        [self.scrollViewTemp.mj_header endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

//上拉加载更多
- (void)footerRereshing
{
    [HPNetManager POSTWithUrlString:HostIndexgetCommendGoods isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"address_list"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"address_list"]]];
                [self->_tableViewTemp reloadData];
                [self->_scrollViewTemp.mj_footer endRefreshing];
                [self->_tableViewTemp.mj_footer endRefreshing];
            }
            else
            {
                [self->_scrollViewTemp.mj_footer endRefreshing];
                [self->_tableViewTemp.mj_footer endRefreshing];
            }
        }
        else
        {
            [self->_scrollViewTemp.mj_footer endRefreshing];
            [self->_tableViewTemp.mj_footer endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_scrollViewTemp.mj_footer endRefreshing];
        [self->_tableViewTemp.mj_footer endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentify];
    if(!cell){
        cell = [[AddressListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentify];
    }
    NSDictionary * dic = _arrayDataSource[indexPath.row];
    [dic enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj isEqual:[NSNull null]])
        {
            obj=@"";
            [dic setValue:obj forKey:key];
        }
    }];
    
    DeliveryAddressModel *model = [[DeliveryAddressModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    cell.addressModel = model;
    cell.btnClick = ^(UIButton *btn) {
        //GPDebugLog(@"indexPath.row:%ld",(long)indexPath.row);
        //GPDebugLog(@"btn.tag:%ld",(long)btn.tag);
        EditDeliveryAddressViewController *vc = [[EditDeliveryAddressViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.addressModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.backBlock) {
        NSDictionary * dic = _arrayDataSource[indexPath.row];
        [dic enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
            if([obj isEqual:[NSNull null]])
            {
                obj=@"";
                [dic setValue:obj forKey:key];
            }
        }];
        
        DeliveryAddressModel *model = [[DeliveryAddressModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        self.backBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - lazy load懒加载

-(UIView *)viewTemp
{
    if (!_viewTemp) {
        _viewTemp = [UIView initViewBackColor:[UIColor whiteColor]];
    }
    return _viewTemp;
}

-(UILabel *)labelTemp
{
    if (!_labelTemp) {
        _labelTemp = [UILabel initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:@"this is label"];
        _labelTemp.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTemp.backgroundColor = [UIColor clearColor];
        _labelTemp.textAlignment = NSTextAlignmentCenter;
        _labelTemp.textColor = [UIColor grayColor];
    }
    return _labelTemp;
}

-(UIImageView *)imageViewTemp
{
    if (!_imageViewTemp) {
        _imageViewTemp = [UIImageView initImageView:@"address"];
    }
    return _imageViewTemp;
}

-(UIButton *)buttonTemp
{
    if (!_buttonTemp) {
        
        _buttonTemp = [UIButton initButtonTitleFont:22 titleColor:[UIColor whiteColor] backgroundColor:kColorTheme imageName:@"" titleName:@"添加收货地址"];
        [_buttonTemp addTarget:self tag:11 action:@selector(buttonClick:)];
    }
    return _buttonTemp;
}

-(UIScrollView *)scrollViewTemp
{
    if (!_scrollViewTemp) {
        _scrollViewTemp = [[UIScrollView alloc]init];
        _scrollViewTemp.showsHorizontalScrollIndicator = NO;
        _scrollViewTemp.showsVerticalScrollIndicator = NO;
        _scrollViewTemp.backgroundColor = [UIColor clearColor];
    }
    return _scrollViewTemp;
}

-(UITableView *)tableViewTemp
{
    if (!_tableViewTemp) {
        if (@available(iOS 13.0, *)) {
            _tableViewTemp = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth, 200) style:UITableViewStylePlain];
        } else {
            // Fallback on earlier versions
            _tableViewTemp = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth, 200) style:UITableViewStylePlain];
        }
        _tableViewTemp.showsVerticalScrollIndicator = NO;
        _tableViewTemp.showsHorizontalScrollIndicator = NO;
        _tableViewTemp.dataSource = self;
        _tableViewTemp.delegate = self;
        
        _tableViewTemp.backgroundColor = [UIColor clearColor];
    }
    return _tableViewTemp;
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
