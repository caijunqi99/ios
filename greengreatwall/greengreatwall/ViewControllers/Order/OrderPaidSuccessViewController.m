//
//  OrderPaidSuccessViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/26.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "OrderPaidSuccessViewController.h"

#import "IndexCollectionViewCell.h"
#import "GoodsViewController.h"

@interface OrderPaidSuccessViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView              *_viewTop;
    
    UIImageView         *_imageViewTemp;
    UILabel             *_labelPayStatusSuccess;
    UILabel             *_labelPayAmount;
    
    UIView              *_viewLottery;
    UIButton            *_buttonLottery[7];
    
    UICollectionView    *_collectionView;
    
    
    NSMutableArray      *_arrayDataSource;
}

// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@property(nonatomic,strong)NSString * string_pay_sn;
@property(nonatomic,strong)NSString * string_pay_amount;
@property(nonatomic,strong)NSString * string_draw;

@end

@implementation OrderPaidSuccessViewController

static NSString * const ReuseIdentify = @"ReuseIdentify";

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
        _arrayDataSource = [[NSMutableArray alloc]initWithCapacity:0];
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [_labelPayAmount setText:[NSString stringWithFormat:@"¥ %@",_string_pay_amount]];
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
    [self setLeftNavButtonImage:nil Title:nil Frame:CGRectZero Target:self action:@selector(leftClick)];
    [self setRightNavButtonWithImage:GetImage(@"") Title:@"完成" Frame:CGRectMake(0, 0, 30, 30) Target:self action:@selector(rightClick)];
    viewSetBackgroundColor(kColorBasic);
    
    // 高度 = 屏幕高度 - 导航栏高度64
    CGFloat h = GPScreenHeight - kNavBarAndStatusBarHeight;
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
    
    flowLayout.headerReferenceSize = CGSizeMake(_collectionView.width, 30.0f);  //设置headerView大小
    flowLayout.footerReferenceSize = CGSizeMake(_collectionView.width, 0.0f);  // 设置footerView大小
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];  //  一定要设置
    [self.view addSubview:_collectionView];
    
    
    _viewTop = [[UIView alloc]init];
    [_viewTop setFrame:CGRectMake(0, 0, GPScreenWidth, 360*GPCommonLayoutScaleSizeWidthIndex)];
    _viewTop.backgroundColor = [UIColor whiteColor];
    [_collectionView addSubview:_viewTop];
    
    _imageViewTemp = [UIImageView initImageView:@"购物成功"];
    [_imageViewTemp setFrame:RectWithScale(CGRectMake(380, 100, 60, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTop addSubview:_imageViewTemp];
    
    _labelPayStatusSuccess = [[UILabel alloc]init];
    _labelPayStatusSuccess.frame = RectWithScale(CGRectMake(470, 90, 300, 80), GPCommonLayoutScaleSizeWidthIndex);
    _labelPayStatusSuccess.text = @"购物成功";
    _labelPayStatusSuccess.textColor = kColorFontMedium;
    _labelPayStatusSuccess.textAlignment = NSTextAlignmentLeft;
    _labelPayStatusSuccess.font = FontMediumWithSize(18);
    [_viewTop addSubview:_labelPayStatusSuccess];
    
    _labelPayAmount = [[UILabel alloc]init];
    _labelPayAmount.frame = RectWithScale(CGRectMake(300, 240, 480, 60), GPCommonLayoutScaleSizeWidthIndex);
    _labelPayAmount.text = @"";
    _labelPayAmount.textColor = kColorTheme;
    _labelPayAmount.textAlignment = NSTextAlignmentCenter;
    _labelPayAmount.font = FontMediumWithSize(18);
    [_viewTop addSubview:_labelPayAmount];
    
    
    _viewLottery = [[UIView alloc]init];
    [_viewLottery setFrame:CGRectMake(0, _viewTop.height, _viewTop.width, 180)];
    //    [_viewTop addSubview:_viewLottery];
    
    for (NSInteger i = 0; i<7; i++)
    {
        _buttonLottery[i]=[UIButton buttonWithType:UIButtonTypeCustom];
        //        [_buttonLottery[i] setImage:GetImage([_arrayButtonImageNameGoods objectAtIndex:i]) forState:UIControlStateNormal];
        _buttonLottery[i].imageView.contentMode = contentModeDefault;
        //        [_buttonLottery[i] setTitle:[_arrayButtonPrice objectAtIndex:i] forState:UIControlStateNormal];
        //        [_buttonLottery[i] setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_buttonLottery[i] setTag:i+200];
        [_buttonLottery[i] addTarget:self action:@selector(buttonClickPromotion:) forControlEvents:UIControlEventTouchUpInside];
        [_viewLottery addSubview:_buttonLottery[i]];
        
    }
    
    
    [_buttonLottery[0] setFrame:RectWithScale(CGRectMake(20, 360, 250, 210), GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonLottery[1] setFrame:RectWithScale(CGRectMake(290, 400, 50, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonLottery[2] setFrame:RectWithScale(CGRectMake(375, 400, 50, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonLottery[3] setFrame:RectWithScale(CGRectMake(460, 400, 50, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonLottery[4] setFrame:RectWithScale(CGRectMake(290, 510, 50, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonLottery[5] setFrame:RectWithScale(CGRectMake(375, 510, 50, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonLottery[6] setFrame:RectWithScale(CGRectMake(460, 510, 50, 50), GPCommonLayoutScaleSizeWidthIndex)];
    
    //    [_viewTop setHeight:_viewLottery.bottom];
    
    CGFloat _viewh = _viewTop.height;
    [_viewTop setFrame:CGRectMake(0, -_viewh, GPScreenWidth, _viewh)];
    //设置滚动范围偏移200
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(_viewh, 0, 0, 0);
    //设置内容范围偏移200
    _collectionView.contentInset = UIEdgeInsetsMake(_viewh, 0, 0, 0);
}

-(void)leftClick
{
    
}

-(void)rightClick
{
    HPNOTIF_POST(@"orderPaySuccess", nil);
    [self popToController:@"GoodsViewController"];
    [self popToController:@"ShoppingCartViewController"];
    [self popToController:@"OrderListViewController"];
//    OrderListViewController
}

-(void)setPay_amount:(NSString *)pay_amount andDraw:(NSString *)draw andPay_sn:(NSString *)pay_sn
{
    _string_pay_amount = pay_amount;
    _string_draw = draw;
    _string_pay_sn = pay_sn;
}

-(void)netRequest
{
    [HPNetManager POSTWithUrlString:HostGoodsgetRandGoods isNeedCache:NO parameters:nil successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
                
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"]]];
                [self->_collectionView reloadData];
            }
            else
            {
                
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
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        UILabel *labelBottom = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, GPScreenWidth, 20)];
        labelBottom.textColor = [UIColor grayColor];
        labelBottom.text = @"推荐商品";
        labelBottom.textAlignment = NSTextAlignmentCenter;
        labelBottom.font = FontRegularWithSize(12);
        [headerView addSubview:labelBottom];
    }
    
    return headerView;
}

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
