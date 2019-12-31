//
//  SetLoginPasswordViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/25.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "SetLoginPasswordViewController.h"

@interface SetLoginPasswordViewController ()<UITextFieldDelegate>
{
    NSMutableArray          *_arrayDataSource;
}
@property(nonatomic,strong)UIView               *viewTemp;
@property(nonatomic,strong)UIView               *viewContent;
@property(nonatomic,strong)UIView               *viewContentII;
@property(nonatomic,strong)UITextField          *textFieldUsername;
@property(nonatomic,strong)UITextField          *textFieldVerify;
@property(nonatomic,strong)UITextField          *textFieldPassword;
@property(nonatomic,strong)UITextField          *textFieldPasswordConfirm;

@property(nonatomic,strong)UIButton             *buttonGetVerifyCode;
@property(nonatomic,strong)UIButton             *buttonResetPassword;


@end


@implementation SetLoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    
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
    NSMutableString *stringUsername = [NSMutableString stringWithString:[HPUserDefault objectForKey:@"username"]];
    [stringUsername replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    [_textFieldUsername setText:stringUsername];
    [_textFieldUsername setUserInteractionEnabled:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)configInterface
{
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    [self settingNavTitle:@"重置登录密码" WithNavTitleColor:[UIColor blackColor]];
    viewSetBackgroundColor(kColorBasic);
    
    
    [self.view addSubview:self.viewTemp];
    [self.viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight)];
    
    [self.viewTemp addSubview:self.viewContent];
    [self.viewContent setFrame:CGRectMake(0, 30*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth, 170*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.viewContentII];
    [self.viewContentII setFrame:CGRectMake(0, 230*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth, 430*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewContent addSubview:self.textFieldUsername];
    [self.textFieldUsername setFrame:CGRectMake(0, 25*GPCommonLayoutScaleSizeWidthIndex, self.viewContent.width, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewContentII addSubview:self.textFieldVerify];
    [self.textFieldVerify setFrame:CGRectMake(0, 25*GPCommonLayoutScaleSizeWidthIndex, self.viewContentII.width, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    [self.viewContentII addSubview:self.textFieldPassword];
    [self.textFieldPassword setFrame:CGRectMake(0, 155*GPCommonLayoutScaleSizeWidthIndex, self.viewContentII.width, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    [self.viewContentII addSubview:self.textFieldPasswordConfirm];
    [self.textFieldPasswordConfirm setFrame:CGRectMake(0, 285*GPCommonLayoutScaleSizeWidthIndex, self.viewContentII.width, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    [self.viewTemp addSubview:self.buttonResetPassword];
    [self.buttonResetPassword setFrame:CGRectMake(210*GPCommonLayoutScaleSizeWidthIndex, GPScreenHeight - kNavBarAndStatusBarHeight - 410*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.width - 420*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.buttonResetPassword rounded:(60*GPCommonLayoutScaleSizeWidthIndex)];
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
    [HPNetManager POSTWithUrlString:HostMemberaccountmodify_password_step4 isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"username"],@"mobile_key",[HPUserDefault objectForKey:@"token"],@"key",_textFieldVerify.text,@"auth_code",_textFieldPassword.text,@"password",_textFieldPasswordConfirm.text,@"confirm_password", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            [HPUserDefault addUserDefaultObject:self->_textFieldPassword.text key:@"password"];
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"修改密码成功" callbackBlock:^(NSInteger btnIndex) {
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
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
        
    return NO;
}



#pragma mark - lazy load懒加载

-(UIView *)viewTemp
{
    if (!_viewTemp) {
        _viewTemp = [UIView initViewBackColor:kColorBasic];
    }
    return _viewTemp;
}

-(UIView *)viewContent
{
    if (!_viewContent) {
        _viewContent = [UIView initViewBackColor:[UIColor whiteColor]];
    }
    return _viewContent;
}

-(UIView *)viewContentII
{
    if (!_viewContentII) {
        _viewContentII = [UIView initViewBackColor:[UIColor whiteColor]];
    }
    return _viewContentII;
}

-(UITextField *)textFieldUsername
{
    if (!_textFieldUsername) {
        _textFieldUsername = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"手机号码"];
        _textFieldUsername.keyboardType = UIKeyboardTypeNumberPad;
        UILabelAlignToTopLeft *label = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:@"账号"];
        [label setFrame:CGRectMake(30*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 220*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
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
        [label setFrame:CGRectMake(30*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 220*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [view addSubview:label];
        _textFieldVerify.leftView = view;
        _textFieldVerify.leftView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldVerify.leftView.layer.masksToBounds = YES;
        _textFieldVerify.leftView.clipsToBounds = YES;
        _textFieldVerify.leftViewMode = UITextFieldViewModeAlways;
        
        
        [self.buttonGetVerifyCode setFrame:CGRectMake(10*GPCommonLayoutScaleSizeWidthIndex, 20*GPCommonLayoutScaleSizeWidthIndex, 200*GPCommonLayoutScaleSizeWidthIndex, 80*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *viewRight = [UIView initViewBackColor:[UIColor whiteColor]];
        [viewRight setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 270*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
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
        [label setFrame:CGRectMake(30*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 220*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
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
        [label setFrame:CGRectMake(30*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 220*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
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
        _buttonGetVerifyCode = [UIButton initButtonTitleFont:16 titleColor:kColorTheme titleName:@"获取验证码" backgroundColor:[UIColor whiteColor] radius:5];
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
