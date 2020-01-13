//
//  LoginViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/10.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "LoginViewController.h"
#import "IndexTabBarViewController.h"
#import "ResetPasswordViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    NSString            *_strParameter;
}

@property(nonatomic,strong)UIView               *viewTemp;
@property(nonatomic,strong)UIView               *viewLine;
@property(nonatomic,strong)UIView               *viewLineII;

@property(nonatomic,strong)UIImageView          *imageViewLogo;

@property(nonatomic,strong)UITextField          *textFieldUsername;
@property(nonatomic,strong)UITextField          *textFieldPassword;

@property(nonatomic,strong)UIButton             *buttonResetPassword;
@property(nonatomic,strong)UIButton             *buttonRegister;
@property(nonatomic,strong)UIButton             *buttonLogin;
@end

static NSString * const ReuseIdentify = @"ReuseIdentify";



@implementation LoginViewController

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
    self.navigationController.navigationBar.hidden = YES;
    
    _textFieldUsername.text = [HPUserDefault objectForKey:@"username"];
    _textFieldPassword.text = [HPUserDefault objectForKey:@"password"];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)configInterface
{
    viewSetBackgroundColor(kColorViewBackground);
    
    
    [self.view addSubview:self.viewTemp];
    [self.viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight)];
    
    
    
    [self.viewTemp addSubview:self.imageViewLogo];
    [self.imageViewLogo setFrame:CGRectMake(self.viewTemp.centerX - 150*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.centerY - 700*GPCommonLayoutScaleSizeWidthIndex, 300*GPCommonLayoutScaleSizeWidthIndex, 300*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    [self.viewTemp addSubview:self.textFieldUsername];
    [self.textFieldUsername setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.centerY - 200*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.viewLine];
    [self.viewLine setFrame:CGRectMake(_textFieldUsername.left, _textFieldUsername.bottom, _textFieldUsername.width, 1)];
    
    [self.viewTemp addSubview:self.textFieldPassword];
    [self.textFieldPassword setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.textFieldUsername.bottom + 10*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.viewLineII];
    [self.viewLineII setFrame:CGRectMake(_textFieldPassword.left, _textFieldPassword.bottom, _textFieldPassword.width, 1)];
    
    [self.viewTemp addSubview:self.buttonResetPassword];
    [self.buttonResetPassword setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.textFieldPassword.bottom + 10*GPCommonLayoutScaleSizeWidthIndex, 200*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.buttonRegister];
    [self.buttonRegister setFrame:CGRectMake(self.viewTemp.centerX + 200*GPCommonLayoutScaleSizeWidthIndex, self.textFieldPassword.bottom + 10*GPCommonLayoutScaleSizeWidthIndex, 200*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.buttonLogin];
    [self.buttonLogin setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.buttonRegister.bottom + 100*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 800*(54.0/372.0)*GPCommonLayoutScaleSizeWidthIndex)];
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
    [HPNetManager POSTWithUrlString:Hostloginindex isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_textFieldUsername.text,@"username",_textFieldPassword.text,@"password",@"ios",@"client", nil] successBlock:^(id response) {

        if ([response[@"code"] integerValue] == 200) {
            
            
            [HPUserDefault addUserDefaultObject:self->_textFieldUsername.text key:@"username"];
            [HPUserDefault addUserDefaultObject:self->_textFieldPassword.text key:@"password"];
            [HPUserDefault addUserDefaultObject:response[@"result"][@"key"] key:@"token"];
            [HPUserDefault addUserDefaultObject:response[@"result"][@"userid"] key:@"userid"];
            
            
            GPDebugLog(@"token----------:%@ \n userid----------:%@",[HPUserDefault objectForKey:@"token"],[HPUserDefault objectForKey:@"userid"]);
            
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"登录成功" buttonTitle:nil buttonStyle:HPAlertActionStyleDefault];
            
            //设置indextabbar为主窗口的根视图控制器
            IndexTabBarViewController *vc = [[IndexTabBarViewController alloc] init];
            [vc setSelectedIndex:0];
            GPKeyWindow.rootViewController = vc;
            [GPKeyWindow makeKeyAndVisible];
            
            HPNOTIF_POST(@"refreshUserInfo", nil);
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
    if ([buttonName containsString:@"忘记密码"])
    {
        ResetPasswordViewController *vc = [[ResetPasswordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"用户注册"])
    {
        RegisterViewController *vc = [[RegisterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([buttonName containsString:@"登录"])
    {
        if (IsStringEmptyOrNull(_textFieldUsername.text)||IsStringEmptyOrNull(_textFieldPassword.text)) {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请填写用户名(手机号)和登录密码" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        else
        {
            [self netRequest];
        }
    }
}



#pragma mark - lazy load懒加载

-(UIView *)viewTemp
{
    if (!_viewTemp) {
        _viewTemp = [UIView initViewBackColor:[UIColor whiteColor]];
    }
    return _viewTemp;
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

-(UIImageView *)imageViewLogo
{
    if (!_imageViewLogo) {
        _imageViewLogo = [UIImageView initImageView:@"logo"];
        _imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageViewLogo;
}

-(UITextField *)textFieldUsername
{
    if (!_textFieldUsername) {
        _textFieldUsername = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"手机号码"];
        _textFieldUsername.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:GetImage(@"手机")];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setFrame:CGRectMake(10*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [view addSubview:imageView];
        _textFieldUsername.leftView = view;
        _textFieldUsername.leftView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldUsername.leftView.layer.masksToBounds = YES;
        _textFieldUsername.leftView.clipsToBounds = YES;
        _textFieldUsername.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textFieldUsername;
}

-(UITextField *)textFieldPassword
{
    if (!_textFieldPassword) {
        _textFieldPassword = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"登录密码"];
        _textFieldPassword.keyboardType = UIKeyboardTypeDefault;
        _textFieldPassword.secureTextEntry = YES;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:GetImage(@"登录密码")];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setFrame:CGRectMake(10*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [view addSubview:imageView];
        _textFieldPassword.leftView = view;
        _textFieldPassword.leftView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldPassword.leftView.layer.masksToBounds = YES;
        _textFieldPassword.leftView.clipsToBounds = YES;
        _textFieldPassword.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textFieldPassword;
}

-(UIButton *)buttonResetPassword
{
    if (!_buttonResetPassword) {
        _buttonResetPassword = [UIButton initButtonTitleFont:16 titleColor:[UIColor grayColor] titleName:@"忘记密码"];
        [_buttonResetPassword addTarget:self tag:9 action:@selector(buttonClick:)];
        
    }
    return _buttonResetPassword;
}

-(UIButton *)buttonRegister
{
    if (!_buttonRegister) {
        _buttonRegister = [UIButton initButtonTitleFont:16 titleColor:kColorTheme titleName:@"用户注册"];
        [_buttonRegister addTarget:self tag:10 action:@selector(buttonClick:)];
    }
    return _buttonRegister;
}

-(UIButton *)buttonLogin
{
    if (!_buttonLogin) {
        _buttonLogin = [UIButton initButtonTitleFont:24 titleColor:[UIColor whiteColor] titleName:@"登录" backgroundColor:kColorTheme radius:60*GPCommonLayoutScaleSizeWidthIndex];
        [_buttonLogin addTarget:self tag:11 action:@selector(buttonClick:)];
    }
    return _buttonLogin;
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
