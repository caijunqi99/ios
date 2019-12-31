//
//  ResetPasswordViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/10.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "UILabelAlignToTopLeft.h"
@interface ResetPasswordViewController ()<UITextFieldDelegate>
{
    NSString            *_strParameter;
}

@property(nonatomic,strong)UIView               *viewTemp;

@property(nonatomic,strong)UIView               *viewLine;
@property(nonatomic,strong)UIView               *viewLineII;
@property(nonatomic,strong)UIView               *viewLineIII;
@property(nonatomic,strong)UIView               *viewLineIV;

@property(nonatomic,strong)UIImageView          *imageViewState;

@property(nonatomic,strong)UITextField          *textFieldUsername;
@property(nonatomic,strong)UITextField          *textFieldVerify;
@property(nonatomic,strong)UITextField          *textFieldPassword;
@property(nonatomic,strong)UITextField          *textFieldPasswordConfirm;

@property(nonatomic,strong)UIButton             *buttonGetVerifyCode;
@property(nonatomic,strong)UIButton             *buttonResetPassword;



@property(nonatomic,strong)UIView               *viewSuccess;
@property(nonatomic,strong)UIImageView          *imageViewStateII;
@property(nonatomic,strong)UIImageView          *imageViewStateSuccess;
@property(nonatomic,strong)UILabel              *labelStateSuccess;
@property(nonatomic,strong)UIButton             *buttonGotoLogin;

@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
}

-(instancetype)init
{
    if (self = [super init]) {
        _strParameter = @"1";
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
    [self settingNavTitle:@"忘记密码" WithNavTitleColor:[UIColor blackColor]];
    viewSetBackgroundColor(kColorViewBackground);
    
    
    [self.view addSubview:self.viewTemp];
    [self.viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight)];
    
    
    
    [self.viewTemp addSubview:self.imageViewState];
    [self.imageViewState setFrame:CGRectMake(self.viewTemp.centerX - 270*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.centerY - 700*GPCommonLayoutScaleSizeWidthIndex - kNavBarAndStatusBarHeight, 540*GPCommonLayoutScaleSizeWidthIndex, 540*(72.0/488.0)*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    [self.viewTemp addSubview:self.textFieldUsername];
    [self.textFieldUsername setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.centerY - 200*GPCommonLayoutScaleSizeWidthIndex - kNavBarAndStatusBarHeight, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.viewLine];
    [self.viewLine setFrame:CGRectMake(_textFieldUsername.left, _textFieldUsername.bottom, _textFieldUsername.width, 1)];
    
    [self.viewTemp addSubview:self.textFieldVerify];
    [self.textFieldVerify setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.textFieldUsername.bottom + 10*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    [self.viewTemp addSubview:self.viewLineII];
    [self.viewLineII setFrame:CGRectMake(_textFieldVerify.left, _textFieldVerify.bottom, _textFieldVerify.width, 1)];
    
    [self.viewTemp addSubview:self.textFieldPassword];
    [self.textFieldPassword setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.textFieldVerify.bottom + 10*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.viewLineIII];
    [self.viewLineIII setFrame:CGRectMake(_textFieldPassword.left, _textFieldPassword.bottom, _textFieldPassword.width, 1)];
    
    
    
    [self.viewTemp addSubview:self.textFieldPasswordConfirm];
    [self.textFieldPasswordConfirm setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.textFieldPassword.bottom + 10*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.viewLineIV];
    [self.viewLineIV setFrame:CGRectMake(_textFieldPasswordConfirm.left, _textFieldPasswordConfirm.bottom, _textFieldPasswordConfirm.width, 1)];
    
    
//    buttonResetPassword
//    buttonGotoLogin
    [self.viewTemp addSubview:self.buttonResetPassword];
    [self.buttonResetPassword setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.textFieldPasswordConfirm.bottom + 100*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 800*(54.0/372.0)*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    [self.viewSuccess setFrame:self.viewTemp.bounds];
    [self.view addSubview:self.viewSuccess];
    
    [self.imageViewStateII setFrame:self.imageViewState.frame];
    [self.viewSuccess addSubview:self.imageViewStateII];
    
    [self.imageViewStateSuccess setFrame:CGRectMake(self.viewSuccess.centerX - 183*GPCommonLayoutScaleSizeWidthIndex, self.textFieldUsername.top, 366*GPCommonLayoutScaleSizeWidthIndex, 312*GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewSuccess addSubview:self.imageViewStateSuccess];
    
    [self.labelStateSuccess setFrame:CGRectMake(self.viewSuccess.centerX - 150*GPCommonLayoutScaleSizeWidthIndex, self.imageViewStateSuccess.bottom +10, 300*GPCommonLayoutScaleSizeWidthIndex, 50*GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewSuccess addSubview:self.labelStateSuccess];
    
    [self.buttonGotoLogin setFrame:self.buttonResetPassword.frame];
    [self.viewSuccess addSubview:self.buttonGotoLogin];
    
    [self.viewSuccess setHidden:YES];
    
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
    HPWeak;
    [HPNetManager POSTWithUrlString:HostMemberaccountmodify_password_step4 isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_textFieldUsername.text,@"mobile_key",_textFieldVerify.text,@"auth_code",_textFieldPassword.text,@"password",_textFieldPasswordConfirm.text,@"confirm_password", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        

        if ([response[@"code"] integerValue] == 200) {
            
            [HPUserDefault addUserDefaultObject:self->_textFieldPassword.text key:@"password"];
            [self.viewTemp setHidden:YES];
            [self.viewSuccess setHidden:NO];
            
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
    [HPNetManager GETWithUrlString:HostConnectget_sms_captcha isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_textFieldUsername.text,@"member_mobile",@"6",@"type", nil] successBlock:^(id response) {
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

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
    if ([buttonName containsString:@"获取验证码"])
    {
        if (IsStringEmptyOrNull(_textFieldUsername.text)) {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请填写手机号" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        else
        {
            [self netRequestGetVerify];
        }
    }
    else if([buttonName containsString:@"重置密码"])
    {
        if ([self checkAll]) {
            [self netRequest];
        }
    }
    else if([buttonName containsString:@"去登录"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(BOOL)checkAll
{
    if (![_textFieldPassword.text isEqualToString:_textFieldPasswordConfirm.text]) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"确认密码不一致" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    
    if (IsStringEmptyOrNull(_textFieldUsername.text)||IsStringEmptyOrNull(_textFieldVerify.text)||IsStringEmptyOrNull(_textFieldPassword.text)||IsStringEmptyOrNull(_textFieldPasswordConfirm.text)) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请填写完整信息" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    else
    {
        return YES;
    }
        
    [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请填写完整信息" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
    return NO;
    
    
}



#pragma mark - lazy load懒加载

-(UIView *)viewTemp
{
    if (!_viewTemp) {
        _viewTemp = [UIView initViewBackColor:[UIColor whiteColor]];
    }
    return _viewTemp;
}

-(UIView *)viewSuccess
{
    if (!_viewSuccess) {
        _viewSuccess = [UIView initViewBackColor:[UIColor whiteColor]];
    }
    return _viewSuccess;
}

-(UIView *)viewLine
{
    if (!_viewLine) {
        _viewLine = [UIView initLineBackColor:[UIColor grayColor] width:800*GPCommonLayoutScaleSizeWidthIndex height:1 maxY:0];
    }
    return _viewLine;
}

-(UIView *)viewLineII
{
    if (!_viewLineII) {
        _viewLineII = [UIView initLineBackColor:[UIColor grayColor] width:800*GPCommonLayoutScaleSizeWidthIndex height:1 maxY:0];
    }
    return _viewLineII;
}

-(UIView *)viewLineIII
{
    if (!_viewLineIII) {
        _viewLineIII = [UIView initLineBackColor:[UIColor grayColor] width:800*GPCommonLayoutScaleSizeWidthIndex height:1 maxY:0];
    }
    return _viewLineIII;
}

-(UIView *)viewLineIV
{
    if (!_viewLineIV) {
        _viewLineIV = [UIView initLineBackColor:[UIColor grayColor] width:800*GPCommonLayoutScaleSizeWidthIndex height:1 maxY:0];
    }
    return _viewLineIV;
}

-(UILabel *)labelStateSuccess
{
    if (!_labelStateSuccess) {
        _labelStateSuccess = [UILabel initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:@"密码重置成功"];
        _labelStateSuccess.lineBreakMode = NSLineBreakByCharWrapping;
        _labelStateSuccess.backgroundColor = [UIColor clearColor];
        _labelStateSuccess.textAlignment = NSTextAlignmentCenter;
    }
    return _labelStateSuccess;
}

-(UIImageView *)imageViewState
{
    if (!_imageViewState) {
        _imageViewState = [UIImageView initImageView:@"忘记密码"];
    }
    return _imageViewState;
}

-(UIImageView *)imageViewStateII
{
    if (!_imageViewStateII) {
        _imageViewStateII = [UIImageView initImageView:@"忘记密码2"];
    }
    return _imageViewStateII;
}

-(UIImageView *)imageViewStateSuccess
{
    if (!_imageViewStateSuccess) {
        _imageViewStateSuccess = [UIImageView initImageView:@"wancheng"];
    }
    return _imageViewStateSuccess;
}



-(UITextField *)textFieldUsername
{
    if (!_textFieldUsername) {
        _textFieldUsername = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"手机号码"];
        _textFieldUsername.keyboardType = UIKeyboardTypeNumberPad;
        UILabelAlignToTopLeft *label = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:@"账号"];
        [label setFrame:CGRectMake(10*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 180*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [view addSubview:label];
        _textFieldUsername.leftView = view;
        _textFieldUsername.leftView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldUsername.leftView.layer.masksToBounds = YES;
        _textFieldUsername.leftView.clipsToBounds = YES;
        _textFieldUsername.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textFieldUsername;
}

-(UITextField *)textFieldVerify
{
    if (!_textFieldVerify) {
        _textFieldVerify = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"短信息验证码"];
        _textFieldVerify.keyboardType = UIKeyboardTypeNumberPad;
        UILabelAlignToTopLeft *label = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:@"验证码"];
        [label setFrame:CGRectMake(10*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 180*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [view addSubview:label];
        _textFieldVerify.leftView = view;
        _textFieldVerify.leftView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldVerify.leftView.layer.masksToBounds = YES;
        _textFieldVerify.leftView.clipsToBounds = YES;
        _textFieldVerify.leftViewMode = UITextFieldViewModeAlways;
        
        
        [self.buttonGetVerifyCode setFrame:CGRectMake(10*GPCommonLayoutScaleSizeWidthIndex, 20*GPCommonLayoutScaleSizeWidthIndex, 200*GPCommonLayoutScaleSizeWidthIndex, 80*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *viewRight = [UIView initViewBackColor:[UIColor whiteColor]];
        [viewRight setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 220*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [viewRight addSubview:self.buttonGetVerifyCode];
        _textFieldVerify.rightView = viewRight;
        _textFieldVerify.rightView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldVerify.rightView.layer.masksToBounds = YES;
        _textFieldVerify.rightView.clipsToBounds = YES;
        _textFieldVerify.rightViewMode = UITextFieldViewModeAlways;
    }
    return _textFieldVerify;
}

-(UITextField *)textFieldPassword
{
    if (!_textFieldPassword) {
        _textFieldPassword = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"6-12位数字字母组合"];
        _textFieldPassword.keyboardType = UIKeyboardTypeDefault;
        _textFieldPassword.secureTextEntry = YES;
        UILabelAlignToTopLeft *label = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:@"新密码"];
        [label setFrame:CGRectMake(10*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 180*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [view addSubview:label];
        _textFieldPassword.leftView = view;
        _textFieldPassword.leftView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldPassword.leftView.layer.masksToBounds = YES;
        _textFieldPassword.leftView.clipsToBounds = YES;
        _textFieldPassword.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textFieldPassword;
}


-(UITextField *)textFieldPasswordConfirm
{
    if (!_textFieldPasswordConfirm) {
        _textFieldPasswordConfirm = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"确保两次密码一致"];
        _textFieldPasswordConfirm.keyboardType = UIKeyboardTypeDefault;
        _textFieldPasswordConfirm.secureTextEntry = YES;
        UILabelAlignToTopLeft *label = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:@"确认密码"];
        [label setFrame:CGRectMake(10*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 180*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [view addSubview:label];
        
        _textFieldPasswordConfirm.leftView = view;
        _textFieldPasswordConfirm.leftView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldPasswordConfirm.leftView.layer.masksToBounds = YES;
        _textFieldPasswordConfirm.leftView.clipsToBounds = YES;
        _textFieldPasswordConfirm.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textFieldPasswordConfirm;
}

-(UIButton *)buttonGetVerifyCode
{
    if (!_buttonGetVerifyCode) {
        _buttonGetVerifyCode = [UIButton initButtonTitleFont:16 titleColor:[UIColor whiteColor] titleName:@"获取验证码" backgroundColor:kColorTheme radius:5];
        [_buttonGetVerifyCode addTarget:self tag:10 action:@selector(buttonClick:)];
    }
    return _buttonGetVerifyCode;
}

-(UIButton *)buttonResetPassword
{
    if (!_buttonResetPassword) {
        _buttonResetPassword = [UIButton initButtonTitleFont:24 titleColor:[UIColor whiteColor] titleName:@"重置密码" backgroundColor:kColorTheme radius:60*GPCommonLayoutScaleSizeWidthIndex];
        [_buttonResetPassword addTarget:self tag:11 action:@selector(buttonClick:)];
    }
    return _buttonResetPassword;
}

-(UIButton *)buttonGotoLogin
{
    if (!_buttonGotoLogin) {
        _buttonGotoLogin = [UIButton initButtonTitleFont:24 titleColor:[UIColor whiteColor] titleName:@"去登录"];
        [_buttonGotoLogin setBackgroundImage:GetImage(@"下一步") forState:UIControlStateNormal];
        [_buttonGotoLogin addTarget:self tag:13 action:@selector(buttonClick:)];
    }
    return _buttonGotoLogin;
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
