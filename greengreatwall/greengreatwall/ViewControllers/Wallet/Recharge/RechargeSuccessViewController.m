//
//  RechargeSuccessViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/29.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "RechargeSuccessViewController.h"

@interface RechargeSuccessViewController ()
{
    UIView              *_viewTop;
    
    UIImageView         *_imageViewTemp;
    UILabel             *_labelPayStatusSuccess;
    UILabel             *_labelPayAmount;
}


@property(nonatomic,strong)NSString * string_pay_sn;
@property(nonatomic,strong)NSString * string_pay_amount;
@property(nonatomic,strong)NSString * string_draw;

@end

@implementation RechargeSuccessViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
//    [self netRequest];
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
    
    
    _viewTop = [[UIView alloc]init];
    [_viewTop setFrame:CGRectMake(0, 0, GPScreenWidth, 360*GPCommonLayoutScaleSizeWidthIndex)];
    _viewTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewTop];
    
    _imageViewTemp = [UIImageView initImageView:@"购物成功"];
    [_imageViewTemp setFrame:RectWithScale(CGRectMake(380, 100, 60, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewTop addSubview:_imageViewTemp];
    
    _labelPayStatusSuccess = [[UILabel alloc]init];
    _labelPayStatusSuccess.frame = RectWithScale(CGRectMake(470, 90, 300, 80), GPCommonLayoutScaleSizeWidthIndex);
    _labelPayStatusSuccess.text = @"充值成功";
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
}

-(void)leftClick
{
    
}

-(void)rightClick
{
    [self popToController:@"WalletViewController"];
}

-(void)setPay_amount:(NSString *)pay_amount// andDraw:(NSString *)draw andPay_sn:(NSString *)pay_sn
{
    _string_pay_amount = pay_amount;
//    _string_draw = draw;
//    _string_pay_sn = pay_sn;
}

-(void)netRequest
{
    [HPNetManager POSTWithUrlString:HostGoodsgetRandGoods isNeedCache:NO parameters:nil successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
                
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

@end
