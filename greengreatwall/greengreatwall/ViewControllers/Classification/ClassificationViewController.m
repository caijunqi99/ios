//
//  ClassificationViewController.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/10/24.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "ClassificationViewController.h"
#import "ClassificationCollectionViewCell.h"

#import "CategoryBarWithImages.h"


@interface ClassificationViewController ()<XDSearchBarViewDelegate,CategoryBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CategoryBarWithImages           *_categoryBar;
    UICollectionView                *_collectionView;
    
    NSMutableArray                  *_arrayTitles;
    NSMutableArray                  *_arrayItemImageUrlStrings;
    NSMutableArray                  *_arrayDataSource;
}
// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;
@property (nonatomic,strong) NavTitleSearchBar *searchBar;
@end

static NSString * const ReuseIdentify  = @"ReuseIdentify";
//ReuseIdentify = @"ReuseIdentify";
@implementation ClassificationViewController

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
        _arrayItemImageUrlStrings = [NSMutableArray arrayWithArray:@[@"推荐",@"草药",@"副食",@"坚果",@"菌类",@"粮油",@"肉类",@"蔬菜",@"水产",@"水果",@"种苗",@"种子"]];
        
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
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)configInterface
{
    [self setupSearchBar];
    
    viewSetBackgroundColor(kColorBasic);
    
    _categoryBar = [[CategoryBarWithImages alloc] initWithFrame:CGRectMake(0, 0, 100 , GPScreenHeight - kNavBarAndStatusBarHeight - kTabBarHeight)];
    _categoryBar.backgroundColor = [UIColor clearColor];
    _categoryBar.delegate = self;
    _categoryBar.lineColor = GPHexColor(0xFEB163);
    _categoryBar.itemTitles = _arrayTitles;
    
    _categoryBar.arrayItemImageUrlString = _arrayItemImageUrlStrings;
    
    _categoryBar.font = FontRegularWithSize(13);
    _categoryBar.titleColor = GPHexColor(0xAAAAAA);
    _categoryBar.fontSelected = FontMediumWithSize(16);
    _categoryBar.titleColorSelected = kColorFontMedium;
    _categoryBar.buttonColor = GPHexColor(0xF5F5F5);
    _categoryBar.buttonColorSelected = GPHexColor(0xFFFFFF);
    _categoryBar.buttonInset = 20;
    _categoryBar.isVertical = YES;
    _categoryBar.isSpread = NO;
    _categoryBar.buttonHeight = 30;
    [_categoryBar updateData];
    _categoryBar.currentItemIndex = 0;
    [self.view addSubview:_categoryBar];
    
    // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
    CGFloat h = GPScreenHeight - kNavBarAndStatusBarHeight - kTabBarHeight ;
    CGRect frame = CGRectMake(_categoryBar.width, 0, GPScreenWidth - _categoryBar.width, h);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[ClassificationCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentify];
    
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

-(void)netRequest
{
    [HPNetManager GETWithUrlString:HostgoodsclassIndex isNeedCache:NO parameters:nil successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            if ([NSArray arrayWithArray:response[@"result"][@"class_list"]].count) {
                self->_arrayDataSource = [NSMutableArray arrayWithArray:response[@"result"][@"class_list"]];
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

- (void)setupSearchBar
{
    //添加搜索框
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(10,0,GPScreenWidth-20,kNavBarHeight)];
    
    _searchBar = [[NavTitleSearchBar alloc]initWithFrame:CGRectMake(10, 5, GPScreenWidth-40, titleView.height-10)];
    _searchBar.searchDelegate = self;
    _searchBar.placeholder = @"搜索商品";
    _searchBar.backgroundColor = rgb(244, 244, 244);
    [titleView addSubview:_searchBar];
    //Set to titleView
    self.navigationItem.titleView = titleView;
}

-(void)updateCategoryBar
{
    _arrayTitles = [NSMutableArray arrayWithCapacity:0];
    _arrayItemImageUrlStrings = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in _arrayDataSource) {
        [_arrayTitles addObject:dic[@"gc_name"]];
        [_arrayItemImageUrlStrings addObject:dic[@"image"]];
    }
    
    _categoryBar.itemTitles = _arrayTitles;
    _categoryBar.arrayItemImageUrlString = _arrayItemImageUrlStrings;
    [_categoryBar updateData];
    [_collectionView reloadData];
}

#pragma mark - UISearchBarDelegate

#pragma mark -XDSearchBarViewDelegate

-(void)XDSearchBarViewShouldReturn:(NSString *)keyword
{
    
}

-(BOOL)XDSearchBarViewShouldBeginEditing:(UITextField *)textField
{
    SearchViewController *scVC = [[SearchViewController alloc]init];
    scVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scVC animated:YES];
    return NO;
}
#pragma mark - CategoryBarDelegate

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
        [_collectionView registerClass:[ClassificationCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    //    https://blog.csdn.net/autom_lishun/article/details/85061258
    
    ClassificationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.string_gc_id = _arrayDataSource[indexPath.row][@"gc_id"];
    
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
