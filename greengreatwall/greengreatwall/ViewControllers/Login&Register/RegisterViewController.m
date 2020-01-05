//
//  RegisterViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/10.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "RegisterViewController.h"
#import "UILabelAlignToTopLeft.h"
#import "HPBaseWKWebViewController.h"
@interface RegisterViewController ()<UITextFieldDelegate>
{
    NSString            *_strParameter;
}
@property(nonatomic,assign)NSInteger            timeOut;
@property(nonatomic,strong)UIView               *viewTemp;
@property(nonatomic,strong)UIView               *viewLine;
@property(nonatomic,strong)UIView               *viewLineII;
@property(nonatomic,strong)UIView               *viewLineIII;
@property(nonatomic,strong)UIView               *viewLineIV;
@property(nonatomic,strong)UIView               *viewLineV;

@property(nonatomic,strong)UIImageView          *imageViewLogo;

@property(nonatomic,strong)UITextField          *textFieldUsername;
@property(nonatomic,strong)UITextField          *textFieldVerify;
@property(nonatomic,strong)UITextField          *textFieldPassword;
@property(nonatomic,strong)UITextField          *textFieldPasswordConfirm;

@property(nonatomic,strong)UITextField          *textFieldInvitationCode;

@property(nonatomic,strong)UIImageView          *imageViewSelect;
@property(nonatomic,strong)UIButton             *buttonDocument;

@property(nonatomic,strong)UIButton             *buttonGetVerifyCode;
@property(nonatomic,strong)UIButton             *buttonRegister;
@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation RegisterViewController

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
    [self settingNavTitle:@"注册" WithNavTitleColor:[UIColor blackColor]];
    viewSetBackgroundColor(kColorViewBackground);
    
    
    [self.view addSubview:self.viewTemp];
    [self.viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight)];
    
    
    
    [self.viewTemp addSubview:self.imageViewLogo];
    [self.imageViewLogo setFrame:CGRectMake(self.viewTemp.centerX - 150*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.centerY - 700*GPCommonLayoutScaleSizeWidthIndex - kNavBarAndStatusBarHeight , 300*GPCommonLayoutScaleSizeWidthIndex, 300*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
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
    
    
    [self.viewTemp addSubview:self.textFieldInvitationCode];
    [self.textFieldInvitationCode setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.textFieldPasswordConfirm.bottom + 50*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.viewLineV];
    [self.viewLineV setFrame:CGRectMake(_textFieldInvitationCode.left, _textFieldInvitationCode.bottom, _textFieldInvitationCode.width, 1)];
    
    [self.viewTemp addSubview:self.buttonDocument];
    [self.buttonDocument setFrame:CGRectMake(self.viewTemp.centerX - 150*GPCommonLayoutScaleSizeWidthIndex, self.textFieldInvitationCode.bottom + 10*GPCommonLayoutScaleSizeWidthIndex, 300*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.imageViewSelect];
    [self.imageViewSelect setFrame:CGRectMake(_buttonDocument.left - 50*GPCommonLayoutScaleSizeWidthIndex, self.textFieldInvitationCode.bottom + 50*GPCommonLayoutScaleSizeWidthIndex, 40*GPCommonLayoutScaleSizeWidthIndex, 40*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    [self.viewTemp addSubview:self.buttonRegister];
    [self.buttonRegister setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.buttonDocument.bottom + 100*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 800*(54.0/372.0)*GPCommonLayoutScaleSizeWidthIndex)];
    
    
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
    [HPNetManager POSTWithUrlString:Hostloginregister isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_textFieldUsername.text,@"username",_textFieldVerify.text,@"sms_captcha",_textFieldPassword.text,@"password",_textFieldPasswordConfirm.text,@"password_confirm",_textFieldInvitationCode.text,@"inviter_code",@"ios",@"client",@"1",@"log_type", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        

        if ([response[@"code"] integerValue] == 200) {
            
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"注册成功" callbackBlock:^(NSInteger btnIndex) {
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
    [self sentPhoneCodeTimeMethod];
    [HPNetManager POSTWithUrlString:HostConnectget_sms_captcha isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_textFieldUsername.text,@"member_mobile",@"1",@"type", nil] successBlock:^(id response) {
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

/**
 倒计时方法 在点击获取验证码按钮的方法里调用此方法即可实现, 需要在倒计时里修改按钮相关的请在此方法里yourButton修改
 */
- (void)sentPhoneCodeTimeMethod {
    //倒计时时间 - 60S
    __block NSInteger timeOut = 59;
    self.timeOut = timeOut;
    UIButton *yourButton = _buttonGetVerifyCode;
    //执行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计时器 -》 dispatch_source_set_timer自动生成
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束
                [yourButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [yourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [yourButton setEnabled:YES];
                [yourButton setUserInteractionEnabled:YES];
            });
        } else {
            //开始计时
            //剩余秒数 seconds
            NSInteger seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.1ld", seconds];
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1.0];
                NSString *title = [NSString stringWithFormat:@"%@",strTime];
                [yourButton setTitle:title forState:UIControlStateNormal];
//              [yourButton.titleLabel setTextAlignment:NSTextAlignmentRight];
                // 设置按钮title居中 上面注释的方法无效
                [yourButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [yourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [UIView commitAnimations];
                //计时器间不允许点击
                [yourButton setUserInteractionEnabled:NO];
            });
            timeOut--;
        }
    });
    dispatch_resume(timer);
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
    else if([buttonName containsString:@"立即注册"])
    {
        if ([self checkAll]) {
            [self netRequest];
        }
    }
    else if([buttonName containsString:@"绿色长城用户协议"])
    {
        HPBaseWKWebViewController *vc = [[HPBaseWKWebViewController alloc]init];
        vc.urlStr = wapagreementhtml;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(BOOL)checkAll
{
    if (![_textFieldPassword.text isEqualToString:_textFieldPasswordConfirm.text]) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"确认密码不一致" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    
    if (IsStringEmptyOrNull(_textFieldUsername.text)||IsStringEmptyOrNull(_textFieldVerify.text)||IsStringEmptyOrNull(_textFieldPassword.text)||IsStringEmptyOrNull(_textFieldPasswordConfirm.text)||IsStringEmptyOrNull(_textFieldInvitationCode.text)) {
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

-(UIView *)viewLineV
{
    if (!_viewLineV) {
        _viewLineV = [UIView initLineBackColor:[UIColor grayColor] width:800*GPCommonLayoutScaleSizeWidthIndex height:1 maxY:0];
    }
    return _viewLineV;
}

-(UIImageView *)imageViewLogo
{
    if (!_imageViewLogo) {
        _imageViewLogo = [UIImageView initImageView:@"logo"];
    }
    return _imageViewLogo;
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
        UILabelAlignToTopLeft *label = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:@"登陆密码"];
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

-(UITextField *)textFieldInvitationCode
{
    if (!_textFieldInvitationCode) {
        _textFieldInvitationCode = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"请输入邀请码(必填)"];
        _textFieldInvitationCode.keyboardType = UIKeyboardTypeDefault;
        UILabelAlignToTopLeft *label = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:@"邀请码"];
        [label setFrame:CGRectMake(10*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 180*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [view addSubview:label];
        
        _textFieldInvitationCode.leftView = view;
        _textFieldInvitationCode.leftView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldInvitationCode.leftView.layer.masksToBounds = YES;
        _textFieldInvitationCode.leftView.clipsToBounds = YES;
        _textFieldInvitationCode.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textFieldInvitationCode;
}

-(UIImageView *)imageViewSelect
{
    if (!_imageViewSelect) {
        _imageViewSelect = [UIImageView initImageView:@"选择3"];
    }
    return _imageViewSelect;
}

-(UIButton *)buttonDocument
{
    if (!_buttonDocument) {
        _buttonDocument = [UIButton initButtonTitleFont:16 titleColor:[UIColor blackColor] titleName:@"绿色长城用户协议"];
        [_buttonDocument addTarget:self tag:9 action:@selector(buttonClick:)];
    }
    return _buttonDocument;
}

-(UIButton *)buttonGetVerifyCode
{
    if (!_buttonGetVerifyCode) {
        _buttonGetVerifyCode = [UIButton initButtonTitleFont:16 titleColor:[UIColor whiteColor] titleName:@"获取验证码" backgroundColor:kColorTheme radius:5];
        [_buttonGetVerifyCode addTarget:self tag:10 action:@selector(buttonClick:)];
    }
    return _buttonGetVerifyCode;
}

-(UIButton *)buttonRegister
{
    if (!_buttonRegister) {
        _buttonRegister = [UIButton initButtonTitleFont:24 titleColor:[UIColor whiteColor] titleName:@"立即注册" backgroundColor:kColorTheme radius:60*GPCommonLayoutScaleSizeWidthIndex];
        [_buttonRegister addTarget:self tag:11 action:@selector(buttonClick:)];
    }
    return _buttonRegister;
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
