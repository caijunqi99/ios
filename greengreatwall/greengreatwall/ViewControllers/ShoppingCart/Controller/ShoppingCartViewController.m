//
//  ShoppingCartViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/3.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ShoppingCartViewController.h"

#import "ShoppingCartModel.h"
#import "ShoppingCartTableViewCell.h"
#import "ShoppingCartHeaderView.h"
#import "ShoppingCartBottomView.h"

#import "ConfirmOrderViewController.h"

#define kBottomHeightShoppingCart        (180*GPCommonLayoutScaleSizeWidthIndex)

@interface ShoppingCartViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    
    NSMutableArray      *_arrayDataSource;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<StoreModel *> *storeArray;
@property (nonatomic, strong) ShoppingCartBottomView *bottomView;
/**
 选中的数组
 */
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
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
        HPNOTIF_ADD(@"orderPaySuccess", headerRereshing);
        HPNOTIF_ADD(@"orderPayCancel", headerRereshing);
        
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
    self.navigationController.navigationBar.hidden = YES;
    [self updateInterface];
    [self headerRereshing];
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
    
    
    [self.bottomView setFrame:CGRectMake(0, GPScreenHeight - kBottomHeightShoppingCart - tabbarHeight - navAndStatusBarHeight, GPScreenWidth, kBottomHeightShoppingCart)];
    [self.tableView setFrame:CGRectMake(50*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, GPScreenHeight - kBottomHeightShoppingCart - tabbarHeight - navAndStatusBarHeight)];
}

#pragma  mark --------------------- UI ------------------
- (void)configInterface
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.bottomView = [[ShoppingCartBottomView alloc]initWithFrame:CGRectMake(0, GPScreenHeight - kNavBarAndStatusBarHeight - kTabBarHeight - kBottomHeightShoppingCart, GPScreenWidth, kBottomHeightShoppingCart)];
    //全选
    [self clickAllSelectBottomView:self.bottomView];
    
    [self.view addSubview:self.bottomView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(50*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, GPScreenHeight - kNavBarAndStatusBarHeight - kTabBarHeight - kBottomHeightShoppingCart) style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[ShoppingCartTableViewCell class] forCellReuseIdentifier:@"ShoppingCartTableViewCell"];
    
    [self setupRefreshWithScrollView:self.tableView];
    
    CGFloat _viewh = 20;
    //设置滚动范围偏移200
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    //设置内容范围偏移200
    self.tableView.contentInset = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    
    [self.tableView setContentOffset:CGPointMake(0, -_viewh)];
    
    
    
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

//下拉刷新
- (void)EditCartWithId:(NSString *)cart_id AndQuantity:(NSString *)quantity
{
    [HPNetManager POSTWithUrlString:Hostmembercartcart_edit_quantity isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",quantity,@"quantity",cart_id,@"cart_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}

//下拉刷新
- (void)headerRereshing
{
    [self.storeArray removeAllObjects];
    [self.tableView reloadData];
    [self.selectArray removeAllObjects];
    [self judgeIsAllSelect];
    [self countPrice];
    
    [HPNetManager POSTWithUrlString:Hostmembercartcart_list isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            
            [self.storeArray removeAllObjects];
            [self.tableView reloadData];
            [self.selectArray removeAllObjects];
            [self judgeIsAllSelect];
            [self countPrice];
            
            NSArray *dataArray = response[@"result"][@"cart_list"];
            if (dataArray.count > 0) {
                for (NSDictionary *dic in dataArray) {
                    StoreModel *model = [[StoreModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.storeArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self->_tableView.mj_header endRefreshing];
                });
                
            } else {
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

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        self.selectArray = [NSMutableArray new];
    }
    return _selectArray;
}
- (NSMutableArray *)storeArray {
    if (!_storeArray) {
        self.storeArray = [NSMutableArray new];
    }
    return _storeArray;
}

#pragma mark ------------------------Action 逻辑处理-----------------------------

/**
 判断分区有没有被全选
 @param section 分区坐标
 */
- (void)judgeIsSelectSection:(NSInteger)section {
    StoreModel *storeModel = self.storeArray[section];
    BOOL isSelectSection = YES;
    //遍历分区商品, 如果有商品的没有被选择, 跳出循环, 说明没有全选
    for (GoodsModel *goodsModel in storeModel.goodsArray) {
        if (goodsModel.isSelect == NO) {
            isSelectSection = NO;
            break;
        }
    }
    //全选了以后, 改变一下选中状态
    ShoppingCartHeaderView *headerView = (ShoppingCartHeaderView *)[self.tableView headerViewForSection:section];
    
//    ShoppingCartHeaderView *headerView = (ShoppingCartHeaderView *)[self tableView:self.tableView viewForHeaderInSection:section];
    
    headerView.isClick = isSelectSection;
    storeModel.isSelect = isSelectSection;
//    [self.tableView reloadData];
}

/**
 是否全选
 */
- (void)judgeIsAllSelect {
    NSInteger count = 0;
    //先遍历购物车商品, 得到购物车有多少商品
    for (StoreModel *storeModel in self.storeArray) {
        count += storeModel.goodsArray.count;
    }
    //如果购物车总商品数量 等于 选中的商品数量, 即表示全选了
    if ((count == self.selectArray.count)&&(count != 0)) {
        self.bottomView.isClick = YES;
    } else {
        self.bottomView.isClick = NO;
    }
}


/**
 计算价格
 */
- (void)countPrice {
    double totlePrice = 0.0;
    for (GoodsModel *goodsModel in self.selectArray) {
        double price = [goodsModel.goods_price doubleValue];
        totlePrice += price * [goodsModel.goods_num integerValue];
    }
    self.bottomView.labelTotalPrice.text = [NSString stringWithFormat:@"合计 ￥%.2f", totlePrice];
}



#pragma mark  ----------- Action 点击事件 --------------------
/**
 区头点击----选中某个分区/取消选中某个分区
 @param headerView 分区
 @param storeModel 分区模型
 */
- (void)clickSectionHeaderView:(ShoppingCartHeaderView *)headerView andStoreModel:(StoreModel *)storeModel {
    headerView.ClickBlock = ^(BOOL isClick) {
        storeModel.isSelect = isClick;
        
        if (isClick) {//选中
            //GPDebugLog(@"选中");
            for (GoodsModel *goodsModel in storeModel.goodsArray) {
                goodsModel.isSelect = YES;
                if (![self.selectArray containsObject:goodsModel]) {
                    [self.selectArray addObject:goodsModel];
                }
            }
            
        } else {//取消选中
            //GPDebugLog(@"取消选中");
            for (GoodsModel *goodsModel in storeModel.goodsArray) {
                goodsModel.isSelect = NO;
                if ([self.selectArray containsObject:goodsModel]) {
                    [self.selectArray removeObject:goodsModel];
                }
            }
        }
        [self judgeIsAllSelect];
        [self.tableView reloadData];
        [self countPrice];
    };
}


/**
 全选点击---逻辑处理
 @param bottomView 底部的View
 */
- (void)clickAllSelectBottomView:(ShoppingCartBottomView *)bottomView {
    HPWeakSelf(self);
    bottomView.AllClickBlock = ^(BOOL isClick) {
        HPStrongSelf(self);
        for (GoodsModel *goodsModel in self.selectArray) {
            goodsModel.isSelect = NO;
        }
        [self.selectArray removeAllObjects];
        if (isClick) {//选中
            //GPDebugLog(@"全选");
            for (StoreModel *storeModel in self.storeArray) {
                storeModel.isSelect = YES;
                for (GoodsModel *goodsModel in storeModel.goodsArray) {
                    goodsModel.isSelect = YES;
                    [self.selectArray addObject:goodsModel];
                }
            }
        } else {//取消选中
            //GPDebugLog(@"取消全选");
            for (StoreModel *storeModel in self.storeArray) {
                storeModel.isSelect = NO;
            }
        }
        [self.tableView reloadData];
        [self countPrice];
    };
    
    bottomView.AccountBlock = ^{
        //GPDebugLog(@"去结算");
        
        if (self.selectArray.count) {
            NSMutableString *stringCart_id = [NSMutableString stringWithFormat:@""];
            for (GoodsModel *goods in self.selectArray) {
                [stringCart_id appendFormat:@"%@", [NSString stringWithFormat:@"%@|%@,",goods.cart_id,goods.goods_num]];
                [self EditCartWithId:goods.cart_id AndQuantity:goods.goods_num];
            }
            [stringCart_id deleteCharactersInRange:NSMakeRange(stringCart_id.length - 1, 1)];
            
            ConfirmOrderViewController *vc = [[ConfirmOrderViewController alloc]init];
            [vc setCart_id:stringCart_id andIfcart:@"1"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
}

- (void)shoppingCartCellClickAction:(ShoppingCartTableViewCell *)cell
                         storeModel:(StoreModel *)storeModel
                         goodsModel:(GoodsModel *)goodsModel
                          indexPath:(NSIndexPath *)indexPath {
    //选中某一行
    cell.ClickRowBlock = ^(BOOL isClick) {
        goodsModel.isSelect = isClick;
        if (isClick) {//选中
            //GPDebugLog(@"选中");
            [self.selectArray addObject:goodsModel];
        } else {//取消选中
            //GPDebugLog(@"取消选中");
            [self.selectArray removeObject:goodsModel];
        }
        
        [storeModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:goodsModel];
        [self.storeArray replaceObjectAtIndex:indexPath.section withObject:storeModel];
        
        [self judgeIsSelectSection:indexPath.section];
        [self judgeIsAllSelect];
        [self countPrice];
    };
    //加
    cell.AddBlock = ^(UILabel *countLabel) {
        //GPDebugLog(@"%@", countLabel.text);
        goodsModel.goods_num = countLabel.text;
        [storeModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:goodsModel];
        if ([self.selectArray containsObject:goodsModel]) {
            
            [self.selectArray removeObject:goodsModel];
            [self.selectArray addObject:goodsModel];
            [self countPrice];
        }
    };
    //减
    cell.CutBlock = ^(UILabel *countLabel) {
        //GPDebugLog(@"%@", countLabel.text);
        goodsModel.goods_num = countLabel.text;
        [storeModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:goodsModel];
        if ([self.selectArray containsObject:goodsModel]) {
            [self.selectArray removeObject:goodsModel];
            [self.selectArray addObject:goodsModel];
            [self countPrice];
        }
    };
}


/**
 删除某个商品
 @param indexPath 坐标
 */
- (void)deleteGoodsWithIndexPath:(NSIndexPath *)indexPath {
    StoreModel *storeModel = [self.storeArray objectAtIndex:indexPath.section];
    GoodsModel *goodsModel = [storeModel.goodsArray objectAtIndex:indexPath.row];
    
    
    [HPNetManager POSTWithUrlString:Hostmembercartcart_del isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",goodsModel.cart_id,@"cart_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            
            [storeModel.goodsArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            if (storeModel.goodsArray.count == 0) {
                [self.storeArray removeObjectAtIndex:indexPath.section];
            }
            
            if ([self.selectArray containsObject:goodsModel]) {
                [self.selectArray removeObject:goodsModel];
                [self countPrice];
            }
            
            [self judgeIsAllSelect];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {

    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}

#pragma mark  -------------------- 此处模仿网络请求, 加载plist文件内容
- (void)loadingDataForPlist {
    
    [self.storeArray removeAllObjects];
    [self.tableView reloadData];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ShopCarNew" ofType:@"plist"];
    NSDictionary *dataDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    //GPDebugLog(@"%@", dataDic);
    NSArray *dataArray = dataDic[@"data"];
    if (dataArray.count > 0) {
        for (NSDictionary *dic in dataArray) {
            StoreModel *model = [[StoreModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.storeArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } else {
        //加载数据为空时的展示
        
    }
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.storeArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    StoreModel *storeModel = self.storeArray[section];
    return storeModel.goodsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartTableViewCell"];
    StoreModel *storeModel = self.storeArray[indexPath.section];
    GoodsModel *goodsModel = storeModel.goodsArray[indexPath.row];
    cell.goodsModel = goodsModel;
    //把事件的处理分离出去
    [self shoppingCartCellClickAction:cell storeModel:storeModel goodsModel:goodsModel indexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260*GPCommonLayoutScaleSizeWidthIndex;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100*GPCommonLayoutScaleSizeWidthIndex;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == ([self.storeArray count]-1)) {
        return 200*GPCommonLayoutScaleSizeWidthIndex;
    }
    return 100*GPCommonLayoutScaleSizeWidthIndex;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ShoppingCartHeaderView *headerView = [[ShoppingCartHeaderView alloc]initWithFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    StoreModel *storeModel = self.storeArray[section];
    headerView.storeModel = storeModel;
    //分区区头点击事件--- 把事件分离出去
    [self clickSectionHeaderView:headerView andStoreModel:storeModel];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 50*GPCommonLayoutScaleSizeWidthIndex)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 50*GPCommonLayoutScaleSizeWidthIndex)];
    view.backgroundColor = [UIColor whiteColor];
    [view rounded:10 rectCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)];
    [viewFooter addSubview:view];
    if (section == ([self.storeArray count]-1)) {
        UILabel *labelBottom = [[UILabel alloc]initWithFrame:CGRectMake(0, 50*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth - 100*GPCommonLayoutScaleSizeWidthIndex, 150*GPCommonLayoutScaleSizeWidthIndex)];
        labelBottom.textColor = [UIColor grayColor];
        labelBottom.text = @"到底了,再去选点心仪的商品吧";
        labelBottom.textAlignment = NSTextAlignmentCenter;
        labelBottom.font = FontRegularWithSize(12);
        [viewFooter addSubview:labelBottom];
    }
    return viewFooter;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    StoreModel *storeModel = self.storeArray[indexPath.section];
    GoodsModel *goodsModel = storeModel.goodsArray[indexPath.row];
//    goodsModel.isSelect = !goodsModel.isSelect;
    cell.goodsModel = goodsModel;
    //把事件的处理分离出去
    [self shoppingCartCellClickAction:cell storeModel:storeModel goodsModel:goodsModel indexPath:indexPath];
    
    GoodsViewController *vc = [[GoodsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goods_id = goodsModel.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        HPWeakSelf(self);
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            HPStrongSelf(self);
            [self deleteGoodsWithIndexPath:indexPath];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
