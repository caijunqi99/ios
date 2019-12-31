//
//  ClassificationContentViewController.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/1.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "ClassificationContentViewController.h"
#import "ClassificationContentCollectionHeader.h"
#import "ClassificationContentCollectionViewCell.h"
#import "SearchResultListViewController.h"

#import "XDDataBase.h"
#import "GoodsViewController.h"


@interface ClassificationContentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>
{
    UIView              *_viewTop;
    
    UICollectionView    *_collectionView;
    
    NSMutableArray      *_arrayDataSource;
    
    NSMutableArray      *_arrayDataSourceAdv;
    
    NSString            *_strParameter;
}
// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;
//轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleSV;

@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation ClassificationContentViewController

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
        self.cellDic = [[NSMutableDictionary alloc] init];
        _arrayDataSource = [[NSMutableArray alloc]initWithCapacity:0];
        _arrayDataSourceAdv = [[NSMutableArray alloc]initWithCapacity:0];
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
    viewSetBackgroundColor(kColorViewBackground);
    
    
    
    // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
    CGFloat h = GPScreenHeight - kNavBarAndStatusBarHeight - kTabBarHeight ;
    CGRect frame = CGRectMake(0, 0, GPScreenWidth-100, h);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[ClassificationContentCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentify];
    
    // 设置cell的大小和细节
    //    flowLayout.itemSize = CGSizeMake(_collectionView.width/2.0-10, (_collectionView.width/2.0 -10)*(290.0/249.0));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 5.0;
    flowLayout.minimumLineSpacing = 5.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    flowLayout.headerReferenceSize = CGSizeMake(_collectionView.width, 30.0f);  //设置headerView大小
    flowLayout.footerReferenceSize = CGSizeMake(_collectionView.width, 0.0f);  // 设置footerView大小
    [_collectionView registerClass:[ClassificationContentCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];  //  一定要设置
    [self.view addSubview:_collectionView];
    
    if (!_viewTop) {
        _viewTop = [[UIView alloc]init];
        [_viewTop setFrame:CGRectMake(0, 0, GPScreenWidth-100, (GPScreenWidth -100- GPSpacing*2)*(75.0/230.0)  + GPSpacing*2)];
        _viewTop.backgroundColor = [UIColor clearColor];
        [_collectionView addSubview:_viewTop];
    }
    
    if (!_cycleSV) {
        UIImage *image = defaultImage;
        _cycleSV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(GPSpacing, GPSpacing, GPScreenWidth-100 - GPSpacing*2, (GPScreenWidth -100- GPSpacing*2)*(75.0/230.0)) delegate:self placeholderImage:image];
        _cycleSV.autoScrollTimeInterval = 3;
        _cycleSV.backgroundColor = [UIColor clearColor];
        _cycleSV.infiniteLoop = YES;
        _cycleSV.localizationImageNamesGroup = @[image,image,image];
        [_viewTop addSubview:_cycleSV];
    }
    
    CGFloat _viewh = _viewTop.height;
    [_viewTop setTop: -_viewh];
    //设置滚动范围偏移200
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    //设置内容范围偏移200
    _collectionView.contentInset = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    
    [_collectionView setContentOffset:CGPointMake(0, -_viewh)];
    
    
    [self setupRefreshWithScrollView:_collectionView];
}


-(void)configViewBusinessWithString_gc_id:(NSString*)string_gc_id
{
    [self headerRereshing];
}

-(void)leftClick
{
    
}

-(void)rightClick
{
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (_arrayDataSourceAdv.count>=index)
    {
        //GPDebugLog(@"index:%ld--\n %@",(long)index,_arrayDataSourceAdv[index][@"goodscn_adv_link"]);
        if (!IsStringEmptyOrNull(_arrayDataSourceAdv[index][@"goodscn_adv_link"])) {
            GoodsViewController *vc = [[GoodsViewController alloc]init];
            vc.goods_id = _arrayDataSourceAdv[index][@"goodscn_adv_link"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
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
    
    CGFloat _viewh = _viewTop.height;
    scrollView.mj_header.ignoredScrollViewContentInsetTop = _viewh + kScrollViewHeaderIgnored;
    
    return;
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
    
    [_arrayDataSourceAdv removeAllObjects];
    _cycleSV.imageURLStringsGroup = @[];
    
    [HPNetManager GETWithUrlString:Hostgoodsclassget_child_all isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_string_gc_id,@"gc_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"][@"class_list"]] count]) {
                
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"class_list"]]];
                [self->_collectionView reloadData];
                
                [self->_arrayDataSourceAdv addObjectsFromArray:response[@"result"][@"adv_list"]];
                
                if (self->_arrayDataSourceAdv.count)
                {
                    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:3];
                    for (NSDictionary *dic in self->_arrayDataSourceAdv) {
                        [arrayTemp addObject:dic[@"goodscn_adv"]];
                    }
                    self->_cycleSV.imageURLStringsGroup = arrayTemp;
                }
                else
                {
                    
                }
                
                [self->_collectionView.mj_header endRefreshing];
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

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
    
    if ([buttonName containsString:@"日常保洁"])
    {
        
    }
    else if([buttonName containsString:@"深度保洁"])
    {
        
    }
}

-(void)setString_gc_id:(NSString *)string_gc_id
{
    _string_gc_id = string_gc_id;
    [self configViewBusinessWithString_gc_id:string_gc_id];
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ClassificationContentCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    headerView.stringTitle = _arrayDataSource[indexPath.section][@"gc_name"];
    return headerView;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    NSArray *arrayChilds = _arrayDataSource[indexPath.row][@"child"];
    //    NSInteger rows = ceilf([arrayChilds count]/3.0);
    
    CGFloat width = (GPScreenWidth - 120)/3.0;
    CGFloat height = width;
    return CGSizeMake(width, height);
}

//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
//https://blog.csdn.net/u011439689/article/details/39551163

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", ReuseIdentify, [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [_collectionView registerClass:[ClassificationContentCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    //    https://blog.csdn.net/autom_lishun/article/details/85061258
    
    ClassificationContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSArray *arrayChild = _arrayDataSource[indexPath.section][@"child"];
    cell.dic = arrayChild[indexPath.row];
    //    cell.backgroundColor = [UIColor RandomColor];
    
    
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return 20;
    NSArray *arrayChild = _arrayDataSource[section][@"child"];
    return arrayChild.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _arrayDataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[XDDataBase sharedXDDataBase] openSearchRecordDataBase];
    [[XDDataBase sharedXDDataBase] addSearchRecordText:_arrayDataSource[indexPath.section][@"child"][indexPath.row][@"gc_name"]];
    
    SearchResultListViewController *vc = [[SearchResultListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
//    vc.keyword = _arrayDataSource[indexPath.section][@"child"][indexPath.row][@"gc_name"];
    vc.gc_id = _arrayDataSource[indexPath.section][@"child"][indexPath.row][@"gc_id"];
    [self.navigationController pushViewController:vc animated:YES];
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
