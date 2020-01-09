//
//  IndexViewController.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/10/24.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "IndexViewController.h"

#import "NavTitleSearchBar.h"

#import "IndexCollectionViewCell.h"

#import "NoticeViewController.h"
#import "StoreViewController.h"
#import "GoodsViewController.h"

#import "SearchResultListViewController.h"

#import "ViewController.h"

#define tagMenu  500
#define tagPromotion  600
#define tagDiscount  700
@interface IndexViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,XDSearchBarViewDelegate,SDCycleScrollViewDelegate>
{
    UIView              *_viewTop;
    UIView              *_viewClass;
    UIButton            *_buttonMenu[10];
    UILabel             *_labelClass[10];
    
    UIView              *_viewAds;
    UIView              *_viewGoods;
    
    UILabel             *_labelCheaper;
    UILabel             *_labelCheaperDetail;
    UILabel             *_labelHot;
    UILabel             *_labelHotDetail;
    UILabel             *_labeldiscount;
    UILabel             *_labeldiscountDetail;
    UILabel             *_labeldiscount1;
    UILabel             *_labeldiscountDetail1;
    UIButton            *_buttonDiscount[10];
    UILabel             *_labelDiscountPrice[10];
    UILabel             *_labelDiscountPriceOrigin[10];
    
    UIButton            *_buttonPromotion[7];
    UICollectionView    *_collectionView;
    
    
    NSMutableArray      *_arrayDataSource;
    
    
    NSMutableArray      *_arrayButtonTitle;
    NSMutableArray      *_arrayButtonImageName;
    
    NSMutableArray      *_arrayButtonPrice;
    NSMutableArray      *_arrayButtonImageNameGoods;
    
    NSString            *_strParameter;
    
    NSArray             *arrayTitles;
    
    NSArray             *arraychart;
    NSArray             *arraydiscount;
    NSArray             *arraypromotion;
    NSArray             *arraytransverse;
    NSArray             *arraymenu;
    
}

// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;
//轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleSV;
//轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleSV1;
@property (nonatomic,strong) NavTitleSearchBar *searchBar;

@end

@implementation IndexViewController

static NSString * const ReuseIdentify = @"ReuseIdentify";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    [self netRequest];
    [self footerRereshing];
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
        _strParameter = @"1";
        self.cellDic = [[NSMutableDictionary alloc] init];
        _arrayButtonTitle = [[NSMutableArray alloc]initWithObjects:@"五谷",@"数码",@"美妆",@"果蔬",@"海鲜",@"日用",@"干果",@"保健品",@"家居",@"服饰", nil];
//        _arrayButtonImageName = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
        
        
        _arrayButtonPrice = [[NSMutableArray alloc]initWithObjects:@"¥499.9",@"¥499.9",@"¥499.9",@"¥499.9",@"¥499.9",@"¥499.9",@"¥499.9",@"¥499.9",@"¥499.9",@"¥499.9", nil];
//        _arrayButtonImageNameGoods = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:CreateImageWithColor([UIColor whiteColor]) forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)configInterface
{
    [self setupSearchBar];
    [self setRightNavButtonWithImage:GetImage(@"消息(1)") Title:@"" Frame:CGRectMake(0, 0, 30, 30) Target:self action:@selector(rightClick)];
    viewSetBackgroundColor(kColorBasic);
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,- kNavBarAndStatusBarHeight ,GPScreenWidth,kNavBarAndStatusBarHeight+100)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)kColorTheme.CGColor,
                             (__bridge id)rgb(0, 195, 157).CGColor,
                             (__bridge id)kColorBasic.CGColor];
    gradientLayer.locations = @[@0.0, @0.5, @1.0];
    gradientLayer.startPoint =CGPointMake(0.5,0);
    gradientLayer.endPoint =CGPointMake(0.5,1);
    gradientLayer.frame = backView.bounds;
    [backView.layer addSublayer:gradientLayer];
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:backView.bounds];
    [imv setContentMode:UIViewContentModeScaleToFill];
    [imv setImage:[self convertViewToImage:backView]];
    [backView addSubview:imv];
    [self.view addSubview:backView];
    
    
    
    // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
    CGFloat h = GPScreenHeight - kNavBarAndStatusBarHeight - kTabBarHeight ;
    CGRect frame = CGRectMake(0, 0, GPScreenWidth, h);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[IndexCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentify];
    
    // 设置cell的大小和细节
    flowLayout.itemSize = CGSizeMake(_collectionView.width/2.0-10, (_collectionView.width/2.0 -10)*(290.0/249.0));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 5.0;
    flowLayout.minimumLineSpacing = 5.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    
    [self.view addSubview:_collectionView];
    
    
    [self setupRefreshWithScrollView:_collectionView];
    
    
    _viewTop = [[UIView alloc]init];
    [_viewTop setFrame:CGRectMake(0, 0, GPScreenWidth, 400)];
    _viewTop.backgroundColor = [UIColor clearColor];
    [_collectionView addSubview:_viewTop];
    
    
    _cycleSV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(GPSpacing, 0, _viewTop.width-GPSpacing*2, (_viewTop.width-GPSpacing*2)*(219.0/512.0)) delegate:self placeholderImage:GetImage(@"首页banner")];
    _cycleSV.autoScrollTimeInterval = 3;
    _cycleSV.backgroundColor = [UIColor clearColor];
    _cycleSV.infiniteLoop = YES;
    _cycleSV.localizationImageNamesGroup = @[@"首页banner",@"首页banner",@"首页banner"];
    _cycleSV.layer.masksToBounds = YES;
    _cycleSV.layer.cornerRadius = 7.0;
    [_viewTop addSubview:_cycleSV];
    
    
    _viewClass = [[UIView alloc]init];
    [_viewClass setFrame:CGRectMake(0, _cycleSV.height, _viewTop.width, 180)];
    [_viewTop addSubview:_viewClass];
    
    NSInteger lie = 5;
    CGFloat jianju = GPSpacing;
    CGFloat x = jianju;
    CGFloat y = jianju;
    CGFloat width = (GPScreenWidth - jianju*(lie+1) )/(lie *1.0);
    CGFloat height = width*(58.0/58.0);
    
    
    for (NSInteger i = 0; i<_arrayButtonTitle.count; i++)
    {
        _buttonMenu[i]=[UIButton buttonWithType:UIButtonTypeCustom];
        _buttonMenu[i].frame=CGRectMake(x, y, width,height);
        //        [_buttonMenu[i] setBackgroundImage:GetImage([_arrayButtonImageName objectAtIndex:i]) forState:UIControlStateNormal];
//        [_buttonMenu[i] setImage:GetImage([_arrayButtonImageName objectAtIndex:i]) forState:UIControlStateNormal];
        [_buttonMenu[i] setTitle:[_arrayButtonTitle objectAtIndex:i] forState:UIControlStateNormal];
        [_buttonMenu[i] setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_buttonMenu[i] setTag:i+tagMenu];
        [_buttonMenu[i] addTarget:self action:@selector(buttonClickMenu:) forControlEvents:UIControlEventTouchUpInside];
        [_viewClass addSubview:_buttonMenu[i]];
        
        _labelClass[i]=[[UILabel alloc]init];
        _labelClass[i].frame = CGRectMake(x, y+height+5, width,30);
        _labelClass[i].text = [_arrayButtonTitle objectAtIndex:i];
        _labelClass[i].textColor = kColorFontMedium;
        _labelClass[i].textAlignment = NSTextAlignmentCenter;
        _labelClass[i].font = FontRegularWithSize(15);
        [_viewClass addSubview:_labelClass[i]];
        
        x += (jianju + width);
        
        if ((i+1)%lie == 0) {
            x = jianju;
            y += (height+40+jianju);
        }
    }
    
    [_viewClass setHeight:ceil(_arrayButtonTitle.count/(lie*1.0))*(height+40+GPSpacing)];
    
    
    _viewAds = [[UIView alloc]init];
    [_viewAds setFrame:CGRectMake(0, _viewClass.bottom, _viewTop.width, _viewTop.width*(320.0/1080.0))];
    [_viewTop addSubview:_viewAds];
    
    _cycleSV1 = [SDCycleScrollView cycleScrollViewWithFrame:_viewAds.bounds delegate:self placeholderImage:defaultImage];
    _cycleSV1.autoScrollTimeInterval = 3;
    _cycleSV1.backgroundColor = [UIColor clearColor];
    _cycleSV1.infiniteLoop = YES;
    _cycleSV1.localizationImageNamesGroup = @[@"1",@"2",@"3"];
    [_viewAds addSubview:_cycleSV1];
    
    _viewGoods = [[UIView alloc]init];
    [_viewGoods setFrame:CGRectMake(0, _viewAds.bottom, _viewTop.width, _viewTop.width*(1150.0/1080.0))];
    [_viewTop addSubview:_viewGoods];
    [_viewGoods setBackgroundColor:rgb(255, 107, 57)];
    
    CGFloat LayoutScaleSizeWidth = (_viewGoods.width/540.0);
    
    UIView *viewWhiteBack = [[UIView alloc]initWithFrame:RectWithScale(CGRectMake(20, 20, 500, 330), LayoutScaleSizeWidth)];
    [viewWhiteBack setBackgroundColor:[UIColor whiteColor]];
    [viewWhiteBack.layer setMasksToBounds:YES];
    [viewWhiteBack.layer setCornerRadius:7.0];
    
    [_viewGoods addSubview:viewWhiteBack];
    
    _labelCheaper = [[UILabel alloc]init];
    _labelCheaper.frame = RectWithScale(CGRectMake(45, 40, 100, 30), LayoutScaleSizeWidth);
    _labelCheaper.text = @"超值好货";
    _labelCheaper.textColor = kColorFontMedium;
    _labelCheaper.textAlignment = NSTextAlignmentLeft;
    _labelCheaper.font = FontMediumWithSize(18);
    [_viewGoods addSubview:_labelCheaper];
    
    _labelCheaperDetail = [[UILabel alloc]init];
    _labelCheaperDetail.frame = RectWithScale(CGRectMake(150, 40, 80, 30), LayoutScaleSizeWidth);
    _labelCheaperDetail.text = @"数码精品";
    _labelCheaperDetail.textColor = rgb(0, 185, 143);
    _labelCheaperDetail.textAlignment = NSTextAlignmentCenter;
    _labelCheaperDetail.font = FontMediumWithSize(12);
    [_viewGoods addSubview:_labelCheaperDetail];
    _labelCheaperDetail.backgroundColor = [UIColor clearColor];
    _labelCheaperDetail.layer.masksToBounds = YES;
    _labelCheaperDetail.layer.cornerRadius = 15*LayoutScaleSizeWidth;
    _labelCheaperDetail.layer.borderColor = rgb(0, 185, 143).CGColor;
    _labelCheaperDetail.layer.borderWidth = 1;
    
    _labelHot = [[UILabel alloc]init];
    _labelHot.frame = RectWithScale(CGRectMake(275, 40, 100, 30), LayoutScaleSizeWidth);
    _labelHot.text = @"热品限时";
    _labelHot.textColor = kColorFontMedium;
    _labelHot.textAlignment = NSTextAlignmentLeft;
    _labelHot.font = FontMediumWithSize(18);
    [_viewGoods addSubview:_labelHot];
    
    _labelHotDetail = [[UILabel alloc]init];
    _labelHotDetail.frame = RectWithScale(CGRectMake(380, 40, 80, 30), LayoutScaleSizeWidth);
    _labelHotDetail.text = @"超值秒杀";
    _labelHotDetail.textColor = rgb(255, 0, 88);
    _labelHotDetail.textAlignment = NSTextAlignmentCenter;
    _labelHotDetail.font = FontMediumWithSize(12);
    [_viewGoods addSubview:_labelHotDetail];
    _labelHotDetail.backgroundColor = [UIColor clearColor];
    _labelHotDetail.layer.masksToBounds = YES;
    _labelHotDetail.layer.cornerRadius = 15*LayoutScaleSizeWidth;
    _labelHotDetail.layer.borderColor = rgb(255, 0, 88).CGColor;
    _labelHotDetail.layer.borderWidth = 1;
    
    
    lie = 3;
    jianju = 5;
    x = jianju+15;
    y = jianju+70;
    width = (viewWhiteBack.width/2.0 - jianju*(lie+1) )/(lie *1.0);
    height = width*(58.0/58.0);
    
    for (NSInteger i = 0; i<6; i++)
    {
        _buttonDiscount[i]=[UIButton buttonWithType:UIButtonTypeCustom];
        _buttonDiscount[i].frame=CGRectMake(x, y, width,height);
//        [_buttonDiscount[i] setImage:GetImage([_arrayButtonImageNameGoods objectAtIndex:i]) forState:UIControlStateNormal];
        _buttonDiscount[i].imageView.contentMode = UIViewContentModeScaleToFill;
//        [_buttonDiscount[i] setTitle:[_arrayButtonPrice objectAtIndex:i] forState:UIControlStateNormal];
//        [_buttonDiscount[i] setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_buttonDiscount[i] setTag:i+tagDiscount];
        [_buttonDiscount[i] addTarget:self action:@selector(buttonClickDiscount:) forControlEvents:UIControlEventTouchUpInside];
        [_viewGoods addSubview:_buttonDiscount[i]];
        
        _labelDiscountPrice[i]=[[UILabel alloc]init];
        _labelDiscountPrice[i].frame = CGRectMake(x, y+height+5, width,15);
        _labelDiscountPrice[i].text = [_arrayButtonPrice objectAtIndex:i];
        _labelDiscountPrice[i].textColor = kColorFontMedium;
        _labelDiscountPrice[i].textAlignment = NSTextAlignmentCenter;
        _labelDiscountPrice[i].font = FontRegularWithSize(10);
        [_viewGoods addSubview:_labelDiscountPrice[i]];
        
        _labelDiscountPriceOrigin[i]=[[UILabel alloc]init];
        _labelDiscountPriceOrigin[i].frame = CGRectMake(x, y+height+20, width,15);
        _labelDiscountPriceOrigin[i].text = [_arrayButtonPrice objectAtIndex:i];
        _labelDiscountPriceOrigin[i].textColor = [UIColor grayColor];
        _labelDiscountPriceOrigin[i].textAlignment = NSTextAlignmentCenter;
        _labelDiscountPriceOrigin[i].font = FontRegularWithSize(10);
//        [_viewGoods addSubview:_labelDiscountPriceOrigin[i]];
//        [_labelDiscountPriceOrigin[i] addDeletelineColor:[UIColor grayColor] toText:_labelDiscountPriceOrigin[i].text];
        
        x += (jianju + width);
        
        if ((i+1)%lie == 0) {
            x = jianju+15;
            y += (height+40+jianju);
        }
    }
    
    lie = 2;
    jianju = 5;
    x = viewWhiteBack.width/2.0+jianju+15;
    y = jianju+70;
    width = (viewWhiteBack.width/2.0 - jianju*(lie+1) )/(lie *1.0);
    //    height = width*(58.0/58.0);
    
    for (NSInteger i = 6; i<_arrayButtonPrice.count; i++)
    {
        _buttonDiscount[i]=[UIButton buttonWithType:UIButtonTypeCustom];
        _buttonDiscount[i].frame=CGRectMake(x, y, width,height);
//        [_buttonDiscount[i] setImage:GetImage([_arrayButtonImageNameGoods objectAtIndex:i]) forState:UIControlStateNormal];
        _buttonDiscount[i].imageView.contentMode = contentModeDefault;
//        [_buttonDiscount[i] setTitle:[_arrayButtonPrice objectAtIndex:i] forState:UIControlStateNormal];
//        [_buttonDiscount[i] setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_buttonDiscount[i] setTag:i+tagDiscount];
        [_buttonDiscount[i] addTarget:self action:@selector(buttonClickDiscount:) forControlEvents:UIControlEventTouchUpInside];
        [_viewGoods addSubview:_buttonDiscount[i]];
        
        _labelDiscountPrice[i]=[[UILabel alloc]init];
        _labelDiscountPrice[i].frame = CGRectMake(x, y+height+5, width,15);
        _labelDiscountPrice[i].text = [_arrayButtonPrice objectAtIndex:i];
        _labelDiscountPrice[i].textColor = kColorFontMedium;
        _labelDiscountPrice[i].textAlignment = NSTextAlignmentCenter;
        _labelDiscountPrice[i].font = FontRegularWithSize(10);
        [_viewGoods addSubview:_labelDiscountPrice[i]];
        
        _labelDiscountPriceOrigin[i]=[[UILabel alloc]init];
        _labelDiscountPriceOrigin[i].frame = CGRectMake(x, y+height+20, width,15);
        _labelDiscountPriceOrigin[i].text = [_arrayButtonPrice objectAtIndex:i];
        _labelDiscountPriceOrigin[i].textColor = [UIColor grayColor];
        _labelDiscountPriceOrigin[i].textAlignment = NSTextAlignmentCenter;
        _labelDiscountPriceOrigin[i].font = FontRegularWithSize(10);
        //        [_viewGoods addSubview:_labelDiscountPriceOrigin[i]];
        [_labelDiscountPriceOrigin[i] addDeletelineColor:[UIColor grayColor] toText:_labelDiscountPriceOrigin[i].text];
        
        x += (jianju + width);
        
        if ((i+1)%lie == 0) {
            x = viewWhiteBack.width/2.0+jianju+15;
            y += (height+40+jianju);
        }
    }
    UIView *viewWhiteBackGoods = [[UIView alloc]initWithFrame:RectWithScale(CGRectMake(280, 360, 240, 100), LayoutScaleSizeWidth)];
    [viewWhiteBackGoods setBackgroundColor:[UIColor whiteColor]];
    
    [_viewGoods addSubview:viewWhiteBackGoods];
    
    UIView *viewWhiteBackGoodsTwo = [[UIView alloc]initWithFrame:RectWithScale(CGRectMake(280, 470, 240, 100), LayoutScaleSizeWidth)];
    [viewWhiteBackGoodsTwo setBackgroundColor:[UIColor whiteColor]];
    
    [_viewGoods addSubview:viewWhiteBackGoodsTwo];
    
    for (NSInteger i = 0; i<7; i++)
    {
        _buttonPromotion[i]=[UIButton buttonWithType:UIButtonTypeCustom];
//        [_buttonPromotion[i] setImage:GetImage([_arrayButtonImageNameGoods objectAtIndex:i]) forState:UIControlStateNormal];
        _buttonPromotion[i].imageView.contentMode = contentModeDefault;
//        [_buttonPromotion[i] setTitle:[_arrayButtonPrice objectAtIndex:i] forState:UIControlStateNormal];
//        [_buttonPromotion[i] setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_buttonPromotion[i] setTag:i+tagPromotion];
        [_buttonPromotion[i] addTarget:self action:@selector(buttonClickPromotion:) forControlEvents:UIControlEventTouchUpInside];
        [_viewGoods addSubview:_buttonPromotion[i]];
        
    }
    
    
    [_buttonPromotion[0] setFrame:RectWithScale(CGRectMake(20, 360, 250, 210), LayoutScaleSizeWidth)];
    
    
    
    _labeldiscount = [[UILabel alloc]init];
    _labeldiscount.frame = RectWithScale(CGRectMake(290, 370, 80, 20), LayoutScaleSizeWidth);
    _labeldiscount.text = @"天然山货";
    _labeldiscount.textColor = kColorFontMedium;
    _labeldiscount.textAlignment = NSTextAlignmentLeft;
    _labeldiscount.font = FontMediumWithSize(12);
    [_viewGoods addSubview:_labeldiscount];
    
    _labeldiscountDetail = [[UILabel alloc]init];
    _labeldiscountDetail.frame = RectWithScale(CGRectMake(370, 370, 130, 20), LayoutScaleSizeWidth);
    _labeldiscountDetail.text = @"大自然的馈赠";
    _labeldiscountDetail.textColor = [UIColor grayColor];
    _labeldiscountDetail.textAlignment = NSTextAlignmentLeft;
    _labeldiscountDetail.font = FontMediumWithSize(9);
    [_viewGoods addSubview:_labeldiscountDetail];
    
    
    [_buttonPromotion[1] setFrame:RectWithScale(CGRectMake(290, 400, 50, 50), LayoutScaleSizeWidth)];
    [_buttonPromotion[2] setFrame:RectWithScale(CGRectMake(375, 400, 50, 50), LayoutScaleSizeWidth)];
    [_buttonPromotion[3] setFrame:RectWithScale(CGRectMake(460, 400, 50, 50), LayoutScaleSizeWidth)];
    
    
    
    _labeldiscount1 = [[UILabel alloc]init];
    _labeldiscount1.frame = RectWithScale(CGRectMake(290, 480, 80, 20), LayoutScaleSizeWidth);
    _labeldiscount1.text = @"海鲜大咖";
    _labeldiscount1.textColor = kColorFontMedium;
    _labeldiscount1.textAlignment = NSTextAlignmentLeft;
    _labeldiscount1.font = FontMediumWithSize(12);
    [_viewGoods addSubview:_labeldiscount1];
    
    _labeldiscountDetail1 = [[UILabel alloc]init];
    _labeldiscountDetail1.frame = RectWithScale(CGRectMake(370, 480, 130, 20), LayoutScaleSizeWidth);
    _labeldiscountDetail1.text = @"海的味道我知道";
    _labeldiscountDetail1.textColor = [UIColor grayColor];
    _labeldiscountDetail1.textAlignment = NSTextAlignmentLeft;
    _labeldiscountDetail1.font = FontMediumWithSize(9);
    [_viewGoods addSubview:_labeldiscountDetail1];
    
    [_buttonPromotion[4] setFrame:RectWithScale(CGRectMake(290, 510, 50, 50), LayoutScaleSizeWidth)];
    [_buttonPromotion[5] setFrame:RectWithScale(CGRectMake(375, 510, 50, 50), LayoutScaleSizeWidth)];
    [_buttonPromotion[6] setFrame:RectWithScale(CGRectMake(460, 510, 50, 50), LayoutScaleSizeWidth)];
    
    [_viewTop setHeight:_viewGoods.bottom];
    CGFloat _viewh = _viewTop.height;
    [_viewTop setFrame:CGRectMake(0, -_viewh, GPScreenWidth, _viewh)];
    //设置滚动范围偏移200
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    //设置内容范围偏移200
    _collectionView.contentInset = UIEdgeInsetsMake(_viewh, 0, 0, 0);
}

#pragma mark - topLeftButton
- (void)setupSearchBar {
    
    //添加搜索框
    UIView *wrapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth -  44 - 40, 32)];
    
    _searchBar = [[NavTitleSearchBar alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth -  44 - 40, 32)];
    _searchBar.searchDelegate = self;
    _searchBar.placeholder = @"搜索商品";
    _searchBar.backgroundColor = rgb(244, 244, 244);
    [wrapView addSubview:_searchBar];
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:wrapView];
    self.navigationItem.leftBarButtonItems = @[item];
}

-(void)leftClick
{
    
}

-(void)rightClick
{
//    NoticeViewController *vc = [[NoticeViewController alloc]init];
    ViewController *vc = [[ViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)netRequest
{
    [HPNetManager POSTWithUrlString:HostIndexIndex isNeedCache:NO parameters:nil successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            [self updateInterfaceWithDic:response[@"result"]];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}
/**
 *class     表示分类
 *goods     表示商品ID
 *store     表示店铺ID
 *article   表示文章ID
 *url       H5链接
 */

-(void)updateInterfaceWithDic:(NSDictionary*)dic
{
    arraychart = dic[@"chart"];
    NSDictionary *dicDiscount = dic[@"discount"];
    arrayTitles = dicDiscount[@"title"];
    arraydiscount = dicDiscount[@"date"];
    arraypromotion = dic[@"promotion"];
    arraytransverse = dic[@"transverse"];
    arraymenu = dic[@"menu"];
    
    
    if ([arraychart count]) {
        [self updateChart];
    }
    if ([arraymenu count]) {
        [self updateMenu];
    }
    if ([arraytransverse count]) {
        [self updateTransverse];
    }
    if ([arraypromotion count]) {
        [self updatePromotion];
    }
    if ([arraydiscount count]) {
        [self updateDiscount];
    }
    if ([arrayTitles count]>=4) {
        [self updateTitles];
    }
}

-(void)updateTitles
{
    NSArray *arrayCheaper = [[NSString stringWithFormat:@"%@",arrayTitles[0]] componentsSeparatedByString:@"-"];
    if (arrayCheaper.count>=2) {
        _labelCheaper.text = arrayCheaper[0];
        _labelCheaperDetail.text = arrayCheaper[1];
    }
    
    NSArray *arrayHot = [[NSString stringWithFormat:@"%@",arrayTitles[1]] componentsSeparatedByString:@"-"];
    if (arrayHot.count>=2) {
        _labelHot.text = arrayHot[0];
        _labelHotDetail.text = arrayHot[1];
    }
    
    NSArray *arrayDiscount = [[NSString stringWithFormat:@"%@",arrayTitles[2]] componentsSeparatedByString:@"-"];
    if (arrayDiscount.count>=2) {
        _labeldiscount.text = arrayDiscount[0];
        _labeldiscountDetail.text = arrayDiscount[1];
    }
    
    NSArray *arrayDiscount1 = [[NSString stringWithFormat:@"%@",arrayTitles[3]] componentsSeparatedByString:@"-"];
    if (arrayDiscount1.count>=2) {
        _labeldiscount1.text = arrayDiscount1[0];
        _labeldiscountDetail1.text = arrayDiscount1[1];
    }
    
    
    
}

-(void)updateChart
{
    NSMutableArray *arrayImageUrlString = [NSMutableArray arrayWithCapacity:3];
    for (NSDictionary *dicChart in arraychart) {
        NSString *strUrl = dicChart[@"adv_code"];
        [arrayImageUrlString addObject:strUrl];
    }
    //GPDebugLog(@"arrayImageUrlString:%@",arrayImageUrlString);
    [_cycleSV setImageURLStringsGroup:arrayImageUrlString];
}

-(void)updatePromotion
{
    for (NSInteger i = 0; i<arraypromotion.count; i++) {
        NSDictionary *dicPromotion = arraypromotion[i];
        NSString *strUrl = dicPromotion[@"adv_code"];
        [_buttonPromotion[i] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
    }
    return;
    
    for (NSDictionary *dicPromotion in arraypromotion) {
        NSString *strTitle = dicPromotion[@"adv_title"];
        NSString *strUrl = dicPromotion[@"adv_code"];
        if ([strTitle containsString:@"首页促销左"])
        {
            [_buttonPromotion[0] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
        }
        else if ([strTitle containsString:@"首页促销右上1"])
        {
            [_buttonPromotion[1] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
        }
        else if ([strTitle containsString:@"首页促销右上2"])
        {
            [_buttonPromotion[2] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
        }
        else if ([strTitle containsString:@"首页促销右上3"])
        {
            [_buttonPromotion[3] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
        }
        else if ([strTitle containsString:@"首页促销右下1"])
        {
            [_buttonPromotion[4] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
        }
        else if ([strTitle containsString:@"首页促销右下2"])
        {
            [_buttonPromotion[5] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
        }
        else if ([strTitle containsString:@"首页促销右下3"])
        {
            [_buttonPromotion[6] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
        }
    }
}

-(void)updateDiscount
{
    for (NSInteger i = 0; i<arraydiscount.count; i++) {
        NSDictionary *dicDiscount = arraydiscount[i];
        NSString *strUrl = dicDiscount[@"goodsInfo"][@"goods_image"];
        NSString *strPrice = [NSString stringWithFormat:@"¥%@",dicDiscount[@"goodsInfo"][@"goods_promotion_price"]];
        NSString *strPriceOrigin = [NSString stringWithFormat:@"¥%@",dicDiscount[@"goodsInfo"][@"goods_price"]];
        
        [_buttonDiscount[i] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
        _labelDiscountPrice[i].text = strPrice;
        _labelDiscountPriceOrigin[i].text = strPriceOrigin;
        [_labelDiscountPriceOrigin[i] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
    }
    return;
    
    
    for (NSDictionary *dicDiscount in arraydiscount) {
        NSString *strTitle = dicDiscount[@"adv_title"];
        NSString *strUrl = dicDiscount[@"goodsInfo"][@"goods_image"];
        NSString *strPrice = dicDiscount[@"goodsInfo"][@"goods_promotion_price"];
        NSString *strPriceOrigin = dicDiscount[@"goodsInfo"][@"goods_price"];
        if ([strTitle containsString:@"左侧超值好货1"])
        {
            [_buttonDiscount[0] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
            _labelDiscountPrice[0].text = strPrice;
            _labelDiscountPriceOrigin[0].text = strPriceOrigin;
            [_labelDiscountPriceOrigin[0] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
        }
        else if ([strTitle containsString:@"左侧超值好货2"])
        {
            [_buttonDiscount[1] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
            _labelDiscountPrice[1].text = strPrice;
            _labelDiscountPriceOrigin[1].text = strPriceOrigin;
            [_labelDiscountPriceOrigin[1] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
        }
        else if ([strTitle containsString:@"左侧超值好货3"])
        {
            [_buttonDiscount[2] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
            _labelDiscountPrice[2].text = strPrice;
            _labelDiscountPriceOrigin[2].text = strPriceOrigin;
            [_labelDiscountPriceOrigin[2] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
        }
        else if ([strTitle containsString:@"左侧超值好货4"])
        {
            [_buttonDiscount[3] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
            _labelDiscountPrice[3].text = strPrice;
            _labelDiscountPriceOrigin[3].text = strPriceOrigin;
            [_labelDiscountPriceOrigin[3] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
        }
        else if ([strTitle containsString:@"左侧超值好货5"])
        {
            [_buttonDiscount[4] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
            _labelDiscountPrice[4].text = strPrice;
            _labelDiscountPriceOrigin[4].text = strPriceOrigin;
            [_labelDiscountPriceOrigin[4] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
        }
        else if ([strTitle containsString:@"左侧超值好货6"])
        {
            [_buttonDiscount[5] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
            _labelDiscountPrice[5].text = strPrice;
            _labelDiscountPriceOrigin[5].text = strPriceOrigin;
            [_labelDiscountPriceOrigin[5] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
        }
        else if ([strTitle containsString:@"右侧超值好货1"])
        {
            [_buttonDiscount[6] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
            _labelDiscountPrice[6].text = strPrice;
            _labelDiscountPriceOrigin[6].text = strPriceOrigin;
            [_labelDiscountPriceOrigin[6] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
        }
        else if ([strTitle containsString:@"右侧超值好货2"])
        {
            [_buttonDiscount[7] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
            _labelDiscountPrice[7].text = strPrice;
            _labelDiscountPriceOrigin[7].text = strPriceOrigin;
            [_labelDiscountPriceOrigin[7] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
        }
        else if ([strTitle containsString:@"右侧超值好货3"])
        {
            [_buttonDiscount[8] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
            _labelDiscountPrice[8].text = strPrice;
            _labelDiscountPriceOrigin[8].text = strPriceOrigin;
            [_labelDiscountPriceOrigin[8] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
        }
        else if ([strTitle containsString:@"右侧超值好货4"])
        {
            [_buttonDiscount[9] sd_setImageWithURL:[NSURL URLWithString:strUrl] forState:UIControlStateNormal];
            _labelDiscountPrice[9].text = strPrice;
            _labelDiscountPriceOrigin[9].text = strPriceOrigin;
            [_labelDiscountPriceOrigin[9] addDeletelineColor:[UIColor grayColor] toText:strPriceOrigin];
        }
        
    }
}


-(void)updateTransverse
{
    NSMutableArray *arrayImageUrlString = [NSMutableArray arrayWithCapacity:3];
    for (NSDictionary *dicTransverse in arraytransverse) {
        NSString *strUrl = dicTransverse[@"adv_code"];
        [arrayImageUrlString addObject:strUrl];
    }
    //GPDebugLog(@"arrayImageUrlString:%@",arrayImageUrlString);
    [_cycleSV1 setImageURLStringsGroup:arrayImageUrlString];
}

-(void)updateMenu
{
    for (UIView *view in _viewClass.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }else if ([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
    
    NSInteger lie = 5;
    CGFloat jianju = GPSpacing;
    //    CGFloat x = jianju;
    //    CGFloat y = jianju;
    CGFloat width = (GPScreenWidth - jianju*(lie+1) )/(lie *1.0);
    CGFloat height = width*(58.0/58.0);
    
    [_viewClass setHeight:ceil(arraymenu.count/(lie*1.0))*(height+40+GPSpacing)];
    
    [_viewAds setFrame:CGRectMake(0, _viewClass.bottom, _viewTop.width, _viewTop.width*(320.0/1080.0))];
    
    [_viewGoods setFrame:CGRectMake(0, _viewAds.bottom, _viewTop.width, _viewTop.width*(1150.0/1080.0))];
    
    CGFloat _viewh = _viewGoods.bottom;
    [_viewTop setFrame:CGRectMake(0, -_viewh, GPScreenWidth, _viewh)];
    //设置滚动范围偏移200
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    //设置内容范围偏移200
    _collectionView.contentInset = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    
    [_collectionView setContentOffset:CGPointMake(0, -_viewh)];
    
    
    _collectionView.mj_header.ignoredScrollViewContentInsetTop = _viewh + kScrollViewHeaderIgnored;
    
    for (NSInteger i = 0; i< arraymenu.count; i++) {
        [_buttonMenu[i] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",arraymenu[i][@"adv_code"]]] forState:UIControlStateNormal];
        [_viewClass addSubview:_buttonMenu[i]];
        [_labelClass[i] setText:[NSString stringWithFormat:@"%@",arraymenu[i][@"adv_title"]]];
        [_viewClass addSubview:_labelClass[i]];
    }
}

/**
 *class     表示分类
 *goods     表示商品ID
 *store     表示店铺ID
 *article   表示文章ID
 *url       H5链接
 */

-(void)buttonClickMenu:(UIButton*)btn
{
    NSInteger tag = btn.tag - tagMenu;
    
    NSString *stringadv_type = StringNullOrNot(arraymenu[tag][@"adv_type"]);
    NSString *stringadv_typedate = StringNullOrNot(arraymenu[tag][@"adv_typedate"]);
    [self pushVCwithType:stringadv_type date:stringadv_typedate];
}

-(void)buttonClickDiscount:(UIButton*)btn
{
    NSInteger tag = btn.tag - tagDiscount;
    
    NSString *stringadv_type = StringNullOrNot(arraydiscount[tag][@"adv_type"]);
    NSString *stringadv_typedate = StringNullOrNot(arraydiscount[tag][@"adv_typedate"]);
    [self pushVCwithType:stringadv_type date:stringadv_typedate];
}

-(void)buttonClickPromotion:(UIButton*)btn
{
    NSInteger tag = btn.tag - tagPromotion;
    
    NSString *stringadv_type = StringNullOrNot(arraypromotion[tag][@"adv_type"]);
    NSString *stringadv_typedate = StringNullOrNot(arraypromotion[tag][@"adv_typedate"]);
    [self pushVCwithType:stringadv_type date:stringadv_typedate];
}



-(void)refresh
{
    [_arrayDataSource removeAllObjects];
    [_collectionView reloadData];
    [self footerRereshing];
}

/**
 *class     表示分类ID
 *goods     表示商品ID
 *store     表示店铺ID
 *article   表示文章ID
 *url       H5链接
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //GPDebugLog(@"tapIndex:%ld",(long)index);
    if (cycleScrollView == _cycleSV) {
        if ([arraychart count]) {
            NSString *stringadv_type = StringNullOrNot(arraychart[index][@"adv_type"]);
            NSString *stringadv_typedate = StringNullOrNot(arraychart[index][@"adv_typedate"]);
            [self pushVCwithType:stringadv_type date:stringadv_typedate];
        }
    }
    else if (cycleScrollView == _cycleSV1)
    {
        NSString *stringadv_type = StringNullOrNot(arraytransverse[index][@"adv_type"]);
        NSString *stringadv_typedate = StringNullOrNot(arraytransverse[index][@"adv_typedate"]);
        [self pushVCwithType:stringadv_type date:stringadv_typedate];
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
    
    CGFloat _viewh = _viewGoods.bottom;
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
    scrollView.mj_footer = footer;
    
    scrollView.mj_footer.ignoredScrollViewContentInsetBottom = kScrollViewFooterIgnored;
}



//下拉刷新
- (void)headerRereshing
{
    [self netRequest];
    
    _strParameter = @"1";
    
    [self->_arrayDataSource removeAllObjects];
    [self->_collectionView reloadData];
    
    
    [HPNetManager POSTWithUrlString:HostIndexgetCommendGoods isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"]]];
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
    [HPNetManager POSTWithUrlString:HostIndexgetCommendGoods isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"]]];
                [self->_collectionView reloadData];
                [self->_collectionView.mj_footer endRefreshing];
                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
            }
            else
            {
                [self->_collectionView.mj_footer endRefreshing];
            }
        }
        else
        {
            [self->_collectionView.mj_footer endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_collectionView.mj_footer endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}

-(void)pushVCwithType:(NSString *)stringadv_type date:(NSString *)stringadv_typedate
{
    if ([stringadv_type isEqualToString:@"class"])
    {
        SearchResultListViewController *vc = [[SearchResultListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.gc_id = stringadv_typedate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([stringadv_type isEqualToString:@"goods"])
    {
        GoodsViewController *vc = [[GoodsViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.goods_id = stringadv_typedate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([stringadv_type isEqualToString:@"store"])
    {
        StoreViewController *vc = [[StoreViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.store_id = stringadv_typedate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([stringadv_type isEqualToString:@"article"])
    {
        HPBaseWKWebViewController *vc = [[HPBaseWKWebViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.urlStr = stringadv_typedate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([stringadv_type isEqualToString:@"url"])
    {
        HPBaseWKWebViewController *vc = [[HPBaseWKWebViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.urlStr = stringadv_typedate;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

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

-(UIImage*)convertViewToImage:(UIView*)v
{
    CGSize s = v.bounds.size;// 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需 要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s,YES, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", ReuseIdentify, [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [_collectionView registerClass:[IndexCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    //    https://blog.csdn.net/autom_lishun/article/details/85061258
    
    IndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
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
