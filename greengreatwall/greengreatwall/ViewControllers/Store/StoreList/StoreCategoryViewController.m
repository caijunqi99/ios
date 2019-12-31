//
//  StoreCategoryViewController.m
//  
//
//  Created by 葛朋 on 2019/11/20.
//

#import "StoreCategoryViewController.h"
#import "StoreCategoryCollectionViewCell.h"
@interface StoreCategoryViewController ()<CategoryBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
{
    CategoryBar         *_categoryBar;
    UICollectionView    *_collectionView;
    
    NSMutableArray                  *_arrayTitles;
    NSMutableArray                  *_arrayDataSource;
}
// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

static NSString * const ReuseIdentify  = @"ReuseIdentify";
//ReuseIdentify = @"ReuseIdentify";
@implementation StoreCategoryViewController

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
        self.cellDic = [[NSMutableDictionary alloc] init];
        _arrayTitles = [NSMutableArray arrayWithArray:@[@"推荐",@"草药",@"副食",@"坚果",@"菌类",@"粮油",@"肉类",@"蔬菜",@"水产",@"水果",@"种苗",@"种子"]];
        
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)configInterface
{
    
    viewSetBackgroundColor(kColorViewBackground);
    
    _categoryBar = [[CategoryBar alloc] initWithFrame:CGRectMake(0, 0, GPScreenWidth , 20)];
    _categoryBar.backgroundColor = [UIColor clearColor];
    _categoryBar.delegate = self;
    _categoryBar.lineColor = [UIColor clearColor];
    _categoryBar.itemTitles = _arrayTitles;
        
    _categoryBar.font = FontRegularWithSize(12);
    _categoryBar.titleColor = rgb(211, 211, 211);
    _categoryBar.fontSelected = FontMediumWithSize(16);
    _categoryBar.titleColorSelected = rgb(0, 185, 142);
    _categoryBar.buttonColor = GPHexColor(0xF5F5F5);
    _categoryBar.buttonColorSelected = GPHexColor(0xFFFFFF);
    _categoryBar.buttonInset = 10;
    _categoryBar.isVertical = NO;
    _categoryBar.isSpread = NO;
    [_categoryBar updateData];
    _categoryBar.currentItemIndex = 0;
    [self.view addSubview:_categoryBar];
    
    
    // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
    CGFloat h = GPScreenHeight - kTabBarHeight - 70 - _categoryBar.height - 10 - kStatusBarHeight;
    CGRect frame = CGRectMake(0, _categoryBar.bottom+10, GPScreenWidth, h);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[StoreCategoryCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentify];
    
    // 设置cell的大小和细节
    flowLayout.itemSize = _collectionView.bounds.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    
    [self.view addSubview:_collectionView];
}

-(void)leftClick
{
    
}

-(void)rightClick
{
    
}

-(void)updateCategoryBar
{
    _arrayTitles = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in _arrayDataSource) {
        [_arrayTitles addObject:dic[@"storeclass_name"]];
    }
    
    _categoryBar.itemTitles = _arrayTitles;
    [_categoryBar updateData];
    [_collectionView reloadData];
}

-(void)netRequest
{
    [HPNetManager GETWithUrlString:HostStorelistgetStoreClassList isNeedCache:NO parameters:nil successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            if ([NSArray arrayWithArray:response[@"result"]].count) {
                self->_arrayDataSource = [NSMutableArray arrayWithArray:response[@"result"]];
                [self updateCategoryBar];
                
            }
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

#pragma mark - UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchViewController *scVC = [[SearchViewController alloc]init];
    scVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scVC animated:YES];
    return NO;
}

- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex
{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", ReuseIdentify, [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [_collectionView registerClass:[StoreCategoryCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    //    https://blog.csdn.net/autom_lishun/article/details/85061258
    
    StoreCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    cell.storeCate_id = _arrayDataSource[indexPath.row][@"storeclass_id"];
    
    
    
    // 如果不加入响应者链，则无法利用NavController进行Push/Pop等操作。
    if (cell.contentVC) {
        [self addChildViewController:(UIViewController *)cell.contentVC];
    }
    
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrayDataSource.count;
}

#pragma mark - UICollectionViewDelegate
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
    
    _categoryBar.currentItemIndex = index;
}

@end
