//
//  StoreGoodsIndexViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/2.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "StoreGoodsIndexViewController.h"
#import "StoreGoodsIndexCollectionViewCell.h"
#import "GoodsViewController.h"
@interface StoreGoodsIndexViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>
{
    UIView              *_viewTop;
    
    UICollectionView    *_collectionView;
    
    
    NSMutableArray      *_arrayDataSource;
    NSMutableArray      *_arraySliders;
    
    NSString            *_strParameter;
}

// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;
//轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleSV;

@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation StoreGoodsIndexViewController

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
        _arrayDataSource = [[NSMutableArray alloc]initWithCapacity:0];
        _arraySliders = [[NSMutableArray alloc]initWithCapacity:0];
        _strParameter = @"1";
        self.cellDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)configInterface
{
    viewSetBackgroundColor(kColorBasic);
    
    // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
    CGFloat height = GPScreenHeight - kNavBarAndStatusBarHeight - 400*GPCommonLayoutScaleSizeWidthIndex - 30 - 10;
    CGRect frame = CGRectMake(0, 0, GPScreenWidth, height);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[StoreGoodsIndexCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentify];
    
    // 设置cell的大小和细节
    flowLayout.itemSize = CGSizeMake(_collectionView.width/2.0-10, (_collectionView.width/2.0 -10)*(290.0/249.0));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 5.0;
    flowLayout.minimumLineSpacing = 5.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    
    [self.view addSubview:_collectionView];
    
    
    
    
    
    _viewTop = [[UIView alloc]init];
    [_viewTop setFrame:CGRectMake(0, 0, GPScreenWidth, 440*GPCommonLayoutScaleSizeWidthIndex)];
    _viewTop.backgroundColor = [UIColor clearColor];
    [_collectionView addSubview:_viewTop];
    
    
    _cycleSV = [SDCycleScrollView cycleScrollViewWithFrame:_viewTop.bounds delegate:self placeholderImage:defaultImage];
    _cycleSV.autoScrollTimeInterval = 3;
    _cycleSV.backgroundColor = [UIColor clearColor];
    _cycleSV.infiniteLoop = YES;
    _cycleSV.localizationImageNamesGroup = @[@"首页banner",@"首页banner",@"首页banner"];
    _cycleSV.layer.masksToBounds = YES;
    _cycleSV.layer.cornerRadius = 7.0;
    [_viewTop addSubview:_cycleSV];
    
    //    [_viewTop setHeight:(_viewGoods.bottom+GPSpacing)];
    CGFloat _viewh = _cycleSV.bottom;
    [_viewTop setFrame:CGRectMake(0, -_viewh, GPScreenWidth, _viewh)];
    //设置滚动范围偏移200
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    //设置内容范围偏移200
    _collectionView.contentInset = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    
    [self setupRefreshWithScrollView:_collectionView];
}



-(void)netRequest
{
    [_arraySliders removeAllObjects];
    _cycleSV.imageURLStringsGroup = @[];
    
    [HPNetManager POSTWithUrlString:HostStorestore_info isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_store_id,@"store_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            [self->_arraySliders removeAllObjects];
            self->_cycleSV.imageURLStringsGroup = @[];
            [self->_arraySliders addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"store_info"][@"mb_sliders"]]];
            NSMutableArray *arrayImageUrl = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in self->_arraySliders) {
                [arrayImageUrl addObject:dic[@"imgUrl"]];
            }
            self->_cycleSV.imageURLStringsGroup = arrayImageUrl;
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}



-(void)setStore_id:(NSString *)store_id
{
    _store_id = store_id;
    [self headerRereshing];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSInteger i = [_arraySliders[index][@"type"] integerValue];
    NSString *stringlink = _arraySliders[index][@"link"];
    switch (i) {
        case 1:
        {
            if (!IsStringEmptyOrNull(stringlink)) {
                HPBaseWKWebViewController *vc = [[HPBaseWKWebViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.urlStr = stringlink;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2:
        {
            if (!IsStringEmptyOrNull(stringlink)) {
                GoodsViewController *vc = [[GoodsViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.goods_id = stringlink;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
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
    
    CGFloat _viewh = _cycleSV.height;
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
    [_collectionView reloadData];
    [self netRequest];
    
    [HPNetManager POSTWithUrlString:HostStoreGetStoreCommentGoods isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_store_id,@"store_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"rec_goods_list"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"rec_goods_list"]]];
                [self->_collectionView reloadData];
                [self->_collectionView.mj_header endRefreshing];
                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
            }
            else
            {
                [self->_collectionView.mj_header endRefreshing];
            }
        }
        else
        {
            [self->_collectionView.mj_header endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_collectionView.mj_header endRefreshing];
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
        [self->_collectionView.mj_footer endRefreshing];
    });
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", ReuseIdentify, [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [_collectionView registerClass:[StoreGoodsIndexCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    //    https://blog.csdn.net/autom_lishun/article/details/85061258
    
    StoreGoodsIndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.dic = _arrayDataSource[indexPath.row];
    //    cell.backgroundColor = [UIColor RandomColor];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return 20;
    return _arrayDataSource.count;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsViewController *vc = [[GoodsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goods_id = _arrayDataSource[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

/** 手指滑动CollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_collectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

/** 手指点击smallScrollView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / _collectionView.width;
    
}

@end
