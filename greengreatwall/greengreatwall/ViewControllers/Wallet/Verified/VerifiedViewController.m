//
//  VerifiedViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/24.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "VerifiedViewController.h"

#import "AreaView.h"
#import "AreaModel.h"
@interface VerifiedViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,AreaSelectDelegate>
{
    UIImageView             *_imageViewWallet;
    
    UIView                  *_viewContent[3];
    
    UILabelAlignToTopLeft   *_labelTemp[7];
    UITextField             *_textFieldTemp[5];
    
    UIButton                *_buttonTemp;
    UIButton                *_buttonIDCardpositive;
    UIButton                *_buttonIDCardReverse;
    
    UIButton                *_buttonSelect;
    
    AreaView                *areaView;
    NSInteger               areaIndex;
    NSInteger               areaIndex1;
    NSInteger               areaIndex2;
    NSInteger               areaIndex3;
    NSMutableArray          *area_dataArray1;
    NSMutableArray          *area_dataArray2;
    NSMutableArray          *area_dataArray3;
    
    NSString                *stringProvince_id;
    NSString                *stringCity_id;
    NSString                *stringRegion_id;
    
    NSMutableArray<ProvinceModel *>          *_arrayDataSource;
    
    UIImagePickerController *pickerController;
    
    NSMutableArray          *_arrayDataSourcePhoto;
}


@end


@implementation VerifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
    
    //初始化pickController
    [self createData];
    
    [self netRequest];
}

-(instancetype)init
{
    if (self = [super init]) {
        _arrayDataSourcePhoto = [[NSMutableArray alloc]initWithObjects:@"0",@"0", nil];
        _arrayDataSource = [[NSMutableArray alloc]init];
        areaIndex1 = 99999999;
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

- (void)createData
{
    //初始化pickerController
    pickerController = [[UIImagePickerController alloc]init];
    pickerController.view.backgroundColor = [UIColor orangeColor];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
}

-(BOOL)checkAll
{
    if ([_textFieldTemp[2].text containsString:@"请选择"]||IsStringEmptyOrNull(_textFieldTemp[2].text)) {
        [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请选择所在地区" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        return NO;
    }
    
    for (NSObject *object in _arrayDataSourcePhoto) {
        if (![object isKindOfClass:[UIImage class]]) {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"请选择身份证照片" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
            return NO;
        }
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
            //            0默认，
            //            1审核中，
            //            2未通过，
            //            3已认证
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
                    [self->_arrayDataSourcePhoto replaceObjectAtIndex:0 withObject:image];
                }];
                [self->_buttonIDCardReverse sd_setImageWithURL:URL(response[@"result"][@"member_idcard_image3"]) forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [self->_arrayDataSourcePhoto replaceObjectAtIndex:1 withObject:image];
                }];
                [self->_textFieldTemp[3] setText:response[@"result"][@"member_bankname"]];
                [self->_textFieldTemp[4] setText:response[@"result"][@"member_bankcard"]];
            }
            if ([[NSString stringWithFormat:@"%@",response[@"result"][@"member_auth_state"]]isEqualToString:@"1"]) {
                [self->_buttonTemp setUserInteractionEnabled:NO];
                [self->_buttonTemp setTitle:@"认证中" forState:UIControlStateNormal];
                [self->_buttonTemp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self->_buttonTemp setBackgroundImage:CreateImageWithColor([UIColor lightGrayColor]) forState:UIControlStateNormal];
                
                [self->_buttonIDCardpositive setUserInteractionEnabled:NO];
                [self->_buttonIDCardReverse setUserInteractionEnabled:NO];
                for (NSInteger i = 0; i <5; i++) {
                    [self->_textFieldTemp[i] setUserInteractionEnabled:NO];
                }
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
                
                [self->_buttonIDCardpositive setUserInteractionEnabled:NO];
                [self->_buttonIDCardReverse setUserInteractionEnabled:NO];
                for (NSInteger i = 0; i <5; i++) {
                    [self->_textFieldTemp[i] setUserInteractionEnabled:NO];
                }
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
    
    if (99999999 != areaIndex1) {
        ProvinceModel *provinceModel = _arrayDataSource[areaIndex1];
        CityModel *cityModel = provinceModel.citysArray[areaIndex2];
        RegionModel *regionModel = cityModel.regionsArray[areaIndex3];
        
        stringProvince_id = provinceModel.area_id;
        stringCity_id = cityModel.area_id;
        stringRegion_id = regionModel.area_id;
    }
    
    WaittingMBProgressHUD(GPKeyWindow, @"正在上传,请等待...");
    [HPNetManager uploadImageWithUrlString:HostMmemberauthauth parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"userid"],@"member_id",_textFieldTemp[0].text,@"username",_textFieldTemp[1].text,@"idcard",_textFieldTemp[2].text,@"member_areainfo",_textFieldTemp[3].text,@"member_bankname",_textFieldTemp[4].text,@"member_bankcard",stringCity_id,@"member_cityid",stringRegion_id,@"member_areaid",stringProvince_id,@"member_provinceid",@"1",@"commit", nil] imageArray:_arrayDataSourcePhoto fileNames:@[@"member_idcard_image2",@"member_idcard_image3"] imageType:@"jpg" imageScale:1 successBlock:^(id response) {
        
        FinishMBProgressHUD(GPKeyWindow);
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"认证成功" callbackBlock:^(NSInteger btnIndex) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                //                HPNOTIF_POST(@"refreshAddressList", nil);
            } cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确定",nil];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failurBlock:^(NSError *error) {
        //GPDebugLog(@"error:%@",error.description);
        //NSDictionary * data = error.userInfo;
        //GPDebugLog(@"data:%@",data)
        //NSString * str = [[NSString alloc]initWithData:data[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        //GPDebugLog(@"服务器的错误原因:%@",str);
        FinishMBProgressHUD(GPKeyWindow);
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        //GPDebugLog(@"bytesProgress:%lld",bytesProgress);
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
        [self changeIconAction];
    }
    else if (_buttonIDCardpositive == btn)
    {
        [self changeIconAction];
    }
    else if (_buttonTemp == btn)
    {
        if ([self checkAll]) {
            [self uploadInfo];
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

- (void)changeIconAction{
    [HPAlertTools showActionSheetWith:self title:@"选择照片" message:nil callbackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 0){
            
        }else if (btnIndex == 1) {//相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                //GPDebugLog(@"支持相机");
                [self makePhoto];
            }else{
                
                [HPAlertTools showAlertWith:self title:@"提示信息" message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" callbackBlock:^(NSInteger btnIndex) {
                    
                } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我知道了",nil];
                
            }
        }else if (btnIndex == 2){//相册
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                //GPDebugLog(@"支持相册");
                [self choosePicture];
            }else{
                [HPAlertTools showAlertWith:self title:@"提示信息" message:@"请在设置-->隐私-->相机，中开启本应用的相册访问权限！！" callbackBlock:^(NSInteger btnIndex) {
                    
                } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我知道了",nil];
            }
        }else if (btnIndex == 3){//图库
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                //GPDebugLog(@"支持图库");
                [self pictureLibrary];
                //            [self presentViewController:picker animated:YES completion:nil];
            }else{
                [HPAlertTools showAlertWith:self title:@"提示信息" message:@"请在设置-->隐私-->相机，中开启本应用的图库访问权限！！" callbackBlock:^(NSInteger btnIndex) {
                    
                } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我知道了",nil];
            }
        }
    } destructiveButtonTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册",@"图库", nil];
    
}

//跳转到imagePicker里
- (void)makePhoto
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//跳转到相册
- (void)choosePicture
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//跳转图库
- (void)pictureLibrary
{
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//用户取消退出picker时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //GPDebugLog(@"%@",picker);
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //GPDebugLog(@"%s,info == %@",__func__,info);
    
    UIImage *userImage = [self fixOrientation:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
    //    userImage = [self scaleImage:userImage toScale:0.3];
    
    //保存图片
    //    [self saveImage:userImage name:@"某个特定标示"];
    
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
    [_buttonSelect setImage:userImage forState:UIControlStateNormal];
    _buttonSelect.clipsToBounds = YES;
    if (_buttonSelect == _buttonIDCardpositive) {
        [_arrayDataSourcePhoto replaceObjectAtIndex:0 withObject:userImage];
    }else if (_buttonSelect == _buttonIDCardReverse){
        [_arrayDataSourcePhoto replaceObjectAtIndex:1 withObject:userImage];
    }
}

//- (void)upDateHeadIcon:(UIImage *)photo
//{
//    //两种方式上传头像
//    /*方式一：使用NSData数据流传图片*/
//    NSString *imageURl = @"";
//    manager.res = [AFHTTPResponseSerializer serializer];
//
//    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
//    [manager POST:imageURl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//        [formData appendPartWithFileData:UIImageJPEGRepresentation(photo, 1.0) name:@"text" fileName:@"test.jpg" mimeType:@"image/jpg"];
//
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
//    /*方式二：使用Base64字符串传图片*/
//    NSData *data = UIImageJPEGRepresentation(photo, 1.0);
//
//    NSString *pictureDataString=[data base64Encoding];
//    NSDictionary * dic  = @{@"verbId":@"modifyUserInfo",@"deviceType":@"ios",@"userId":@"",@"photo":pictureDataString,@"mobileTel":@""};
//    [manager POST:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([[responseObject objectForKey:@"flag"] intValue] == 0) {
//
//        }else{
//
//        }
//    }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//          }];
//}
//保存照片到沙盒路径(保存)
- (void)saveImage:(UIImage *)image name:(NSString *)iconName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //写入文件
    NSString *icomImage = iconName;
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", icomImage]];
    // 保存文件的名称
    //    [[self getDataByImage:image] writeToFile:filePath atomically:YES];
    [UIImagePNGRepresentation(image)writeToFile: filePath  atomically:YES];
}
//缩放图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //GPDebugLog(@"%@",NSStringFromCGSize(scaledImage.size));
    return scaledImage;
}
//修正照片方向(手机转90度方向拍照)
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
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
