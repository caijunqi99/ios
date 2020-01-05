//
//  WithdrawViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/2.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "WithdrawViewController.h"

#import "WithDrawListViewController.h"

@interface WithdrawViewController ()<UITextFieldDelegate>
{
    UIView                  *_viewBack;
    UIImageView             *_imageViewBack;
    
    UILabelAlignToTopLeft   *_labelTemp[6];
    UITextField             *_textFieldTemp[2];
    
    UIButton                *_buttonTemp;
    UIButton                *_buttonAll;
    UIButton                *_buttonGetVerifyCode;
    
    UIButton                *_buttonSelect;
    
    NSMutableArray          *_arrayDataSource;
    
    NSString                *_string_commission;
    NSString                *_string_withdraw;
    NSString                *_string_memberbank_name;
    NSString                *_string_memberbank_no;
    NSString                *_string_memberbank_truename;
}
@property(nonatomic,assign)NSInteger            timeOut;

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
    [self setRightNavButtonWithImage:nil Title:@"提现记录" Frame:CGRectMake(0, 0, 30, 30) Target:self action:@selector(rightClick)];//GetImage(@"垃圾桶黑色")
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
    
    
    
    NSArray *arrayLabelText = @[@"可用积分",@"",@"最低提现积分:",@"提现积分",@"手续费:",@"验证码"];
    
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
    
    
    _buttonGetVerifyCode = [UIButton initButtonTitleFont:16 titleColor:[UIColor whiteColor] titleName:@"获取验证码" backgroundColor:kColorTheme radius:5];
    [_buttonGetVerifyCode addTarget:self tag:14 action:@selector(buttonClick:)];
    [_buttonGetVerifyCode setFrame:RectWithScale(CGRectMake(0, 40, 250, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    UIView *viewRight1 = [UIView initViewBackColor:[UIColor clearColor]];
    [viewRight1 setFrame:RectWithScale(CGRectMake(0, 0, 300, 120), GPCommonLayoutScaleSizeWidthIndex)];
    [viewRight1 addSubview:_buttonGetVerifyCode];
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
    
    
    [_labelTemp[0]setTextColor:[UIColor whiteColor]];
    [_labelTemp[1]setTextColor:[UIColor whiteColor]];
    [_labelTemp[2]setTextColor:[UIColor whiteColor]];
    [_labelTemp[4]setTextColor:kColorTheme];
    
    
    
    
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
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    WithDrawListViewController *vc = [[WithDrawListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)checkAll
{
    if ([_textFieldTemp[0].text floatValue] > [_labelTemp[1].text floatValue]) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"可用积分不足" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    
    if ([_textFieldTemp[0].text floatValue] < [_string_withdraw floatValue]) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"申请提现积分不得小于最低提现积分" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
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
            self->_string_withdraw = response[@"result"][@"withdraw"];
            NSDictionary *dic = response[@"result"][@"bankinfo"];
            if ([[dic allKeys] count]) {
                self->_string_memberbank_truename = response[@"result"][@"bankinfo"][@"memberbank_truename"];
                self->_string_memberbank_no = response[@"result"][@"bankinfo"][@"memberbank_no"];
                self->_string_memberbank_name = response[@"result"][@"bankinfo"][@"memberbank_name"];
            }
        }
        //实名认证
        else if([response[@"code"] integerValue] == 10086)
        {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:response[@"message"] callbackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
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
    [HPNetManager POSTWithUrlString:HostConnectget_sms_captcha isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"username"],@"member_mobile",@"6",@"type", nil] successBlock:^(id response) {
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
    [HPNetManager POSTWithUrlString:Hostmembermy_withdraw isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_textFieldTemp[0].text,@"amount",_textFieldTemp[1].text,@"auth_code",_string_commission,@"commission",_string_memberbank_name,@"memberbank_name",_string_memberbank_no,@"memberbank_no",_string_memberbank_truename,@"memberbank_truename", nil] successBlock:^(id response) {
        
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"提交申请成功" callbackBlock:^(NSInteger btnIndex) {
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

-(void)tapClick:(UIGestureRecognizer*)tap
{
    //    NSInteger index = tap.view.tag - 200;
    NSString *strurl = @"asd";
    if (!IsStringEmptyOrNull(strurl))
    {
        
    }
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
    _buttonSelect = btn;
    if (_buttonGetVerifyCode == btn) {
        [self netRequestGetVerify];
    }
    else if (_buttonAll == btn)
    {
        [_textFieldTemp[0] setText:_labelTemp[1].text];
    }
    else if (_buttonTemp == btn)
    {
        if ([self checkAll]) {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:[NSString stringWithFormat:@"您本次申请提现:%@,手续费为:%.2f",_textFieldTemp[0].text,[_textFieldTemp[0].text floatValue]*([_string_commission floatValue]/100.0)] callbackBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self uploadInfo];
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
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
