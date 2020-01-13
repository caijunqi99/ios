//
//  PersonnalInfoViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/12.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "PersonnalInfoViewController.h"

@interface PersonnalInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UILabel                 *_labelTemp;
    UIButton                *_buttonUserHead;
    
    NSMutableArray          *_arrayDataSource;
    
    UIImagePickerController *pickerController;
    
    NSMutableArray          *_arrayDataSourcePhoto;
    
    BOOL                    _isEditable;
    NSString                *_stringNickname;
}
@property(nonatomic,strong)UIView               *viewTemp;
@property(nonatomic,strong)UIView               *viewContent;
@property(nonatomic,strong)UIView               *viewContentII;
@property(nonatomic,strong)UITextField          *textFieldUsername;
@property(nonatomic,strong)UITextField          *textFieldNickname;


@end


@implementation PersonnalInfoViewController

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
        _isEditable = NO;
        _arrayDataSource = [[NSMutableArray alloc]init];
        _arrayDataSourcePhoto = [NSMutableArray arrayWithObject:@""];
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
    [self settingNavTitle:@"个人资料" WithNavTitleColor:[UIColor blackColor]];
    [self setRightNavButtonWithImage:nil Title:@"编辑" Frame:CGRectMake(0, 0, 30, 30) Target:self action:@selector(rightClick)];
    viewSetBackgroundColor(kColorBasic);
    
    
    [self.view addSubview:self.viewTemp];
    [self.viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight)];
    
    [self.viewTemp addSubview:self.viewContent];
    [self.viewContent setFrame:CGRectMake(0, 30*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth, 190*GPCommonLayoutScaleSizeWidthIndex)];
    
    _labelTemp = [UILabel initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:@"头像"];
    _labelTemp.lineBreakMode = LineBreakModeDefault;
    _labelTemp.backgroundColor = [UIColor clearColor];
    [_labelTemp setFrame:RectWithScale(CGRectMake(30, 25, 200, 120), GPCommonLayoutScaleSizeWidthIndex)];
    [self.viewContent addSubview:_labelTemp];
    [_labelTemp setTextColor:[UIColor blackColor]];
    _labelTemp.textAlignment = NSTextAlignmentLeft;
    
    _buttonUserHead = [UIButton initButtonTitleFont:22 titleColor:[UIColor clearColor] backgroundColor:[UIColor clearColor] imageName:nil titleName:@"头像"];
    [_buttonUserHead setBackgroundImage:CreateImageWithColor([UIColor grayColor]) forState:UIControlStateNormal];
    [_buttonUserHead addTarget:self tag:13 action:@selector(buttonClick:)];
    [_buttonUserHead setFrame:RectWithScale(CGRectMake(860, 40, 110, 110), GPCommonLayoutScaleSizeWidthIndex)];
    [_viewContent addSubview:_buttonUserHead];
    [_buttonUserHead rounded:(55*GPCommonLayoutScaleSizeWidthIndex)];
    _buttonUserHead.userInteractionEnabled = NO;
    
    
    [self.viewTemp addSubview:self.viewContentII];
    [self.viewContentII setFrame:CGRectMake(0, 250*GPCommonLayoutScaleSizeWidthIndex, GPScreenWidth, 300*GPCommonLayoutScaleSizeWidthIndex)];
    
    [self.viewContentII addSubview:self.textFieldUsername];
    [self.textFieldUsername setFrame:CGRectMake(0, 25*GPCommonLayoutScaleSizeWidthIndex, self.viewContentII.width - 30*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    [self.viewContentII addSubview:self.textFieldNickname];
    [self.textFieldNickname setFrame:CGRectMake(0, 155*GPCommonLayoutScaleSizeWidthIndex, self.viewContentII.width - 30*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    _isEditable = !_isEditable;
    if (_isEditable) {
        [self setRightNavButtonWithImage:nil Title:@"完成" Frame:CGRectMake(0, 0, 30, 30) Target:self action:@selector(rightClick)];
        _textFieldNickname.userInteractionEnabled = YES;
        _buttonUserHead.userInteractionEnabled = YES;
        [_textFieldNickname becomeFirstResponder];
    }else{
        [self setRightNavButtonWithImage:nil Title:@"编辑" Frame:CGRectMake(0, 0, 30, 30) Target:self action:@selector(rightClick)];
        _textFieldNickname.userInteractionEnabled = NO;
        _buttonUserHead.userInteractionEnabled = NO;
        if (![_stringNickname isEqualToString:_textFieldNickname.text]) {
            if (IsStringEmptyOrNull(_textFieldNickname.text)) {
                [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:@"昵称不能为空" buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
            }else{
                [self netRequestEdit];
            }
            
        }
    }
}

- (void)createData
{
    //初始化pickerController
    pickerController = [[UIImagePickerController alloc]init];
    pickerController.view.backgroundColor = [UIColor orangeColor];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
}

-(void)netRequest
{
    [HPNetManager POSTWithUrlString:Hostmemberindex isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            [self updateInterfaceWithDic:response[@"result"]];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

-(void)updateInterfaceWithDic:(NSDictionary*)dic
{
    NSDictionary *dicMemberInfo = dic[@"member_info"];
    
    NSString *stringusername = dicMemberInfo[@"mobile"];//[HPUserDefault objectForKey:@"username"];//dicMemberInfo[@"mobile"]
    _textFieldUsername.text = stringusername;
    
    NSString *stringNickname = dicMemberInfo[@"user_name"];
    _textFieldNickname.text = stringNickname;
    _stringNickname = stringNickname;
    
    NSString *stringavator = dicMemberInfo[@"avator"];
    [_buttonUserHead sd_setBackgroundImageWithURL:URL(stringavator) forState:UIControlStateNormal placeholderImage:defaultImage];
}

-(void)netRequestupload
{
//    HPWeak;
    [HPNetManager uploadImageWithUrlString:Hostmemberupload parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key", nil] imageArray:_arrayDataSourcePhoto fileNames:@[@"pic"] imageType:@"jpg" imageScale:1 successBlock:^(id response) {
        
        GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            HPNOTIF_POST(@"refreshUserInfo", nil);
            [self->_buttonUserHead setBackgroundImage:((UIImage*)self->_arrayDataSourcePhoto[0]) forState:UIControlStateNormal];
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"修改头像成功" callbackBlock:^(NSInteger btnIndex) {
                SDImageCache *imageCache = [SDImageCache sharedImageCache];
                [imageCache clearMemory];
                [imageCache clearDiskOnCompletion:^{
                    
                }];
            } cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确定",nil];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failurBlock:^(NSError *error) {
        //GPDebugLog(@"error:%@",error.description);
        NSDictionary * data = error.userInfo;
        //GPDebugLog(@"data:%@",data)
        NSString * str = [[NSString alloc]initWithData:data[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        //GPDebugLog(@"服务器的错误原因:%@",str);
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        //GPDebugLog(@"bytesProgress:%lld",bytesProgress);
    }];
}


-(void)netRequestEdit
{
    [HPNetManager POSTWithUrlString:Hostmembermy_edit isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:[HPUserDefault objectForKey:@"token"],@"key",@"1",@"commit",_textFieldNickname.text,@"member_name", nil] successBlock:^(id response) {
        //@"man",@"member_sex",@"1",@"member_email",
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            HPNOTIF_POST(@"refreshUserInfo", nil);
            self->_stringNickname = self->_textFieldNickname.text;
            
            [HPAlertTools showAlertWith:self title:@"提示信息" message:@"修改昵称成功" callbackBlock:^(NSInteger btnIndex) {
                
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

-(void)buttonClick:(UIButton*)btn{
    if (_buttonUserHead == btn)
    {
        [self changeIconAction];
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
            }else{
                [HPAlertTools showAlertWith:self title:@"提示信息" message:@"请在设置-->隐私-->相机，中开启本应用的图库访问权限！！" callbackBlock:^(NSInteger btnIndex) {
                    
                } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我知道了",nil];
            }
        }
    } destructiveButtonTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册",@"图库", nil];
    
}

//跳转到imagePicker里
- (void)makePhoto{
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//跳转到相册
- (void)choosePicture{
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//跳转图库
- (void)pictureLibrary{
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//用户取消退出picker时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //GPDebugLog(@"%@",picker);
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //GPDebugLog(@"%s,info == %@",__func__,info);
    
    UIImage *userImage = [self fixOrientation:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
//    userImage = [self scaleImage:userImage toScale:0.3];
    
    //保存图片
    //    [self saveImage:userImage name:@"某个特定标示"];
    
    [pickerController dismissViewControllerAnimated:YES completion:^{
        [self->_arrayDataSourcePhoto replaceObjectAtIndex:0 withObject:userImage];
        [self netRequestupload];
    }];
}

//保存照片到沙盒路径(保存)
- (void)saveImage:(UIImage *)image name:(NSString *)iconName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //写入文件
    NSString *icomImage = iconName;
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", icomImage]];
    // 保存文件的名称
    //    [[self getDataByImage:image] writeToFile:filePath atomically:YES];
    [UIImagePNGRepresentation(image)writeToFile: filePath  atomically:YES];
}
//缩放图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
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
        _textFieldUsername = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@""];
        _textFieldUsername.keyboardType = UIKeyboardTypeNumberPad;
        _textFieldUsername.textAlignment = NSTextAlignmentRight;
        _textFieldUsername.userInteractionEnabled = NO;
        UILabel *label = [UILabel initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:@"账号"];
        label.textAlignment = NSTextAlignmentLeft;
        [label setFrame:CGRectMake(30*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 220*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [view addSubview:label];
        _textFieldUsername.leftView = view;
        _textFieldUsername.leftView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldUsername.leftView.layer.masksToBounds = YES;
        _textFieldUsername.leftView.clipsToBounds = YES;
        _textFieldUsername.leftViewMode = UITextFieldViewModeAlways;
        
        
        UIView *viewRight = [UIView initViewBackColor:[UIColor whiteColor]];
        [viewRight setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        _textFieldNickname.rightView = viewRight;
        _textFieldNickname.rightView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldNickname.rightView.layer.masksToBounds = YES;
        _textFieldNickname.rightView.clipsToBounds = YES;
        _textFieldNickname.rightViewMode = UITextFieldViewModeAlways;
    }
    return _textFieldUsername;
}

-(UITextField *)textFieldNickname
{
    if (!_textFieldNickname) {
        _textFieldNickname = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"6-12位数字字母组合"];
        _textFieldNickname.keyboardType = UIKeyboardTypeDefault;
        _textFieldNickname.textAlignment = NSTextAlignmentRight;
        _textFieldNickname.userInteractionEnabled = NO;
        UILabel *label = [UILabel initLabelTextFont:FontRegularWithSize(12) textColor:[UIColor blackColor] title:@"昵称"];
        label.textAlignment = NSTextAlignmentLeft;
        [label setFrame:CGRectMake(30*GPCommonLayoutScaleSizeWidthIndex, 10*GPCommonLayoutScaleSizeWidthIndex, 160*GPCommonLayoutScaleSizeWidthIndex, 100*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *view = [UIView initViewBackColor:[UIColor whiteColor]];
        [view setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 220*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [view addSubview:label];
        _textFieldNickname.leftView = view;
        _textFieldNickname.leftView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldNickname.leftView.layer.masksToBounds = YES;
        _textFieldNickname.leftView.clipsToBounds = YES;
        _textFieldNickname.leftViewMode = UITextFieldViewModeAlways;
        
        
        UIImageView *imageView = [UIImageView initImageView:@"编辑拷贝"];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView setFrame:CGRectMake(30*GPCommonLayoutScaleSizeWidthIndex, 40*GPCommonLayoutScaleSizeWidthIndex, 40*GPCommonLayoutScaleSizeWidthIndex, 40*GPCommonLayoutScaleSizeWidthIndex)];
        UIView *viewRight = [UIView initViewBackColor:[UIColor whiteColor]];
        [viewRight setFrame:CGRectMake(0*GPCommonLayoutScaleSizeWidthIndex, 0*GPCommonLayoutScaleSizeWidthIndex, 70*GPCommonLayoutScaleSizeWidthIndex, 120*GPCommonLayoutScaleSizeWidthIndex)];
        [viewRight addSubview:imageView];
        _textFieldNickname.rightView = viewRight;
        _textFieldNickname.rightView.contentMode = UIViewContentModeScaleAspectFit;
        _textFieldNickname.rightView.layer.masksToBounds = YES;
        _textFieldNickname.rightView.clipsToBounds = YES;
        _textFieldNickname.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    return _textFieldNickname;
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

