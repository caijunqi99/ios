//
//  ConfirmOrderToPayViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/25.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ConfirmOrderToPayViewController.h"

#import "InputPayPassword.h"

#import "OrderPaidSuccessViewController.h"

@interface ConfirmOrderToPayViewController ()<InputPayPasswordViewDelegate>
{
    UILabelAlignToTopLeft   *_labelTemp[5];
    
    NSMutableArray          *_arrayDataSource;
    
    NSString                *_string_member_available_pd;
    NSString                *_string_pay_amount;
    
    
//    NSString                *_string_password;
}
@property(nonatomic,strong)UIView               *viewTemp;
@property(nonatomic,strong)UIView               *viewTempII;

@property(nonatomic,strong)UIImageView          *imageViewTemp;

@property(nonatomic,strong)UIButton             *buttonTemp;
@property(nonatomic,strong)UIButton             *buttonBalance;

@property(nonatomic,strong)UIButton             *buttonSelected;


@end

#define kBottomHeightCommon        (130*GPCommonLayoutScaleSizeWidthIndex)

@implementation ConfirmOrderToPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    [self netRequest];
}

-(instancetype)init
{
    if (self = [super init]) {
        _arrayDataSource = [[NSMutableArray alloc]init];
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
    [self settingNavTitle:@"订单支付"];
    
    viewSetBackgroundColor(kColorBasic);
    
    [self.viewTemp setFrame:CGRectMake(0, 10*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth, 160*GPCommonLayoutScaleSizeWidthIndex)];
    [self.view addSubview:self.viewTemp];
    
    [self.view addSubview:self.viewTempII];
    [self.viewTempII setFrame:CGRectMake(0, self.viewTemp.bottom + 130*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth, 160*GPCommonLayoutScaleSizeWidthIndex)];
    
    NSArray *arrayLabelText = @[@"订单金额",@"¥",@"支付方式",@"储值卡支付",@"储值卡:¥"];
    
    for (NSInteger i = 0; i<5; i++) {
        
        _labelTemp[i] = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:arrayLabelText[i]];
        _labelTemp[i].lineBreakMode = NSLineBreakByCharWrapping;
        _labelTemp[i].backgroundColor = [UIColor clearColor];
    }
    
    [_labelTemp[0] setFrame:RectWithScale(CGRectMake(40, 50, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewTemp addSubview:_labelTemp[0]];
    [_labelTemp[0] setTextColor:[UIColor blackColor]];
    _labelTemp[0].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[1] setFrame:RectWithScale(CGRectMake(600, 50, 400, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewTemp addSubview:_labelTemp[1]];
    [_labelTemp[1] setTextColor:kColorTheme];
    _labelTemp[1].textAlignment = NSTextAlignmentRight;
    
    [_labelTemp[2] setFrame:RectWithScale(CGRectMake(40, 170 + 35, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [self.view addSubview:_labelTemp[2]];
    [_labelTemp[2] setTextColor:[UIColor grayColor]];
    _labelTemp[2].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[3] setFrame:RectWithScale(CGRectMake(220, 50, 210, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewTempII addSubview:_labelTemp[3]];
    [_labelTemp[3] setTextColor:[UIColor blackColor]];
    _labelTemp[3].textAlignment = NSTextAlignmentLeft;
    
    [_labelTemp[4] setFrame:RectWithScale(CGRectMake(450, 50, 400, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewTempII addSubview:_labelTemp[4]];
    [_labelTemp[4] setTextColor:[UIColor grayColor]];
    _labelTemp[4].textAlignment = NSTextAlignmentLeft;
    
    
    
    
    
    [self.buttonBalance setFrame:RectWithScale(CGRectMake(50, 60, 40, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [self.buttonBalance setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.viewTempII addSubview:self.buttonBalance];
    
    [self.imageViewTemp setFrame:RectWithScale(CGRectMake(120, 45, 63, 70), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewTempII addSubview:self.imageViewTemp];
    
    
    [self.view addSubview:self.buttonTemp];
    [self.buttonTemp setFrame:CGRectMake(0, GPScreenHeight - kBottomHeightCommon - kNavBarAndStatusBarHeight, GPScreenWidth, kBottomHeightCommon)];
}

-(void)leftClick
{
    HPNOTIF_POST(@"orderPayCancel", nil);
    [self popToController:@"GoodsViewController"];
    [self popToController:@"ShoppingCartViewController"];
    [self popToController:@"OrderListViewController"];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    
}

-(BOOL)checkAll
{
    
    if (_buttonSelected != _buttonBalance) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请选择支付方式" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }else{
        if ([_string_member_available_pd floatValue]<[_string_pay_amount floatValue]) {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"余额不足,请充值" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

-(void)netRequestToPayWithPassword:(NSString *)password
{
    [HPNetManager POSTWithUrlString:HostMemberpaymentpay_new isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_string_pay_sn,@"pay_sn",password,@"password",@"1",@"pd_pay",@"predeposit",@"payment_code", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            OrderPaidSuccessViewController *vc = [[OrderPaidSuccessViewController alloc]init];
            [vc setPay_amount:self->_string_pay_amount andDraw:[NSString stringWithFormat:@"%@",response[@"result"][@"draw"]] andPay_sn:self->_string_pay_sn];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {

    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}


-(void)netRequest
{
    [HPNetManager POSTWithUrlString:Hostmemberbuypay isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_string_pay_sn,@"pay_sn", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            
            self->_string_member_available_pd = response[@"result"][@"pay_info"][@"member_available_pd"];
            self->_string_pay_amount = response[@"result"][@"pay_info"][@"pay_amount"];
            [self->_labelTemp[4] setText:[NSString stringWithFormat:@"余额: ¥ %@",self->_string_member_available_pd]];
            [self->_labelTemp[1] setText:[NSString stringWithFormat:@"¥ %@",self->_string_pay_amount]];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {

    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}

-(void)tapClick:(UIGestureRecognizer*)tap
{
    NSString *strurl = @"asd";
    if (!IsStringEmptyOrNull(strurl))
    {
        
    }
}

-(void)buttonClick:(UIButton*)btn
{
    if (_buttonBalance == btn) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            [btn setImage:GetImage(@"选中") forState:UIControlStateNormal];
            _buttonSelected = _buttonBalance;
        }
        else
        {
            [btn setImage:GetImage(@"椭圆") forState:UIControlStateNormal];
            _buttonSelected = nil;
        }
    }
    else if (_buttonTemp == btn)
    {
        if ([self checkAll]) {
            InputPayPassword *view = [[InputPayPassword alloc]init];
            view.delegate = self;
            [view show];
        }
    }
}

-(void)InputPayPasswordView:(InputPayPassword *)view didClickSureWithPassword:(NSString *)password
{
    [self netRequestToPayWithPassword:password];
}

#pragma mark - lazy load懒加载

-(UIView *)viewTemp
{
    if (!_viewTemp) {
        _viewTemp = [UIView initViewBackColor:[UIColor whiteColor]];
    }
    return _viewTemp;
}

-(UIView *)viewTempII
{
    if (!_viewTempII) {
        _viewTempII = [UIView initViewBackColor:[UIColor whiteColor]];
    }
    return _viewTempII;
}

-(UIImageView *)imageViewTemp
{
    if (!_imageViewTemp) {
        _imageViewTemp = [UIImageView initImageView:@"现金支付"];
    }
    return _imageViewTemp;
}

-(UIButton *)buttonTemp
{
    if (!_buttonTemp) {
        _buttonTemp = [UIButton initButtonTitleFont:22 titleColor:[UIColor whiteColor] backgroundColor:kColorTheme imageName:@"" titleName:@"确认支付"];
        [_buttonTemp addTarget:self tag:11 action:@selector(buttonClick:)];
    }
    return _buttonTemp;
}

-(UIButton *)buttonBalance
{
    if (!_buttonBalance) {
        _buttonBalance = [UIButton initButtonTitleFont:22 titleColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] imageName:nil titleName:@""];
        [_buttonBalance setBackgroundImage:GetImage(@"椭圆") forState:UIControlStateNormal];
        [_buttonBalance addTarget:self tag:13 action:@selector(buttonClick:)];
    }
    return _buttonBalance;
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
