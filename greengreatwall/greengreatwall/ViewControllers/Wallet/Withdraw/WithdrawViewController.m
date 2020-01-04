//
//  WithdrawViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/2.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "WithdrawViewController.h"


@interface WithdrawViewController ()<UITextFieldDelegate>
{
    UIView                  *_viewBack;
    UIImageView             *_imageViewBack;
    
    UILabelAlignToTopLeft   *_labelTemp[6];
    UITextField             *_textFieldTemp[2];
    
    UIButton                *_buttonTemp;
    UIButton                *_buttonAll;
    UIButton                *_buttonGetCode;
    
    UIButton                *_buttonSelect;
    
    NSMutableArray          *_arrayDataSource;
    
    NSString                *_string_commission;
}


@end


@implementation WithdrawViewController

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
    [self settingNavTitle:@"提现"];
    
    viewSetBackgroundColor(kColorBasic);
    
    _viewBack = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewBack setFrame:RectWithScale(CGRectMake(0, 0, 1080, 1050), GPCommonLayoutScaleSizeWidthIndex)];
    [self.view addSubview:_viewBack];
    
    _imageViewBack = [[UIImageView alloc]init];
    [_imageViewBack setFrame:RectWithScale(CGRectMake(40, 65, 1000, 378), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewBack setImage:GetImage(@"钱包背景图")];
    [self.view addSubview:_imageViewBack];
    _imageViewBack.userInteractionEnabled= NO;
    
    
    
    NSArray *arrayLabelText = @[@"可用积分",@"",@"最低提现积分:",@"提现积分",@"手续费:",@"验证码"];//@"请填写持卡人银行卡信息",@"持卡人",@"卡号",@"开户行",
    //    NSArray *arrayPlaceHolderText = @[@"请输入提现积分数量",@"请输入验证码"];//@"请输入真实姓名",@"请输入银行卡号",@"请输入开户行",
    
    for (NSInteger i = 0; i<arrayLabelText.count; i++) {
        
        _labelTemp[i] = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:arrayLabelText[i]];
        _labelTemp[i].lineBreakMode = NSLineBreakByCharWrapping;
        _labelTemp[i].backgroundColor = [UIColor clearColor];
        [_labelTemp[i] setFrame:RectWithScale(CGRectMake(40, 0, 160, 120), GPCommonLayoutScaleSizeWidthIndex)];
        
        if (i<5) {
            [self.view addSubview:_labelTemp[i]];
        }else if (i == 5){
            
        }
    }
    
    _textFieldTemp[1] = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"请输入验证码"];
    _textFieldTemp[1].keyboardType = UIKeyboardTypeDefault;
    UIView *viewLeft1 = [UIView initViewBackColor:[UIColor clearColor]];
    [viewLeft1 setFrame:RectWithScale(CGRectMake(0, 0, 240, 120), GPCommonLayoutScaleSizeWidthIndex)];
    [viewLeft1 addSubview:_labelTemp[5]];
    _textFieldTemp[1].leftView = viewLeft1;
    _textFieldTemp[1].leftView.contentMode = UIViewContentModeScaleAspectFit;
    _textFieldTemp[1].leftView.layer.masksToBounds = YES;
    _textFieldTemp[1].leftView.clipsToBounds = YES;
    _textFieldTemp[1].leftViewMode = UITextFieldViewModeAlways;
    [_textFieldTemp[1] setFrame:RectWithScale(CGRectMake(0, 910, 1080, 120), GPCommonLayoutScaleSizeWidthIndex)];
    _textFieldTemp[1].delegate = self;
    
    
    _buttonGetCode = [UIButton initButtonTitleFont:22 titleColor:kColorTheme backgroundColor:[UIColor clearColor] imageName:nil titleName:@"获取验证码"];
    [_buttonGetCode addTarget:self tag:14 action:@selector(buttonClick:)];
    [_buttonGetCode setFrame:RectWithScale(CGRectMake(0, 40, 250, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    UIView *viewRight1 = [UIView initViewBackColor:[UIColor clearColor]];
    [viewRight1 setFrame:RectWithScale(CGRectMake(0, 0, 300, 120), GPCommonLayoutScaleSizeWidthIndex)];
    [viewRight1 addSubview:_buttonGetCode];
    _textFieldTemp[1].rightView = viewRight1;
    _textFieldTemp[1].rightView.contentMode = UIViewContentModeScaleAspectFit;
    _textFieldTemp[1].rightView.layer.masksToBounds = YES;
    _textFieldTemp[1].rightView.clipsToBounds = YES;
    _textFieldTemp[1].rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_textFieldTemp[1]];
    
    [_labelTemp[0] setFrame:RectWithScale(CGRectMake(100, 100, 880, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelTemp[1] setFrame:RectWithScale(CGRectMake(100, 190, 880, 100), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelTemp[2] setFrame:RectWithScale(CGRectMake(100, 350, 880, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelTemp[3] setFrame:RectWithScale(CGRectMake(40, 460, 300, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelTemp[4] setFrame:RectWithScale(CGRectMake(800, 760, 240, 40), GPCommonLayoutScaleSizeWidthIndex)];
    //    [_labelTemp[5] setFrame:RectWithScale(CGRectMake(40, 840, 1000, 60), GPCommonLayoutScaleSizeWidthIndex)];
    
    
    [_labelTemp[0]setTextColor:[UIColor whiteColor]];
    [_labelTemp[1]setTextColor:[UIColor whiteColor]];
    [_labelTemp[2]setTextColor:[UIColor whiteColor]];
    [_labelTemp[4]setTextColor:kColorTheme];
    //    [_labelTemp[5]setTextColor:rgb(152, 153, 154)];
    
    
    
    
    _buttonAll = [UIButton initButtonTitleFont:22 titleColor:kColorTheme backgroundColor:[UIColor clearColor] imageName:nil titleName:@"全部"];
    [_buttonAll addTarget:self tag:13 action:@selector(buttonClick:)];
    [_buttonAll setFrame:RectWithScale(CGRectMake(800, 460, 200, 60), GPCommonLayoutScaleSizeWidthIndex)];
    [self.view addSubview:_buttonAll];
    
    
    
    
    
    
    _buttonTemp = [UIButton initButtonTitleFont:22 titleColor:[UIColor whiteColor] backgroundColor:kColorTheme imageName:@"" titleName:@"提现"];
    [_buttonTemp addTarget:self tag:11 action:@selector(buttonClick:)];
    [self.view addSubview:_buttonTemp];
    [_buttonTemp setFrame:CGRectMake(self.view.centerX - 395*GPCommonLayoutScaleSizeWidthIndex, GPScreenHeight - kNavBarAndStatusBarHeight - 270*GPCommonLayoutScaleSizeWidthIndex, 790*GPCommonLayoutScaleSizeWidthIndex, 790*(110.0/790.0)*GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonTemp rounded:(55.0*GPCommonLayoutScaleSizeWidthIndex)];
    
    _textFieldTemp[0] = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"请输入提现积分数量"];
    _textFieldTemp[0].textColor = [UIColor blackColor];
    _textFieldTemp[0].keyboardType = UIKeyboardTypeNumberPad;
    _textFieldTemp[0].placeholder = @"请输入提现积分数量";
    _textFieldTemp[0].delegate = self;
    [_textFieldTemp[0] setBackgroundColor:rgb(244, 245, 246)];
    [_textFieldTemp[0] setFrame:RectWithScale(CGRectMake(40, 600, 1000, 120), GPCommonLayoutScaleSizeWidthIndex)];
    [self.view addSubview:_textFieldTemp[0]];
    //    [self.view bringSubviewToFront:_textFieldTemp[0]];
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
    if ([_textFieldTemp[0].text floatValue] > [_labelTemp[1].text floatValue]) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"可用积分不足" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    if (IsStringEmptyOrNull(_textFieldTemp[0].text)){
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请输入提现积分数量" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    
    if (IsStringEmptyOrNull(_textFieldTemp[1].text)){
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请输入验证码" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    
    return YES;
}

-(void)netRequest
{
    //    HPWeak;
    
    [HPNetManager POSTWithUrlString:Hostmembermy_asset isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            self->_labelTemp[1].text = [NSString stringWithFormat:@"%@",response[@"result"][@"available"]];
            self->_labelTemp[2].text = [NSString stringWithFormat:@"最低提现积分:%@",response[@"result"][@"withdraw"]];
            self->_labelTemp[4].text = [NSString stringWithFormat:@"手续费:%@%%",response[@"result"][@"commission"]];
            self->_string_commission = response[@"result"][@"commission"];
            
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

-(void)netRequestGetVerify
{
    [HPNetManager GETWithUrlString:HostConnectget_sms_captcha isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"username"],@"member_mobile",@"6",@"type", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        
        if ([response[@"code"] integerValue] == 200) {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:[NSString stringWithFormat:@"验证码已发送,有效时间%@分钟",response[@"result"][@"sms_time"]] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

-(void)uploadInfo
{
    HPWeak;
    /**
     *提现申请
     *https://shop.bayi-shop.com/mobile/member/my_withdraw
     *key                   token
     *amount                提现金额
     *commission            手续费比例
     *memberbank_name       开户行
     *memberbank_no         银行卡账号
     *memberbank_truename   持卡人姓名
     */
    [HPNetManager POSTWithUrlString:Hostmembermy_withdraw isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_textFieldTemp[0].text,@"amount",_string_commission,@"commission",_textFieldTemp[0].text,@"amount", nil] successBlock:^(id response) {
        
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"提交申请成功" callbackBlock:^(NSInteger btnIndex) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                //                HPNOTIF_POST(@"refreshAddressList", nil);
            } cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确定",nil];
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
    //    NSInteger index = tap.view.tag - 200;
    NSString *strurl = @"asd";
    if (!IsStringEmptyOrNull(strurl))
    {
        
    }
}

-(void)buttonClick:(UIButton*)btn
{
    _buttonSelect = btn;
    if (_buttonGetCode == btn) {
        [self netRequestGetVerify];
    }
    else if (_buttonAll == btn)
    {
        [_textFieldTemp[0] setText:_labelTemp[1].text];
    }
    else if (_buttonTemp == btn)
    {
        if ([self checkAll]) {
            [self uploadInfo];
        }
    }
}

#pragma mark - lazy load懒加载


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
