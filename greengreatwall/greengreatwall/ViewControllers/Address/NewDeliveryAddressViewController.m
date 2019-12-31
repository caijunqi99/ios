//
//  NewDeliveryAddressViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/16.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "NewDeliveryAddressViewController.h"

#import "AreaView.h"
#import "AreaModel.h"
#import "AddCustomerWihtMapVC.h"

@interface NewDeliveryAddressViewController ()<UITextFieldDelegate,AreaSelectDelegate>
{
    UILabelAlignToTopLeft   *_labelTemp[5];
    UITextField             *_textFieldTemp[4];
    
    AreaView                *areaView;
    NSInteger               areaIndex;
    NSInteger               areaIndex1;
    NSInteger               areaIndex2;
    NSInteger               areaIndex3;
    NSMutableArray          *area_dataArray1;
    NSMutableArray          *area_dataArray2;
    NSMutableArray          *area_dataArray3;
    
    NSMutableArray<ProvinceModel *>          *_arrayDataSource;
}
@property(nonatomic,strong)UIView               *viewTemp;
@property(nonatomic,strong)UIView               *viewTempII;

@property(nonatomic,strong)UIView               *viewLine;
@property(nonatomic,strong)UIView               *viewLineII;
@property(nonatomic,strong)UIView               *viewLineIII;
@property(nonatomic,strong)UIView               *viewLineIV;

@property(nonatomic,strong)UIButton             *buttonTemp;
@property(nonatomic,strong)UIButton             *buttonAddress;
@property(nonatomic,strong)UIButton             *buttonSetDefault;


@end

#define kBottomHeightCommon        (130*GPCommonLayoutScaleSizeWidthIndex)

@implementation NewDeliveryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
}

-(instancetype)init
{
    if (self = [super init]) {
        _arrayDataSource = [[NSMutableArray alloc]init];
        areaIndex = 0;
        area_dataArray1 = [[NSMutableArray alloc]init];
        area_dataArray2 = [[NSMutableArray alloc]init];
        area_dataArray3 = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)dealloc
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)configInterface
{
    
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    [self settingNavTitle:@"新增收货人"];
    
    viewSetBackgroundColor(kColorBasic);
    
    [self.viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, 240)];
    [self.view addSubview:self.viewTemp];
    
    NSArray *arrayLabelText = @[@"收货人",@"手机号码",@"所在地区",@"详细地址",@"设置默认地址"];
    NSArray *arrayPlaceHolderText = @[@"请填写收货人姓名",@"请填写收货人手机号",@"请选择",@"街道楼牌号等"];
    
    for (NSInteger i = 0; i<5; i++) {
        
        _labelTemp[i] = [UILabelAlignToTopLeft initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:arrayLabelText[i]];
        _labelTemp[i].lineBreakMode = NSLineBreakByCharWrapping;
        _labelTemp[i].backgroundColor = [UIColor clearColor];
        [_labelTemp[i] setFrame:CGRectMake(10, 10, 80, 40)];
        
        if (i<4) {
            _textFieldTemp[i] = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:arrayPlaceHolderText[i]];
            _textFieldTemp[i].keyboardType = UIKeyboardTypeDefault;
            UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
            [view setFrame:CGRectMake(0, 0, 100, 60)];
            [view addSubview:_labelTemp[i]];
            _textFieldTemp[i].leftView = view;
            _textFieldTemp[i].leftView.contentMode = UIViewContentModeScaleAspectFit;
            _textFieldTemp[i].leftView.layer.masksToBounds = YES;
            _textFieldTemp[i].leftView.clipsToBounds = YES;
            _textFieldTemp[i].leftViewMode = UITextFieldViewModeAlways;
            
            _textFieldTemp[i].delegate = self;
            
            [self.viewTemp addSubview:_textFieldTemp[i]];
            [_textFieldTemp[i] setFrame:CGRectMake(0, (self.viewTemp.height/4.0) *i, self.viewTemp.width, self.viewTemp.height/4.0)];
        }
    }
    
    _textFieldTemp[1].keyboardType = UIKeyboardTypeNumberPad;
    
    
    [self.buttonAddress setFrame:CGRectMake(15, 10, 30, 40)];
    [self.buttonSetDefault setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
    [view setFrame:CGRectMake(0, 0, 60, 60)];
    [view addSubview:_buttonAddress];
    _textFieldTemp[3].rightView = view;
    _textFieldTemp[3].rightView.contentMode = UIViewContentModeScaleAspectFit;
    _textFieldTemp[3].rightView.layer.masksToBounds = YES;
    _textFieldTemp[3].rightView.clipsToBounds = YES;
    _textFieldTemp[3].rightViewMode = UITextFieldViewModeAlways;
    
    
    [self.view addSubview:self.viewTempII];
    [self.viewTempII setFrame:CGRectMake(0, self.viewTemp.bottom + 10, GPScreenWidth, 60)];
    
    [self.viewTempII addSubview:self.buttonSetDefault];
    [self.buttonSetDefault setFrame:CGRectMake(self.viewTempII.width - 60, 10, 40, 40)];
    [self.buttonSetDefault setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    
    [_labelTemp[4] setFrame:CGRectMake(10, 10, _buttonSetDefault.left - 10 - 5, 40)];
    [self.viewTempII addSubview:_labelTemp[4]];
    
    
    
    
    [self.view addSubview:self.buttonTemp];
    [self.buttonTemp setFrame:CGRectMake(0, GPScreenHeight - kBottomHeightCommon - kNavBarAndStatusBarHeight, GPScreenWidth, kBottomHeightCommon)];
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
    
    if (IsStringEmptyOrNull(_textFieldTemp[0].text)||IsStringEmptyOrNull(_textFieldTemp[1].text)||IsStringEmptyOrNull(_textFieldTemp[2].text)||IsStringEmptyOrNull(_textFieldTemp[3].text)) {
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

-(void)netRequest
{
    
    HPWeak;
    
    ProvinceModel *provinceModel = _arrayDataSource[areaIndex1];
    CityModel *cityModel = provinceModel.citysArray[areaIndex2];
    RegionModel *regionModel = cityModel.regionsArray[areaIndex3];
    
    NSString *stringCity_id = cityModel.area_id;
    NSString *stringRegion_id = regionModel.area_id;
    
    [HPNetManager POSTWithUrlString:HostMemberaddressaddress_add isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",_textFieldTemp[0].text,@"true_name",_textFieldTemp[1].text,@"mob_phone",stringCity_id,@"city_id",stringRegion_id,@"area_id",_textFieldTemp[3].text,@"address",_textFieldTemp[2].text,@"area_info",_buttonSetDefault.selected?@"1":@"0",@"is_default",@"1",@"longitude",@"1",@"latitude", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"添加成功" callbackBlock:^(NSInteger btnIndex) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                HPNOTIF_POST(@"refreshAddressList", nil);
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
    NSInteger index = tap.view.tag - 200;
    NSString *strurl = @"asd";
    if (!IsStringEmptyOrNull(strurl))
    {
        
    }
}

-(void)buttonClick:(UIButton*)btn
{
    if (_buttonSetDefault == btn) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            [btn setImage:GetImage(@"选中") forState:UIControlStateNormal];
        }
        else
        {
            [btn setImage:GetImage(@"椭圆") forState:UIControlStateNormal];
        }
    }
    else if (_buttonAddress == btn)
    {
        [self getLocationAuthorizationStatusWithSuccess:^(NSInteger Index){
            
            AddCustomerWihtMapVC *vc = [[AddCustomerWihtMapVC alloc] initWihtBlcok:^(id  _Nonnull obj) {
                NSString *stringAddress = (NSString*)obj;
                [self->_textFieldTemp[3] setText:stringAddress];
            }];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    else if (_buttonTemp == btn)
    {
        if ([self checkAll]) {
            [self netRequest];
        }
    }
}


#pragma mark - textFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == _textFieldTemp[2]) {
        if (!areaView)
        {
            [self requestAllAreaName];
        }
        else
        {
            [areaView showAreaView];
        }
        return NO;
    }
    return YES;
}

#pragma mark - AreaSelectDelegate
- (void)selectIndex:(NSInteger)index atIndex:(NSInteger)atIndex
{
    areaIndex = atIndex;
    switch (areaIndex) {
        case 1:
            [area_dataArray2 removeAllObjects];
            areaIndex1 = index;
            break;
        case 2:
            [area_dataArray3 removeAllObjects];
            areaIndex2 = index;
            break;
        case 3:
            areaIndex3 = index;
            break;
        default:
            break;
    }
    [self requestAllAreaName];
}
- (void)getSelectAddressInfor:(NSString *)addressInfor
{
    _textFieldTemp[2].text = addressInfor;
    //GPDebugLog(@"areaIndex1:%ld,areaIndex2:%ld,areaIndex3:%ld",(long)areaIndex1,(long)areaIndex2,(long)areaIndex3);
}



#pragma mark - requestAllAreaName
- (void)requestAllAreaName
{
    [GPKeyWindow endEditing:YES];
    if (!areaView) {
        
        areaView = [[AreaView alloc]initWithFrame:GPKeyWindow.bounds];
        areaView.hidden = YES;
        areaView.address_delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:areaView];
    }
    NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"area"] ofType:@"plist"];
    NSMutableDictionary *plistDic=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    for (NSDictionary *sh_dic in plistDic[@"result"][@"area_list"]) {
        ProvinceModel *provinceModel = [[ProvinceModel alloc]init];
        [provinceModel setValuesForKeysWithDictionary:sh_dic];
        [_arrayDataSource addObject:provinceModel];
    }
    switch (areaIndex) {
        case 0:
        {
            [areaView showAreaView];
            [areaView setProvinceArray:_arrayDataSource];
        }
            break;
        case 1:
        {
            ProvinceModel *provinceModel = _arrayDataSource[areaIndex1];
            
            [areaView setCityArray:provinceModel.citysArray];
        }
            break;
        case 2:
        {
            ProvinceModel *provinceModel = _arrayDataSource[areaIndex1];
            CityModel *cityModel = provinceModel.citysArray[areaIndex2];
            
            [areaView setRegionsArray:cityModel.regionsArray];
        }
            
            break;
        default:
            break;
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

-(UIView *)viewTempII
{
    if (!_viewTempII) {
        _viewTempII = [UIView initViewBackColor:[UIColor whiteColor]];
    }
    return _viewTempII;
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

-(UIButton *)buttonTemp
{
    if (!_buttonTemp) {
        _buttonTemp = [UIButton initButtonTitleFont:22 titleColor:[UIColor whiteColor] backgroundColor:kColorTheme imageName:@"" titleName:@"保存"];
        [_buttonTemp addTarget:self tag:11 action:@selector(buttonClick:)];
    }
    return _buttonTemp;
}

-(UIButton *)buttonSetDefault
{
    if (!_buttonSetDefault) {
        _buttonSetDefault = [UIButton initButtonTitleFont:22 titleColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] imageName:@"椭圆" titleName:@"默认"];
        [_buttonSetDefault addTarget:self tag:12 action:@selector(buttonClick:)];
    }
    return _buttonSetDefault;
}

-(UIButton *)buttonAddress
{
    if (!_buttonAddress) {
        _buttonAddress = [UIButton initButtonTitleFont:22 titleColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] imageName:nil titleName:@"地址"];
        [_buttonAddress setBackgroundImage:GetImage(@"地址商品详情") forState:UIControlStateNormal];
        [_buttonAddress addTarget:self tag:13 action:@selector(buttonClick:)];
    }
    return _buttonAddress;
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
