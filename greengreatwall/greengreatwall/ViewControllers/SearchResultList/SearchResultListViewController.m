//
//  SearchResultListViewController.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/10/24.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "SearchResultListViewController.h"
#import "SearchResultListCollectionViewCell.h"

#import "XDDataBase.h"
@interface SearchResultListViewController ()<XDSearchBarViewDelegate,CategoryBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate>
{
    CategoryBar         *_categoryBar;
    UICollectionView    *_collectionView;
}
// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;
@property (nonatomic,strong) NavTitleSearchBar *searchBar;
@end

static NSString * const ReuseIdentify  = @"ReuseIdentify";
//ReuseIdentify = @"ReuseIdentify";
@implementation SearchResultListViewController

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
        _gc_id = @"";
        _keyword = @"";
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
    _searchBar.text = _keyword;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)configInterface
{
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    [self setupSearchBar];
    
    viewSetBackgroundColor(kColorBasic);
    
    _categoryBar = [[CategoryBar alloc] initWithFrame:CGRectMake(0, 0, GPScreenWidth , 44)];
    _categoryBar.backgroundColor = [UIColor clearColor];
    _categoryBar.delegate = self;
    _categoryBar.lineColor = GPHexColor(0xFEB163);
    _categoryBar.itemTitles = @[@"综合",@"销量",@"价格"];
    _categoryBar.font = FontRegularWithSize(13);
    _categoryBar.titleColor = GPHexColor(0xAAAAAA);
    _categoryBar.fontSelected = FontMediumWithSize(16);
    _categoryBar.titleColorSelected = kColorFontMedium;
    _categoryBar.buttonColor = GPHexColor(0xF5F5F5);
    _categoryBar.buttonColorSelected = GPHexColor(0xFFFFFF);
    _categoryBar.buttonInset = 20;
    _categoryBar.isVertical = NO;
    _categoryBar.isSpread = YES;
    [_categoryBar updateData];
    _categoryBar.currentItemIndex = 0;
    [self.view addSubview:_categoryBar];
    
    
    
    // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
    CGFloat h = GPScreenHeight - kNavBarAndStatusBarHeight -_categoryBar.height ;
    CGRect frame = CGRectMake(0, _categoryBar.bottom, GPScreenWidth, h);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[SearchResultListCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentify];
    
    // 设置cell的大小和细节
    flowLayout.itemSize = _collectionView.bounds.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    
    [self.view addSubview:_collectionView];
}

#pragma mark -
- (void)setupSearchBar {
    
    //添加搜索框
    UIView *wrapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth -  44 - 40, 32)];
    
    _searchBar = [[NavTitleSearchBar alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth -  44 - 40, 32)];
    _searchBar.searchDelegate = self;
    _searchBar.placeholder = @"搜索商品";
    _searchBar.backgroundColor = rgb(244, 244, 244);
    [wrapView addSubview:_searchBar];
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:wrapView];
    self.navigationItem.rightBarButtonItems = @[item];
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    
}

-(void)setKeyword:(NSString *)keyword
{
    _keyword = keyword;
    _searchBar.text = keyword;
    [_collectionView reloadData];
}

-(void)setGc_id:(NSString *)gc_id
{
    _gc_id = gc_id;
    [_collectionView reloadData];
}

#pragma mark -XDSearchBarViewDelegate

-(BOOL)XDSearchBarViewShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(void)XDSearchBarViewShouldReturn:(NSString *)keyword
{
    if (keyword.length) {
        _keyword = keyword;
        [[XDDataBase sharedXDDataBase] addSearchRecordText:_keyword];
        [_collectionView reloadData];
    }
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
        [_collectionView registerClass:[SearchResultListCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    //    https://blog.csdn.net/autom_lishun/article/details/85061258
    
    SearchResultListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell setGc_id:_gc_id andKeyword:_keyword andOrderType:indexPath.row+1];
    // 如果不加入响应者链，则无法利用NavController进行Push/Pop等操作。
    if (cell.contentVC) {
        [self addChildViewController:(UIViewController *)cell.contentVC];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _categoryBar.itemTitles.count;
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
