//
//  StoreViewController.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/11.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreCollectionViewCell.h"

@interface StoreViewController ()<SDCycleScrollViewDelegate,CategoryBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIView              *_viewTop;
    UIImageView         *_imageViewStoreImage;
    UIImageView         *_imageViewStoreIcon;
    UIView              *_viewStoreIconShadow;
    
    CategoryBar         *_categoryBar;
    UICollectionView    *_collectionView;
}
// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end
static NSString * const ReuseIdentify  = @"ReuseIdentify";

//ReuseIdentify = @"ReuseIdentify";

@implementation StoreViewController

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
    
    
    viewSetBackgroundColor(kColorBasic);
    
    _viewTop = [[UIView alloc]init];
    [_viewTop setFrame:CGRectMake(0, 0, GPScreenWidth, 400*GPCommonLayoutScaleSizeWidthIndex)];
    _viewTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewTop];

    _imageViewStoreImage = [[UIImageView alloc]init];
    [_imageViewStoreImage setFrame:RectWithScale(CGRectMake(0, 0, 1080, 300), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewStoreImage setImage:defaultImage];
    [_viewTop addSubview:_imageViewStoreImage];
    
    _viewStoreIconShadow = [[UIView alloc]init];
    [_viewStoreIconShadow setFrame:RectWithScale(CGRectMake(30, 210, 180, 180), GPCommonLayoutScaleSizeWidthIndex)];
    _viewStoreIconShadow.backgroundColor = [UIColor whiteColor];
    [_viewStoreIconShadow rounded:5];
    [_viewStoreIconShadow shadow:[UIColor grayColor] opacity:1 radius:5 offset:CGSizeMake(0, 0)];
    [_viewTop addSubview:_viewStoreIconShadow];
    
    _imageViewStoreIcon = [[UIImageView alloc]init];
    [_imageViewStoreIcon setFrame:RectWithScale(CGRectMake(40, 220, 160, 160), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewStoreIcon setImage:defaultImage];
    [_imageViewStoreIcon rounded:5];
    [_viewTop addSubview:_imageViewStoreIcon];
    
    
    _categoryBar = [[CategoryBar alloc] initWithFrame:CGRectMake(0, _viewTop.bottom, GPScreenWidth , 44)];
    _categoryBar.backgroundColor = [UIColor clearColor];
    _categoryBar.delegate = self;
    _categoryBar.lineColor = kColorTheme;
    _categoryBar.itemTitles = @[@"店铺首页",@"全部商品"];
    _categoryBar.font = FontRegularWithSize(13);
    _categoryBar.titleColor = GPHexColor(0xAAAAAA);
    _categoryBar.fontSelected = FontMediumWithSize(16);
    _categoryBar.titleColorSelected = kColorTheme;
    _categoryBar.buttonColor = GPHexColor(0xF5F5F5);
    _categoryBar.buttonColorSelected = GPHexColor(0xFFFFFF);
    _categoryBar.buttonInset = 20;
    _categoryBar.isVertical = NO;
    _categoryBar.isSpread = YES;
    [_categoryBar updateData];
    _categoryBar.currentItemIndex = 0;
    [self.view addSubview:_categoryBar];
    
    
    
    // 高度 = 屏幕高度 - 导航栏高度 - 频道视图高度44
    CGFloat h = GPScreenHeight - kNavBarAndStatusBarHeight -_categoryBar.bottom - 10;
    CGRect frame = CGRectMake(0, _categoryBar.bottom + 10, GPScreenWidth, h);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[StoreCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentify];
    
    // 设置cell的大小和细节
    flowLayout.itemSize = _collectionView.bounds.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    
    [self.view addSubview:_collectionView];
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    
}

-(void)netRequest
{
    [HPNetManager POSTWithUrlString:HostStorestore_info isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_store_id,@"store_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            NSDictionary *dicStoreInfo = response[@"result"][@"store_info"];
            [self settingNavTitle:dicStoreInfo[@"store_name"] WithNavTitleColor:[UIColor blackColor]];
            [self->_imageViewStoreImage sd_setImageWithURL:URL(dicStoreInfo[@"mb_title_img"]) placeholderImage:defaultImage];
            [self->_imageViewStoreIcon sd_setImageWithURL:URL(dicStoreInfo[@"store_avatar"]) placeholderImage:defaultImage];
            
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
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
        [_collectionView registerClass:[StoreCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    //    https://blog.csdn.net/autom_lishun/article/details/85061258
    
    StoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.store_id = _store_id;
    cell.storeContentType = indexPath.row+1;
    
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
