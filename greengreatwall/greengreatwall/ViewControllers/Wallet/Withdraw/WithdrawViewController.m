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
    UIImageView             *_imageViewWallet;
    
    UIView                  *_viewContent[3];
    
    UILabelAlignToTopLeft   *_labelTemp[7];
    UITextField             *_textFieldTemp[5];
    
    UIButton                *_buttonTemp;
    UIButton                *_buttonIDCardpositive;
    UIButton                *_buttonIDCardReverse;
    
    UIButton                *_buttonSelect;
    
 
    
    NSString                *stringProvince_id;
    NSString                *stringCity_id;
    NSString                *stringRegion_id;
    
    NSMutableArray          *_arrayDataSource;
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
    [self settingNavTitle:@"实名认证"];
    
    viewSetBackgroundColor(kColorBasic);
    
    _imageViewWallet = [[UIImageView alloc]init];
    [_imageViewWallet setFrame:RectWithScale(CGRectMake(0, 0, 1080, 364), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewWallet setImage:GetImage(@"身份认证")];
    [self.view addSubview:_imageViewWallet];
    _imageViewWallet.userInteractionEnabled= NO;
    
    for (NSInteger i = 0; i<3; i++) {
        _viewContent[i] = [[UIView alloc]init];
        [_viewContent[i] setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_viewContent[i]];
    }
    
    
    
    [_viewContent[0] setFrame:RectWithScale(CGRectMake(0, 290, 1080, 430), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewContent[1] setFrame:RectWithScale(CGRectMake(0, 740, 1080, 430), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewContent[2] setFrame:RectWithScale(CGRectMake(0, 1200, 1080, 220), GPCommonLayoutScaleSizeWidthIndex)];
    
    [_viewContent[0] rounded:10 rectCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];
    
    NSArray *arrayLabelText = @[@"真实姓名",@"身份证号",@"所在地区",@"银行名称",@"银行卡账号",@"基本信息",@"身份证照片"];
    NSArray *arrayPlaceHolderText = @[@"请输入真实姓名",@"15-18位身份证号",@"请选择",@"请输入",@"请输入"];
    
    for (NSInteger i = 0; i<7; i++) {
        
        _labelTemp[i] = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:arrayLabelText[i]];
        _labelTemp[i].lineBreakMode = NSLineBreakByCharWrapping;
        _labelTemp[i].backgroundColor = [UIColor clearColor];
        [_labelTemp[i] setFrame:CGRectMake(10, 10, 80, 40)];
        
        if (i<5) {
            _textFieldTemp[i] = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:arrayPlaceHolderText[i]];
            _textFieldTemp[i].keyboardType = UIKeyboardTypeDefault;
            UIView *view = [UIView initViewBackColor:[UIColor clearColor]];
            [view setFrame:CGRectMake(0, 0, 100, 60)];
            [view addSubview:_labelTemp[i]];
            _textFieldTemp[i].leftView = view;
            _textFieldTemp[i].leftView.contentMode = UIViewContentModeScaleAspectFit;
            _textFieldTemp[i].leftView.layer.masksToBounds = YES;
            _textFieldTemp[i].leftView.clipsToBounds = YES;
            _textFieldTemp[i].leftViewMode = UITextFieldViewModeAlways;
            
            _textFieldTemp[i].delegate = self;
        }
    }
    
    
    
    [_viewContent[0] addSubview:_textFieldTemp[0]];
    [_textFieldTemp[0] setFrame:CGRectMake(0, (_viewContent[0].height/4.0) *1, _viewContent[0].width, _viewContent[0].height/4.0)];
    _textFieldTemp[0].keyboardType = UIKeyboardTypeDefault;
    
    [_viewContent[0] addSubview:_textFieldTemp[1]];
    [_textFieldTemp[1] setFrame:CGRectMake(0, (_viewContent[0].height/4.0) *2, _viewContent[0].width, _viewContent[0].height/4.0)];
    _textFieldTemp[1].keyboardType = UIKeyboardTypeDefault;
    
    [_viewContent[0] addSubview:_textFieldTemp[2]];
    [_textFieldTemp[2] setFrame:CGRectMake(0, (_viewContent[0].height/4.0) *3, _viewContent[0].width, _viewContent[0].height/4.0)];
    _textFieldTemp[2].keyboardType = UIKeyboardTypeDefault;
    
    
    [_viewContent[2] addSubview:_textFieldTemp[3]];
    [_textFieldTemp[3] setFrame:CGRectMake(0, (_viewContent[2].height/2.0) *0, _viewContent[2].width, _viewContent[2].height/2.0)];
    _textFieldTemp[3].keyboardType = UIKeyboardTypeDefault;
    
    
    [_viewContent[2] addSubview:_textFieldTemp[4]];
    [_textFieldTemp[4] setFrame:CGRectMake(0, (_viewContent[2].height/2.0) *1, _viewContent[2].width, _viewContent[2].height/2.0)];
    _textFieldTemp[4].keyboardType = UIKeyboardTypeNumberPad;
    
    
    [_labelTemp[5] setFrame:CGRectMake(10, 10+(_viewContent[0].height/4.0) *0, _viewContent[0].width - 10 - 10, (_viewContent[0].height/4.0)-20)];
    [_viewContent[0] addSubview:_labelTemp[5]];
    
    
    [_labelTemp[6] setFrame:CGRectMake(10, 10+(_viewContent[1].height/4.0) *0, _viewContent[1].width - 10 - 10, (_viewContent[1].height/4.0)-20)];
    [_viewContent[1] addSubview:_labelTemp[6]];
    
    
    CGFloat width = (_viewContent[1].width - 200*GPCommonLayoutScaleSizeWidthIndex)/2.0;
    CGFloat height = width *(255.0/448.0);
    
    _buttonIDCardpositive = [UIButton initButtonTitleFont:22 titleColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] imageName:nil titleName:@"正面"];
    [_buttonIDCardpositive setImage:GetImage(@"正面照片") forState:UIControlStateNormal];
    [_buttonIDCardpositive addTarget:self tag:13 action:@selector(buttonClick:)];
    [_buttonIDCardpositive setFrame:CGRectMake(60*GPCommonLayoutScaleSizeWidthIndex, 130*GPCommonLayoutScaleSizeWidthIndex, width, height)];
    [_viewContent[1] addSubview:_buttonIDCardpositive];
    
    _buttonIDCardReverse = [UIButton initButtonTitleFont:22 titleColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] imageName:nil titleName:@"反面"];
    [_buttonIDCardReverse setImage:GetImage(@"反面照片") forState:UIControlStateNormal];
    [_buttonIDCardReverse addTarget:self tag:14 action:@selector(buttonClick:)];
    [_buttonIDCardReverse setFrame:CGRectMake(_viewContent[1].width/2.0 +_buttonIDCardpositive.left, _buttonIDCardpositive.top, width, height)];
    [_viewContent[1] addSubview:_buttonIDCardReverse];
    
    
    
    
    
    _buttonTemp = [UIButton initButtonTitleFont:22 titleColor:[UIColor whiteColor] backgroundColor:kColorTheme imageName:@"" titleName:@"提交认证"];
    [_buttonTemp addTarget:self tag:11 action:@selector(buttonClick:)];
    [self.view addSubview:_buttonTemp];
    [_buttonTemp setFrame:CGRectMake(self.view.centerX - 395*GPCommonLayoutScaleSizeWidthIndex, GPScreenHeight - kNavBarAndStatusBarHeight - 270*GPCommonLayoutScaleSizeWidthIndex, 790*GPCommonLayoutScaleSizeWidthIndex, 790*(110.0/790.0)*GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonTemp rounded:(55.0*GPCommonLayoutScaleSizeWidthIndex)];
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
    if ([_textFieldTemp[2].text containsString:@"请选择"]||IsStringEmptyOrNull(_textFieldTemp[2].text)) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请选择所在地区" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    
    
    if (IsStringEmptyOrNull(_textFieldTemp[0].text)||IsStringEmptyOrNull(_textFieldTemp[1].text)||IsStringEmptyOrNull(_textFieldTemp[2].text)||IsStringEmptyOrNull(_textFieldTemp[3].text)||IsStringEmptyOrNull(_textFieldTemp[4].text)) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请填写完整信息" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    else
    {
        return YES;
    }
    
    return NO;
    
    
}

-(void)netRequest
{
//    HPWeak;
    
    [HPNetManager POSTWithUrlString:HostMmemberauthauth isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"userid"],@"member_id", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {

            if ([[NSString stringWithFormat:@"%@",response[@"result"][@"member_auth_state"]]isEqualToString:@"0"]) {
                return ;
            }else{
                [self->_textFieldTemp[0] setText:response[@"result"][@"username"]];
                [self->_textFieldTemp[1] setText:response[@"result"][@"idcard"]];
                [self->_textFieldTemp[2] setText:response[@"result"][@"member_areainfo"]];
                self->stringProvince_id = response[@"result"][@"member_provinceid"];
                self->stringCity_id = response[@"result"][@"member_cityid"];
                self->stringRegion_id = response[@"result"][@"member_areaid"];
                [self->_buttonIDCardpositive sd_setImageWithURL:URL(response[@"result"][@"member_idcard_image2"]) forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                    [self->_arrayDataSourcePhoto replaceObjectAtIndex:0 withObject:image];
                }];
                [self->_buttonIDCardReverse sd_setImageWithURL:URL(response[@"result"][@"member_idcard_image3"]) forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                    [self->_arrayDataSourcePhoto replaceObjectAtIndex:1 withObject:image];
                }];
                [self->_textFieldTemp[3] setText:response[@"result"][@"member_bankname"]];
                [self->_textFieldTemp[4] setText:response[@"result"][@"member_bankcard"]];
            }
            if ([[NSString stringWithFormat:@"%@",response[@"result"][@"member_auth_state"]]isEqualToString:@"1"]) {
                [self->_buttonTemp setUserInteractionEnabled:NO];
                [self->_buttonTemp setTitle:@"认证中" forState:UIControlStateNormal];
                [self->_buttonTemp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self->_buttonTemp setBackgroundImage:CreateImageWithColor([UIColor lightGrayColor]) forState:UIControlStateNormal];
            }
            if ([[NSString stringWithFormat:@"%@",response[@"result"][@"member_auth_state"]]isEqualToString:@"2"]) {
                [HPAlertTools showAlertWith:self title:@"提示信息" message:@"您提交的认证未通过,请检查后确认无误重新提交。" callbackBlock:^(NSInteger btnIndex) {
                    //                [weakSelf.navigationController popViewControllerAnimated:YES];
                } cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确定",nil];
            }
            if ([[NSString stringWithFormat:@"%@",response[@"result"][@"member_auth_state"]]isEqualToString:@"3"]) {
                [self->_buttonTemp setUserInteractionEnabled:NO];
                [self->_buttonTemp setTitle:@"已认证" forState:UIControlStateNormal];
                //                [self->_buttonTemp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                //                [self->_buttonTemp setBackgroundImage:CreateImageWithColor([UIColor lightGrayColor]) forState:UIControlStateNormal];
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

-(void)uploadInfo
{
    HPWeak;
    
    [HPNetManager POSTWithUrlString:Hostmembermy_asset isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"添加成功" callbackBlock:^(NSInteger btnIndex) {
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
    if (_buttonIDCardReverse == btn) {

    }
    else if (_buttonIDCardpositive == btn)
    {

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
