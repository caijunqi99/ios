//
//  ResetPasswordSuccessViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/10.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ResetPasswordSuccessViewController.h"
#import "UILabelAlignToTopLeft.h"
@interface ResetPasswordSuccessViewController ()<UITextFieldDelegate>
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
@property(nonatomic,strong)UIButton             *buttonLogin;
@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation ResetPasswordSuccessViewController

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
    [self.viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight)];
    
    
    
    [self.viewTemp addSubview:self.imageViewState];
    [self.imageViewState setFrame:CGRectMake(self.viewTemp.centerX - 270*GPCommonLayoutScaleSizeWidthIndex, 80*GPCommonLayoutScaleSizeWidthIndex, 540*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    [self.viewTemp addSubview:self.textFieldUsername];
    [self.textFieldUsername setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.centerY - 400*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.viewLine];
    [self.viewLine setFrame:CGRectMake(_textFieldUsername.left, _textFieldUsername.bottom, _textFieldUsername.width, 1)];
    
    [self.viewTemp addSubview:self.textFieldVerify];
    [self.textFieldVerify setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.centerY - 270*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    [self.viewTemp addSubview:self.viewLineII];
    [self.viewLineII setFrame:CGRectMake(_textFieldVerify.left, _textFieldVerify.bottom, _textFieldVerify.width, 1)];
    
    [self.viewTemp addSubview:self.textFieldPassword];
    [self.textFieldPassword setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.centerY - 140*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.viewLineIII];
    [self.viewLineIII setFrame:CGRectMake(_textFieldPassword.left, _textFieldPassword.bottom, _textFieldPassword.width, 1)];
    
    
    
    [self.viewTemp addSubview:self.textFieldPasswordConfirm];
    [self.textFieldPasswordConfirm setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.centerY - 10*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewTemp addSubview:self.viewLineIV];
    [self.viewLineIV setFrame:CGRectMake(_textFieldPasswordConfirm.left, _textFieldPasswordConfirm.bottom, _textFieldPasswordConfirm.width, 1)];
    
    
    
    
    [self.viewTemp addSubview:self.buttonLogin];
    [self.buttonLogin setFrame:CGRectMake(self.viewTemp.centerX - 400*GPCommonLayoutScaleSizeWidthIndex, self.viewTemp.bottom - 600*GPCommonLayoutScaleSizeWidthIndex, 800*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    
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
    [HPNetManager GETWithUrlString:HostStorestore_info isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_textFieldUsername.text,@"stringFunction", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            self->_strParameter = response[@"result"][@"goods_image"];
            
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
        
    }
    else if([buttonName containsString:@"用户注册"])
    {
        
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

-(UIImageView *)imageViewState
{
    if (!_imageViewState) {
        _imageViewState = [UIImageView initImageView:@"1"];
    }
    return _imageViewState;
}

-(UITextField *)textFieldUsername
{
    if (!_textFieldUsername) {
        _textFieldUsername = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"placeholder"];
        
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
        _textFieldVerify = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"placeholder"];
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
        
        
        [self.buttonGetVerifyCode setFrame:CGRectMake(10*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 200*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
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
        _textFieldPassword = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"placeholder"];
        UILabelAlignToTopLeft *label = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:@"重置密码"];
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
        _textFieldPasswordConfirm = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"placeholder"];
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

-(UIButton *)buttonLogin
{
    if (!_buttonLogin) {
        _buttonLogin = [UIButton initButtonTitleFont:16 titleColor:[UIColor whiteColor] titleName:@"下一步" backgroundColor:kColorTheme radius:60*GPCommonLayoutScaleSizeWidthIndex];
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
