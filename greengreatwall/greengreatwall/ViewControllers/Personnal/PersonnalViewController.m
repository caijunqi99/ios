//
//  PersonnalViewController.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/10/24.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "PersonnalViewController.h"
#import "StoreViewController.h"
#import "LoginViewController.h"


#import "SetLoginPasswordViewController.h"
#import "SetPayPasswordViewController.h"
#import "AddressListViewController.h"

#import "PersonnalInfoViewController.h"


#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageManager.h>
#import "VerifiedViewController.h"

#import "OrderListViewController.h"

#import "WalletViewController.h"
@interface PersonnalViewController ()
{
    UIView              *_viewBack;
    UIView              *_viewTop;
    UIScrollView        *_scrollViewContent;
    
    UIImageView         *_imageViewUserHead;
    UIView              *_viewUserHeadContainer;
    UILabel             *_labelUserNickName;
    UILabel             *_labelUserPhoneNumber;
    
    UIImageView         *_imageViewWallet;
    UIImageView         *_imageViewWalletContent;
    UILabel             *_labelWallet;
    UILabel             *_labelWalletDescribe;
    UIButton            *_buttonWallet;
    
    UIView              *_viewContent[6];
    UITapGestureRecognizer *_tap[6];
    
    UILabel             *_labelContentFirstTitle;
    
    UIButton            *_buttonContentFirst[10];
    UILabel             *_labelContentFirst[10];
    
    UIImageView         *_imageViewContent[5];
    UILabel             *_labelContent[5];
    
    
    NSMutableArray      *_arrayDataSource;
    
}

@end
static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation PersonnalViewController

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
        HPNOTIF_ADD(@"refreshUserInfo", refresh);
    }
    return self;
}

-(void)refresh
{
    [self netRequest];
}

-(void)dealloc
{
    HPNOTIF_REMV();
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self netRequest];
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
    viewSetBackgroundColor(kColorTheme);
    
    _viewBack = [[UIView alloc]init];
    [_viewBack setBackgroundColor:[UIColor whiteColor]];
    [_viewBack setFrame:CGRectMake(0, 570*GPCommonLayoutScaleSizeWidthIndex , GPScreenWidth, GPScreenHeight - kTabBarHeight )];//-570*GPCommonLayoutScaleSizeWidthIndex
    [_viewBack rounded:30 rectCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];
    [self.view addSubview:_viewBack];
    
    _viewTop = [[UIView alloc]init];
    _viewTop.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_viewTop];
    
    [_viewTop setFrame:self.view.bounds];
    /*
    viewSetBackgroundColor(kColorTheme);
    
    _viewTop = [[UIView alloc]init];
    _viewTop.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_viewTop];
    //    [_scrollViewContent addSubview:_viewTop];
    
    [_viewTop setFrame:self.view.bounds];
    
    _scrollViewContent = [[UIScrollView alloc]init];
    [_scrollViewContent setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kTabBarHeight)];
    [_scrollViewContent setBackgroundColor:kColorTheme];
//    [self.view addSubview:_scrollViewContent];
    
    _viewBack = [[UIView alloc]init];
    [_viewBack setBackgroundColor:[UIColor whiteColor]];
    [_viewBack setFrame:CGRectMake(0, 570*GPCommonLayoutScaleSizeWidthIndex , GPScreenWidth, GPScreenHeight - kTabBarHeight)];
    [_viewBack rounded:30 rectCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];
    [_viewTop addSubview:_viewBack];
    [_scrollViewContent addSubview:_viewBack];
//    [_scrollViewContent setContentSize:CGSizeMake(GPScreenWidth, GPScreenHeight - kTabBarHeight -500*GPCommonLayoutScaleSizeWidthIndex)];
//    _scrollViewContent.scrollEnabled = YES;
//    _scrollViewContent.userInteractionEnabled = YES;
    
    */

    
    CGFloat x = 0;
    CGFloat y = _viewBack.top;
    CGFloat width = (GPScreenWidth - x*2);
    
    NSArray *arrayHeight = @[[NSNumber numberWithFloat:340.0*GPCommonLayoutScaleSizeWidthIndex],
                             [NSNumber numberWithFloat:140.0*GPCommonLayoutScaleSizeWidthIndex],
                             [NSNumber numberWithFloat:140.0*GPCommonLayoutScaleSizeWidthIndex],
                             [NSNumber numberWithFloat:140.0*GPCommonLayoutScaleSizeWidthIndex],
                             [NSNumber numberWithFloat:170.0*GPCommonLayoutScaleSizeWidthIndex],
                             [NSNumber numberWithFloat:140.0*GPCommonLayoutScaleSizeWidthIndex]];
    
    
    
    for (NSInteger i = 0; i< 6; i++)
    {
        CGFloat height = [arrayHeight[i] floatValue];
        _viewContent[i]=[[UIView alloc]init];;
        _viewContent[i].frame=CGRectMake(x, y, width,height);
        [_viewContent[i] setBackgroundColor:[UIColor clearColor]];
        [_viewTop addSubview:_viewContent[i]];
        _viewContent[i].layer.masksToBounds = YES;
        _viewContent[i].clipsToBounds = YES;
        [_viewContent[i].layer setCornerRadius:30.0];
        _viewContent[i].tag = i+200;
        
        _tap[i] = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_viewContent[i] addGestureRecognizer:_tap[i]];
        
        y += height;
    }
    
    [_viewContent[0] removeGestureRecognizer:_tap[0]];
    
    _viewUserHeadContainer = [[UIView alloc]init];
    [_viewUserHeadContainer setFrame:RectWithScale(CGRectMake(65, 145, 210, 210), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewUserHeadContainer setBackgroundColor:[UIColor whiteColor]];
    _viewUserHeadContainer.layer.shadowColor = [UIColor grayColor].CGColor;
    _viewUserHeadContainer.layer.shadowOffset = CGSizeMake(0,0);
    _viewUserHeadContainer.layer.shadowOpacity = 1;
    _viewUserHeadContainer.layer.shadowRadius = 2;
    _viewUserHeadContainer.layer.cornerRadius = ((210.0/2.0)*(GPCommonLayoutScaleSizeWidthIndex));
    [_viewTop addSubview:_viewUserHeadContainer];
    
    
    
    _imageViewUserHead = [[UIImageView alloc]init];
    [_imageViewUserHead setBackgroundColor:[UIColor clearColor]];
    [_imageViewUserHead setImage:GetImageUseColor([UIColor blackColor], CGRectMake(0, 0, 1, 1))];
    [_imageViewUserHead setFrame:RectWithScale(CGRectMake(70, 150, 200, 200), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewUserHead setContentMode:contentModeDefault];
    _imageViewUserHead.layer.masksToBounds = YES;
    _imageViewUserHead.layer.cornerRadius = 100*GPCommonLayoutScaleSizeWidthIndex;
    [_viewTop addSubview:_imageViewUserHead];
    
    
    
    
    _labelUserNickName = [[UILabel alloc]init];
    _labelUserNickName.frame = RectWithScale(CGRectMake(300, 170, 700, 80), GPCommonLayoutScaleSizeWidthIndex);
    _labelUserNickName.textColor = [UIColor whiteColor];
    _labelUserNickName.textAlignment = NSTextAlignmentLeft;
    _labelUserNickName.font = FontMediumWithSize(20);
    [_viewTop addSubview:_labelUserNickName];
    _labelUserNickName.text = @"旺疯";
    
    
    
    _labelUserPhoneNumber = [[UILabel alloc]init];
    _labelUserPhoneNumber.frame = RectWithScale(CGRectMake(300, 260, 700, 70), GPCommonLayoutScaleSizeWidthIndex);
    _labelUserPhoneNumber.textColor = [UIColor whiteColor];
    _labelUserPhoneNumber.textAlignment = NSTextAlignmentLeft;
    _labelUserPhoneNumber.font = FontMediumWithSize(20);
    [_viewTop addSubview:_labelUserPhoneNumber];
    _labelUserPhoneNumber.text = @"185****5678";
    
    _imageViewWallet = [[UIImageView alloc]init];
    [_imageViewWallet setFrame:RectWithScale(CGRectMake(100, 435, 880, 135), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewWallet setImage:GetImage(@"组1拷贝")];
    [_viewTop addSubview:_imageViewWallet];
    _imageViewWallet.userInteractionEnabled= YES;
    
    _imageViewWalletContent = [[UIImageView alloc]init];
    [_imageViewWalletContent setFrame:RectWithScale(CGRectMake(54, 34, 40, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewWalletContent setImage:GetImage(@"钱包2")];
    [_imageViewWallet addSubview:_imageViewWalletContent];
    
    _labelWallet = [[UILabel alloc]init];
    _labelWallet.frame = RectWithScale(CGRectMake(110, 34, 480, 40), GPCommonLayoutScaleSizeWidthIndex);
    _labelWallet.textColor = rgb(249, 219, 180);
    _labelWallet.textAlignment = NSTextAlignmentLeft;
    _labelWallet.font = FontRegularWithSize(16);
    [_imageViewWallet addSubview:_labelWallet];
    _labelWallet.text = @"钱包";
    
    _labelWalletDescribe = [[UILabel alloc]init];
    _labelWalletDescribe.frame = RectWithScale(CGRectMake(110, 90, 480, 20), GPCommonLayoutScaleSizeWidthIndex);
    _labelWalletDescribe.textColor = rgb(249, 219, 180);
    _labelWalletDescribe.textAlignment = NSTextAlignmentLeft;
    _labelWalletDescribe.font = FontRegularWithSize(12);
    [_imageViewWallet addSubview:_labelWalletDescribe];
    _labelWalletDescribe.text = @"购物领积分折扣超划算～";
    
    _buttonWallet=[UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonWallet setFrame:RectWithScale(CGRectMake(630,34,196,68), GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonWallet setBackgroundImage:GetImage(@"go按钮") forState:UIControlStateNormal];
    [_buttonWallet setTitle:@"go >>" forState:UIControlStateNormal];
    [_buttonWallet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonWallet setTag:99];
    [_buttonWallet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_imageViewWallet addSubview:_buttonWallet];

    
    _labelContentFirstTitle = [[UILabel alloc]init];
    _labelContentFirstTitle.frame = RectWithScale(CGRectMake(65, 50, 900, 40), GPCommonLayoutScaleSizeWidthIndex);
    _labelContentFirstTitle.textColor = kColorFontMedium;
    _labelContentFirstTitle.textAlignment = NSTextAlignmentLeft;
    _labelContentFirstTitle.font = FontRegularWithSize(16);
    [_viewContent[0] addSubview:_labelContentFirstTitle];
    _labelContentFirstTitle.text = @"我的订单";
//    imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    NSArray *arrayImageName = @[@"待付款",@"代发货",@"代发货",@"完成"];//,@"取消"
    NSArray *arrayTitleName = @[@"待付款",@"待发货",@"待收货",@"已完成"];//,@"已取消"
    
    NSInteger lieContent = arrayTitleName.count;
    CGFloat xContent = 112;
    CGFloat yContent = 150;
    CGFloat widthContent = 100.0;
    CGFloat heightContent = 100.0;
    CGFloat jianjuContent = 152;
    
    for (NSInteger i = 0; i < arrayTitleName.count; i++)
    {
        _buttonContentFirst[i]=[UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonContentFirst[i] setFrame:RectWithScale(CGRectMake(xContent+(widthContent+jianjuContent)*(i%lieContent), yContent+(heightContent+60)*(i/lieContent), widthContent, heightContent), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonContentFirst[i] setBackgroundImage:GetImage([arrayImageName objectAtIndex:i]) forState:UIControlStateNormal];
        [_buttonContentFirst[i] setTitle:[arrayTitleName objectAtIndex:i] forState:UIControlStateNormal];
        [_buttonContentFirst[i] setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_buttonContentFirst[i] setTag:i+1];
        [_buttonContentFirst[i] addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewContent[0] addSubview:_buttonContentFirst[i]];
        
        _buttonContentFirst[i].badgeStyle = BadgeStyleNumber;
        _buttonContentFirst[i].shouldHideBadgeAtZero = YES;
        _buttonContentFirst[i].shouldAnimateBadge = YES;
        
        _labelContentFirst[i] = [[UILabel alloc]init];
        [_labelContentFirst[i] setFrame:RectWithScale(CGRectMake(xContent -30+(widthContent+jianjuContent)*(i%lieContent), yContent+(heightContent+60)*(i/lieContent)+heightContent+20, widthContent + 60, 30), GPCommonLayoutScaleSizeWidthIndex)];
        _labelContentFirst[i].text = [arrayTitleName objectAtIndex:i];
        _labelContentFirst[i].textColor = kColorFontMedium;
        _labelContentFirst[i].textAlignment = NSTextAlignmentCenter;
        _labelContentFirst[i].font = FontRegularWithSize(12);
        [_viewContent[0] addSubview:_labelContentFirst[i]];
    }
    
    UIImage *imageMirrored = [UIImage imageWithCGImage:GetImage([arrayImageName objectAtIndex:2]).CGImage scale:1 orientation:UIImageOrientationUpMirrored];
    [_buttonContentFirst[2] setBackgroundImage:imageMirrored forState:UIControlStateNormal];
    
    NSArray *arrayImageNameContent = @[@"资料",@"密码",@"支付密码",@"地址",@"退出"];
    NSArray *arrayTitleNameContent = @[@"个人资料",@"登录密码",@"支付密码",@"收货地址",@"退出登录"];
    
    for (NSInteger i = 0; i<5; i++) {
        _imageViewContent[i] = [[UIImageView alloc]init];
        [_imageViewContent[i] setBackgroundColor:[UIColor clearColor]];
        [_imageViewContent[i] setImage:GetImage(arrayImageNameContent[i])];
        [_imageViewContent[i] setFrame:RectWithScale(CGRectMake(70, 34, 70, 70), GPCommonLayoutScaleSizeWidthIndex)];
        [_viewContent[i+1] addSubview:_imageViewContent[i]];
        
        
        _labelContent[i] = [[UILabel alloc]init];
        _labelContent[i].frame = RectWithScale(CGRectMake(175, 50, 850, 50), GPCommonLayoutScaleSizeWidthIndex);
        _labelContent[i].textColor = kColorFontMedium;
        _labelContent[i].textAlignment = NSTextAlignmentLeft;
        _labelContent[i].font = FontRegularWithSize(16);
        [_viewContent[i+1] addSubview:_labelContent[i]];
        _labelContent[i].text = arrayTitleNameContent[i];
    }
}

-(void)tapClick:(UIGestureRecognizer*)tap
{
    NSInteger index = tap.view.tag - 200;
    if (index == 1) {
        PersonnalInfoViewController *vc = [[PersonnalInfoViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 2) {
        SetLoginPasswordViewController *vc = [[SetLoginPasswordViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 3) {
        SetPayPasswordViewController *vc = [[SetPayPasswordViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 4) {
        AddressListViewController *vc = [[AddressListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 5) {
        [HPUserDefault removeUserDefaultObjectFromKey:@"token"];
        [HPUserDefault removeUserDefaultObjectFromKey:@"userid"];
        
        //设置indextabbar为主窗口的根视图控制器
        LoginViewController *vc = [[LoginViewController alloc]init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:vc];
        GPKeyWindow.rootViewController = nav;
        [GPKeyWindow makeKeyAndVisible];
    }
}

-(void)buttonClick:(UIButton*)btn
{
    if (btn.tag == 99) {
        WalletViewController *vc = [[WalletViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
//        VerifiedViewController *vc = [[VerifiedViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        
        NSString *buttonName = btn.titleLabel.text;
        
//        NSArray *arrayTitleName = @[@"待付款",@"待发货",@"已完成",@"已取消"];
//        NSInteger i = [arrayTitleName indexOfObject:buttonName];
        
        OrderListViewController *vc = [[OrderListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.stringSelected = buttonName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    return;
    NSString *buttonName = btn.titleLabel.text;
    if ([buttonName containsString:@"待付款"])
    {
        
    }
    else if([buttonName containsString:@"待发货"])
    {
        
    }
    else if([buttonName containsString:@"已完成"])
    {
        
    }
    else if([buttonName containsString:@"已取消"])
    {
        
    }
}

//-(void)sdWEbDownloaderRegister{
//    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.defaultImageLoader;
//    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers) {
//
//        NSFileManager *fm = [[NSFileManager alloc] init];
//        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
//        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
//        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
//
//        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
//
//        NSDate *lastModifiedDate = nil;
//
//        if (fileAttr.count > 0) {
//            if (fileAttr.count > 0) {
//                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
//            }
//
//        }
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
//
//        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
//        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
//        [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
//
//        return mutableHeaders;
//    };
//}

-(void)netRequest
{
    [HPNetManager POSTWithUrlString:Hostmemberindex isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
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

-(void)updateInterfaceWithDic:(NSDictionary*)dic
{
    NSDictionary *dicMemberInfo = dic[@"member_info"];
    
    NSString *stringusername = dicMemberInfo[@"user_name"];
    _labelUserNickName.text = stringusername;
    
    NSString *stringmobile = dicMemberInfo[@"mobile"];
    _labelUserPhoneNumber.text = stringmobile;
    
    NSString *stringavator = dicMemberInfo[@"avator"];
    [_imageViewUserHead sd_setImageWithURL:URL(stringavator) placeholderImage:defaultImage options:SDWebImageRefreshCached];
    
    NSString *stringorder_nopay_count = [NSString stringWithFormat:@"%@",dicMemberInfo[@"order_nopay_count"]];
    _buttonContentFirst[0].badgeValue = stringorder_nopay_count;
    
    NSString *stringorder_noreceipt_count = [NSString stringWithFormat:@"%@",dicMemberInfo[@"order_noreceipt_count"]];
    _buttonContentFirst[1].badgeValue = stringorder_noreceipt_count;
    
    NSString *stringorder_notakes_count = [NSString stringWithFormat:@"%@",dicMemberInfo[@"order_notakes_count"]];
    _buttonContentFirst[2].badgeValue = stringorder_notakes_count;
    
    NSString *stringorder_noeval_count = [NSString stringWithFormat:@"%@",dicMemberInfo[@"order_noeval_count"]];
    _buttonContentFirst[3].badgeValue = stringorder_noeval_count;
}

@end
