//
//  RechargeViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/29.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "RechargeViewController.h"

#import "RechargeBottomView.h"

#import "RechargeSuccessViewController.h"

//微信开放平台sdk，支付
#import <WXApi.h>
//支付宝sdk
#import <AlipaySDK/AlipaySDK.h>

@interface RechargeViewController ()<UITextFieldDelegate,WXApiDelegate>
{
    UIView              *_viewTop;
    
    UILabel             *_labelContent[5];
    UIButton            *_buttonContentAmount[4];
    UIButton            *_buttonContent[3];
    
    UIButton            *_buttonSelectedType;
    
    NSString            *_stringpayment_code;
    NSString            *_stringpdr_amount;
    
    
    UITextField         *_textFieldAnotherAmount;
    
    RechargeBottomView  *_bottomView;
    
    NSMutableArray      *_arrayDataSource;
    
    NSObject            *_object;
}
@end

#define kBottomHeightShoppingCart        (180*GPCommonLayoutScaleSizeWidthIndex)

@implementation RechargeViewController

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
        _arrayDataSource = [[NSMutableArray alloc]initWithCapacity:0];
        HPNOTIF_ADDWithObject(@"paysuccess", paysuccess:, _object);
        HPNOTIF_ADDWithObject(@"paycancel", paycancel:,_object);
        HPNOTIF_ADDWithObject(@"payfail", payfail:,_object);
    }
    return self;
}

-(void)paysuccess:(NSNotification *)notifi
{
    NSObject *object = notifi.object;
    
    RechargeSuccessViewController *vc = [[RechargeSuccessViewController alloc]init];
    [vc setPay_amount:self->_stringpdr_amount];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)paycancel:(NSNotification *)notifi
{
    
    [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"支付已取消" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
}
-(void)payfail:(NSNotification *)notifi
{
    [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:[NSString stringWithFormat:@"支付失败,status:%@",notifi.object] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
}

-(void)dealloc
{
    HPNOTIF_REMV();
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)configInterface
{
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    [self settingNavTitle:@"我的钱包"];
    viewSetBackgroundColor(kColorBasic);
    
    _viewTop = [[UIView alloc]init];
    _viewTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewTop];
    
    [_viewTop setFrame:CGRectMake(0, 0, GPScreenWidth, 1300*GPCommonLayoutScaleSizeWidthIndex)];
    
    NSArray *arrayImageName = @[@"支付宝支付",@"微信支付"];//,@"银联"
    NSArray *arrayTitleName = @[@"支付宝支付",@"微信支付"];//,@"线下汇款"
    
    for (NSInteger i = 0; i< arrayTitleName.count; i++)
    {
        
        _buttonContent[i]=[UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonContent[i] setFrame:RectWithScale(CGRectMake(55, 860 + i*200, 970,160), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonContent[i] setBackgroundImage:GetImage(@"支付未选中") forState:UIControlStateNormal];
        [_buttonContent[i] setBackgroundImage:GetImage(@"支付选中") forState:UIControlStateSelected];
        [_buttonContent[i] setImage:GetImage([arrayImageName objectAtIndex:i]) forState:UIControlStateNormal];
        [_buttonContent[i] setTitle:[arrayTitleName objectAtIndex:i] forState:UIControlStateNormal];
        [_buttonContent[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buttonContent[i] setTitleColor:kColorTheme forState:UIControlStateSelected];
        [_buttonContent[i] setTag:i+1];
        [_buttonContent[i] addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonContent[i] setImageEdgeInsets:UIEdgeInsetsMake(0, -500*GPCommonLayoutScaleSizeWidthIndex, 0, 0)];
        [_buttonContent[i] setTitleEdgeInsets:UIEdgeInsetsMake(0, -400*GPCommonLayoutScaleSizeWidthIndex, 0, 0)];
        [_viewTop addSubview:_buttonContent[i]];
    }
    
    NSArray *arrayTitleAmount = @[@"50元",@"100元",@"500元",@"1000元"];
    
    
    for (NSInteger i = 0; i < arrayTitleAmount.count; i++)
    {
        _buttonContentAmount[i]=[UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonContentAmount[i] setFrame:RectWithScale(CGRectMake(70+240*(i%4), 210, 200, 120), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonContentAmount[i] setBackgroundImage:CreateImageWithColor(rgb(221, 231, 235)) forState:UIControlStateNormal];
        [_buttonContentAmount[i] setBackgroundImage:CreateImageWithColor(kColorTheme) forState:UIControlStateSelected];
        [_buttonContentAmount[i] setTitle:[arrayTitleAmount objectAtIndex:i] forState:UIControlStateNormal];
        [_buttonContentAmount[i] setTitleColor:rgb(140, 141, 142) forState:UIControlStateNormal];
        [_buttonContentAmount[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_buttonContentAmount[i] setTag:i+1];
        [_buttonContentAmount[i] addTarget:self action:@selector(buttonClickAmount:) forControlEvents:UIControlEventTouchUpInside];
        [_viewTop addSubview:_buttonContentAmount[i]];
    }
    
    NSArray *arrayTitleLabel = @[@"充值金额",@"其他充值金额",@"支付方式"];
    
    for (NSInteger i = 0; i < arrayTitleLabel.count; i++)
    {
        _labelContent[i] = [[UILabel alloc]init];
        [_labelContent[i] setFrame:RectWithScale(CGRectMake(50, 50 + 370*i, 500, 60), GPCommonLayoutScaleSizeWidthIndex)];
        _labelContent[i].text = [arrayTitleLabel objectAtIndex:i];
        _labelContent[i].textColor = kColorFontMedium;
        _labelContent[i].textAlignment = NSTextAlignmentLeft;
        _labelContent[i].font = FontRegularWithSize(20);
        [_viewTop addSubview:_labelContent[i]];
    }
    
    [_labelContent[2] setTop:720*GPCommonLayoutScaleSizeWidthIndex];
    
    _textFieldAnotherAmount = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"请输入金额"];
    _textFieldAnotherAmount.delegate = self;
    _textFieldAnotherAmount.keyboardType = UIKeyboardTypeNumberPad;
    [_viewTop addSubview:_textFieldAnotherAmount];
    [_textFieldAnotherAmount setFrame:RectWithScale(CGRectMake(50, 550, 500, 60), GPCommonLayoutScaleSizeWidthIndex)];
    
    UIView  *viewLine = [UIView initLineBackColor:[UIColor lightGrayColor] width:500*GPCommonLayoutScaleSizeWidthIndex height:1 maxY:_textFieldAnotherAmount.bottom+5];
    [_viewTop addSubview:viewLine];
    [viewLine setFrame:CGRectMake(_textFieldAnotherAmount.left, _textFieldAnotherAmount.bottom + 5, _textFieldAnotherAmount.width, 1)];
    
    _bottomView = [[RechargeBottomView alloc]initWithFrame:CGRectMake(0, GPScreenHeight - kNavBarAndStatusBarHeight - kBottomHeightShoppingCart, GPScreenWidth, kBottomHeightShoppingCart)];
    [self.view addSubview:_bottomView];
    
    HPWeak;
    _bottomView.AccountBlock = ^{
        if ([weakSelf checkAll]) {
            [weakSelf netRequest];
        }
    };
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    
}

-(BOOL)checkAll
{
    if (!((_buttonContent[0].selected)||(_buttonContent[1].selected))) {//||(_buttonContent[2].selected)
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请选择支付方式" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    
    NSString *stringAmount = [_bottomView.labelTotalPrice.text subStringFrom:@"充值金额: ¥ " to:@"元"];
    if ([stringAmount integerValue] == 0) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请选择或填写充值金额" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }else{
        return YES;
    }
}

-(void)buttonClick:(UIButton*)btn
{
    if (btn == _buttonContent[2]) {
        
    }
    else
    {
        [_buttonContent[0] setSelected:NO];
        [_buttonContent[1] setSelected:NO];
        //    [_buttonContent[2] setSelected:NO];
        _buttonSelectedType = btn;
        
        [btn setSelected:YES];
        NSString *buttonName = btn.titleLabel.text;
        if ([buttonName containsString:@"支付宝支付"])
        {
            _stringpayment_code = @"alipay_app";
        }
        else if([buttonName containsString:@"微信支付"])
        {
            _stringpayment_code = @"wxpay_app";
        }
    }
    
}

-(void)buttonClickAmount:(UIButton*)btn
{
    [_buttonContentAmount[0] setSelected:NO];
    [_buttonContentAmount[1] setSelected:NO];
    [_buttonContentAmount[2] setSelected:NO];
    [_buttonContentAmount[3] setSelected:NO];
    
    [btn setSelected:YES];
    [_bottomView.labelTotalPrice setText:[NSString stringWithFormat:@"充值金额: ¥ %@",btn.titleLabel.text]];
}



-(void)netRequest
{
    _stringpdr_amount = [_bottomView.labelTotalPrice.text subStringFrom:@"充值金额: ¥ " to:@"元"];
    [HPNetManager POSTWithUrlString:HostMemberpaymentPdaddPay isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_stringpdr_amount,@"pdr_amount",_stringpayment_code,@"payment_code", nil] successBlock:^(id response) {
        GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 10000) {
            
            NSString *orderString = response[@"result"][@"content"];
            if ([self->_stringpayment_code isEqualToString:@"alipay_app"]) {
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"greengreatwall" callback:^(NSDictionary *resultDic) {
                    
                }];
            }
            else if ([self->_stringpayment_code isEqualToString:@"wxpay_app"])
            {
                NSString *stringWX = response[@"result"][@"content"];
                NSData *data = [stringWX dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dicWx = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSString *stringtimestamp = dicWx[@"timestamp"];
                int timestamp = [stringtimestamp intValue];
                NSString *stringSIGN = [dicWx[@"sign"] uppercaseString];
                
                
                
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = dicWx[@"mch_id"];
                request.prepayId= dicWx[@"prepay_id"];
                request.package = @"Sign=WXPay";
                request.nonceStr= dicWx[@"nonce_str"];
                request.timeStamp= (UInt32)timestamp;
                request.sign= stringSIGN;
                [WXApi sendReq:request completion:^(BOOL success) {
                    
                }];
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

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!IsStringEmptyOrNull(textField.text)) {
        [_bottomView.labelTotalPrice setText:[NSString stringWithFormat:@"充值金额: ¥ %@元",textField.text]];
    }
}

-(void) onReq:(BaseReq*)reqonReq
{
    
}

-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                GPDebugLog(@"支付成功");
                break;
            default:
                GPDebugLog(@"支付失败，errCode=%d \
                           errStr=%@ ",response.errCode,response.errStr);
                break;
        }
    }
}

@end
