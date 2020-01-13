//
//  PointTransformViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/2.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "PointTransformViewController.h"

@interface PointTransformViewController ()<UITextFieldDelegate>
{
    UIView                  *_viewTemp;
    UIView                  *_viewTempII;
    UILabelAlignToTopLeft   *_labelTemp[6];
    UITextField             *_textFieldTemp[1];
    UIButton                *_buttonContent[2];
    
    UIButton                *_buttonSelected;
    UIButton                *_buttonTemp;
    UIButton                *_buttonAll;
    NSMutableArray          *_arrayDataSource;
}



@end

#define kBottomHeightCommon        (130*GPCommonLayoutScaleSizeWidthIndex)

@implementation PointTransformViewController

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
    [self settingNavTitle:@"互转"];
    
    viewSetBackgroundColor(kColorBasic);
    
    _viewTemp = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewTemp setFrame:CGRectMake(0, 10*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth, 420*GPCommonLayoutScaleSizeWidthIndex)];
    [self.view addSubview:_viewTemp];
    
    _viewTempII = [UIView initViewBackColor:[UIColor whiteColor]];
    [_viewTempII setFrame:CGRectMake(0, _viewTemp.bottom + 10*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth, 200*GPCommonLayoutScaleSizeWidthIndex)];
    [self.view addSubview:_viewTempII];
    
    
    NSArray *arrayLabelText = @[@"转账资产",@"储值卡",@"可用",@"",@"转出金额",@"¥"];
    
    for (NSInteger i = 0; i<arrayLabelText.count; i++) {
        _labelTemp[i] = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:arrayLabelText[i]];
        _labelTemp[i].lineBreakMode = LineBreakModeDefault;
        _labelTemp[i].backgroundColor = [UIColor clearColor];
        _labelTemp[i].font = FontRegularWithSize(16);
    }
    
    
    [_labelTemp[0] setFrame:RectWithScale(CGRectMake(40, 40, 260, 40), GPCommonLayoutScaleSizeWidthIndex)];
    _labelTemp[0].textAlignment = NSTextAlignmentLeft;
    [_viewTemp addSubview:_labelTemp[0]];
    
    [_labelTemp[1] setFrame:RectWithScale(CGRectMake(400, 40, 540, 40), GPCommonLayoutScaleSizeWidthIndex)];
    _labelTemp[1].textAlignment = NSTextAlignmentRight;
    [_viewTemp addSubview:_labelTemp[1]];
    
    [_labelTemp[2] setFrame:RectWithScale(CGRectMake(40, 320, 260, 40), GPCommonLayoutScaleSizeWidthIndex)];
    _labelTemp[2].textAlignment = NSTextAlignmentLeft;
    [_viewTemp addSubview:_labelTemp[2]];
    
    [_labelTemp[3] setFrame:RectWithScale(CGRectMake(400, 320, 540, 40), GPCommonLayoutScaleSizeWidthIndex)];
    _labelTemp[3].textAlignment = NSTextAlignmentRight;
    [_viewTemp addSubview:_labelTemp[3]];
    
    [_labelTemp[4] setFrame:RectWithScale(CGRectMake(40, 20, 260, 40), GPCommonLayoutScaleSizeWidthIndex)];
    _labelTemp[4].textAlignment = NSTextAlignmentLeft;
    [_viewTempII addSubview:_labelTemp[4]];
    
    [_labelTemp[5] setFrame:RectWithScale(CGRectMake(40, 40, 60, 40), GPCommonLayoutScaleSizeWidthIndex)];
    _labelTemp[5].textAlignment = NSTextAlignmentLeft;
    
    
    _textFieldTemp[0] = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@""];
    _textFieldTemp[0].keyboardType = UIKeyboardTypeNumberPad;
    UIView *viewleft = [UIView initViewBackColor:[UIColor whiteColor]];
    [viewleft setFrame:RectWithScale(CGRectMake(0, 0, 100, 120), GPCommonLayoutScaleSizeWidthIndex)];
    [viewleft addSubview:_labelTemp[5]];
    _textFieldTemp[0].leftView = viewleft;
    _textFieldTemp[0].leftView.contentMode = UIViewContentModeScaleAspectFit;
    _textFieldTemp[0].leftView.layer.masksToBounds = YES;
    _textFieldTemp[0].leftView.clipsToBounds = YES;
    _textFieldTemp[0].leftViewMode = UITextFieldViewModeAlways;
    _textFieldTemp[0].placeholder = @"请输入转出数量";
    _textFieldTemp[0].delegate = self;
    
    [_viewTempII addSubview:_textFieldTemp[0]];
    [_textFieldTemp[0] setFrame:CGRectMake(0, 80*GPCommonLayoutScaleSizeWidthIndex, _viewTemp.width, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    _buttonAll = [UIButton initButtonTitleFont:22 titleColor:kColorTheme backgroundColor:[UIColor clearColor] imageName:nil titleName:@"全部"];
    [_buttonAll addTarget:self tag:13 action:@selector(buttonClick:)];
    [_buttonAll setFrame:RectWithScale(CGRectMake(50, 40, 150, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
    [view setFrame:RectWithScale(CGRectMake(0, 0, 200, 120), GPCommonLayoutScaleSizeWidthIndex)];
    [view addSubview:_buttonAll];
    _textFieldTemp[0].rightView = view;
    _textFieldTemp[0].rightView.contentMode = UIViewContentModeScaleAspectFit;
    _textFieldTemp[0].rightView.layer.masksToBounds = YES;
    _textFieldTemp[0].rightView.clipsToBounds = YES;
    _textFieldTemp[0].rightViewMode = UITextFieldViewModeAlways;
    
    NSArray *arrayTitleName = @[@"储值卡",@"认筹股"];
    
    for (NSInteger i = 0; i< arrayTitleName.count; i++)
    {
        
        _buttonContent[i]=[UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonContent[i] setFrame:RectWithScale(CGRectMake(540*i, 140, 540,140), GPCommonLayoutScaleSizeWidthIndex)];
        [_buttonContent[i] setBackgroundImage:CreateImageWithColor(rgb(246, 247, 248)) forState:UIControlStateNormal];
        [_buttonContent[i] setImage:GetImage(@"未选中") forState:UIControlStateNormal];
        [_buttonContent[i] setImage:GetImage(@"选中") forState:UIControlStateSelected];
        [_buttonContent[i] setTitle:[arrayTitleName objectAtIndex:i] forState:UIControlStateNormal];
        [_buttonContent[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buttonContent[i] setTitleColor:kColorTheme forState:UIControlStateSelected];
        [_buttonContent[i] setTag:i+1];
        [_buttonContent[i] addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonContent[i] setImageEdgeInsets:UIEdgeInsetsMake(0, -50*GPCommonLayoutScaleSizeWidthIndex, 0, 0)];
        [_buttonContent[i] setTitleEdgeInsets:UIEdgeInsetsMake(0, -40*GPCommonLayoutScaleSizeWidthIndex, 0, 0)];
        [self.view addSubview:_buttonContent[i]];
    }
    
    
    _buttonTemp = [UIButton initButtonTitleFont:22 titleColor:[UIColor whiteColor] backgroundColor:kColorTheme imageName:@"" titleName:@"转出"];
    [_buttonTemp addTarget:self tag:11 action:@selector(buttonClick:)];
    [self.view addSubview:_buttonTemp];
    [_buttonTemp setFrame:CGRectMake(self.view.centerX - 395*GPCommonLayoutScaleSizeWidthIndex, GPScreenHeight - kNavBarAndStatusBarHeight - 270*GPCommonLayoutScaleSizeWidthIndex, 790*GPCommonLayoutScaleSizeWidthIndex, 790*(110.0/790.0)*GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonTemp rounded:(55.0*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    [_buttonContent[0] setSelected:YES];
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
    if (!(_buttonContent[0].selected||_buttonContent[1].selected)) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请选择转移资产的去向" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    
    if (IsStringEmptyOrNull(_textFieldTemp[0].text)||([_textFieldTemp[0].text floatValue]==0 )) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请输入转出数量" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }else if([_textFieldTemp[0].text floatValue] > [_labelTemp[3].text floatValue])
    {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"可转出数量不足" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
    }
    else
    {
        return YES;
    }
    return NO;
    
    
}

-(void)netRequest
{
    HPWeak;
    [HPNetManager POSTWithUrlString:Hostmembermy_asset isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            self->_labelTemp[3].text = [NSString stringWithFormat:@"%@",response[@"result"][@"available"]];
        }
        //实名认证
        else if([response[@"code"] integerValue] == 10086)
        {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:response[@"message"] callbackBlock:^(NSInteger btnIndex) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

-(void)netRequestPointTransform
{
    HPWeak;
    [HPNetManager POSTWithUrlString:HostMembertransformPointTransform isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_textFieldTemp[0].text,@"point",_buttonContent[0].selected?@"1":@"2",@"transtype", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"成功" callbackBlock:^(NSInteger btnIndex) {
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
    NSString *strurl = @"asd";
    if (!IsStringEmptyOrNull(strurl))
    {
        
    }
}

-(void)buttonClick:(UIButton*)btn
{
    if (_buttonContent[0] == btn) {
        btn.selected = YES;
        _buttonContent[1].selected = NO;
        _labelTemp[1].text = btn.titleLabel.text;
    }
    else if (_buttonContent[1] == btn)
    {
        btn.selected = YES;
        _buttonContent[0].selected = NO;
        _labelTemp[1].text = btn.titleLabel.text;
    }
    else if (_buttonAll == btn)
    {
        _textFieldTemp[0].text = _labelTemp[3].text;
    }
    else if (_buttonTemp == btn)
    {
        if ([self checkAll]) {
            [self netRequestPointTransform];
        }
    }
}


#pragma mark - textFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
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
