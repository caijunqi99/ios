//
//  CommonTool.m
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import "CommonTool.h"
#import "MBProgressHUD.h"
#import <MJExtension.h>

#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

NSString*sha(NSString*input)
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(NSInteger  i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

#pragma mark -判断是否为空
Boolean IsStringEmptyOrNull(NSString * str)
{
    if ([str isEqual:[NSNull null]])
    {
        return true;
    }
    else if (!str)
    {
        return true;
    }
    else
    {
        if ([str isKindOfClass:[NSString class]]) {
            
            NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([trimedString length] == 0)
            {
                // empty string
                return true;
            }
            else if([trimedString isEqualToString:@"null"])
            {
                // is neither empty nor null
                return true;
            }
            else if([trimedString isEqualToString:@"(null)"])
            {
                // is neither empty nor null
                return true;
            }
            else
            {
                return false;
            }
            
        }else if ([str isKindOfClass:[NSNumber class]]){
            return false;
        }
    }
    return false;
}

#pragma mark -判断是否为空
NSString* StringNullOrNot(NSString *str)
{
    if (IsStringEmptyOrNull(str))
    {
        return @"";
    }
    else
    {
        return str;
    }
}


#pragma mark -MBProgressHUD
MBProgressHUD* CreateCustomColorHUDOnView(UIView *onView)
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:onView];
    //hud.color = kColorBorderColorClay;
    //hud.labelColor = kColorTextColorDarkClay;
    return hud;
}

void ShowAutoHideMBProgressHUD(UIView *onView, NSString *labelText)
{
    if (!onView || [labelText length] <= 0)
        return;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:onView];
    if (hud == nil)
    {
        hud = CreateCustomColorHUDOnView(onView);
    }
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = labelText;
    [hud hideAnimated:YES afterDelay:2.0];
    [onView addSubview:hud];
    [hud showAnimated:YES];
}

void WaittingMBProgressHUD(UIView *onView, NSString *labelText)
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:onView];
    if (hud == nil)
    {
        hud = CreateCustomColorHUDOnView(onView);
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = labelText;
    [onView addSubview:hud];
    [hud showAnimated:YES];
}

void SuccessMBProgressHUD(UIView *onView, NSString *labelText)
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:onView];
    if (hud == nil)
    {
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_tips_ok.png"]];
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = labelText;
    [onView addSubview:hud];
    [onView bringSubviewToFront:hud];
    [hud hideAnimated:YES afterDelay:2.0];
}
void FailedMBProgressHUD(UIView *onView, NSString *labelText)
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:onView];
    if (hud == nil)
    {
        return;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_tips_error.png"]];
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = labelText;
    [onView addSubview:hud];
    [onView bringSubviewToFront:hud];
    [hud hideAnimated:YES afterDelay:2.0];
}
void FinishMBProgressHUD(UIView *onView)
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:onView];
    if (hud == nil)
    {
        return;
    }
    [hud hideAnimated:YES];
}


#pragma mark -MD5加密
NSString* EncryptPassword(NSString *str)
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


#pragma mark -获取键盘视图
UIView* GetKeyBoardView()
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIView *keyboardView = nil;
    for(UIView *window in windows)
    {
        NSArray *viewsArray = [window subviews];
        for(UIView *view in viewsArray)
        {
            if([[NSString stringWithUTF8String:object_getClassName(view)] isEqualToString:[[[UIDevice currentDevice] systemVersion] floatValue]>=8.0 ?
                @"UIInputSetContainerView" : @"UIPeripheralHostView"])
            { // 是键盘视图
                keyboardView = view;
                break;
            }
        }
    }
    return keyboardView;
}


#pragma mark -生成一张纯色图片
UIImage* GetImageUseColor(UIColor *color, CGRect frame)
{
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

UIImage* CreateImageWithColor(UIColor *color)
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

UIImage* stretcheImage(UIImage *img,UIEdgeInsets edge)
{
    [img resizableImageWithCapInsets:edge];
    if(6.0<=[[[UIDevice currentDevice] systemVersion] floatValue])
    {
        [img resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    }
    return img;
}




#pragma mark -解析json
id DataWithJSON(id returnData)
{
    return [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
}

#pragma mark- 计算文字的size
CGRect RectWithTextAndFontAndBreakModeAndWidth(NSString *text,UIFont *font,NSLineBreakMode mode,float width)
{
    UIColor *color = [UIColor grayColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = mode;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          color, NSForegroundColorAttributeName,
                                          paragraphStyle,NSParagraphStyleAttributeName,
                                          nil];
    CGSize size = CGSizeMake(width, FLT_MAX);
    return [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
}

CGRect RectWithTextAndFontAndBreakModeAndHeight(NSString *text,UIFont *font,NSLineBreakMode mode,float height)
{
    UIColor *color = [UIColor grayColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = mode;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          color, NSForegroundColorAttributeName,
                                          paragraphStyle,NSParagraphStyleAttributeName,
                                          nil];
    CGSize size = CGSizeMake(FLT_MAX,height);
    return [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
}

float getWidthWithTextAndFontAndBreakModeAndHeight(NSString *text,UIFont *font,NSLineBreakMode mode,float height)
{
    return CGRectGetWidth(RectWithTextAndFontAndBreakModeAndHeight(text, font, mode, height));
}

float getHeightWithTextAndFontAndBreakModeAndWidth(NSString *text,UIFont *font,NSLineBreakMode mode,float width)
{
    return CGRectGetHeight(RectWithTextAndFontAndBreakModeAndWidth(text, font, mode, width));
}

CGRect RectWithScale(CGRect originRect,CGFloat scale)
{
    CGRect rect = CGRectMake(originRect.origin.x*scale, originRect.origin.y*scale, originRect.size.width*scale, originRect.size.height*scale);
    
    return rect;
}

//设置不同字体颜色
void FuwenbenLabelWithFontAndColorInRange(UILabel *label,id font,UIColor *vaColor,NSRange range)
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    label.attributedText = str;
}

#pragma mark- 显示提示信息
void ShowMessageInSeconds(NSString * message,NSTimeInterval time)
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor grayColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    
    
    CGFloat height = CGRectGetHeight(RectWithTextAndFontAndBreakModeAndWidth(message, FontRegularWithSize(16), LineBreakModeDefault, screenSize.width - 40));
    
    label.frame = CGRectMake(10, 5, screenSize.width -40, height);
    label.text = message;
    label.numberOfLines = 0;
    label.lineBreakMode = LineBreakModeDefault;
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = FontRegularWithSize(16);
    [showview addSubview:label];
    
    showview.frame = CGRectMake(10,
                                (screenSize.height - height - 10)/2,
                                screenSize.width - 20,
                                height+10);
    
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

void NSNotificationRemoveObserver(id anything,NSString *name)
{
    [[NSNotificationCenter defaultCenter]removeObserver:anything name:name object:nil];
}

void NSNotificationAddObserver(id anything,SEL selectorName,NSString *name)
{
    [[NSNotificationCenter defaultCenter] addObserver:anything selector:selectorName name:name object:nil];
}

void NSNotificationPost(NSString *name)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

NSString * GetStringNow()
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentOlderOneDateStr;
}

NSString * phoneType()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*phoneType = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([phoneType  isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([phoneType  isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([phoneType  isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([phoneType  isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([phoneType  isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([phoneType  isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([phoneType  isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([phoneType  isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([phoneType  isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([phoneType  isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([phoneType  isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([phoneType  isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([phoneType  isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([phoneType  isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([phoneType  isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([phoneType  isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([phoneType  isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([phoneType  isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([phoneType  isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([phoneType  isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([phoneType  isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([phoneType  isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([phoneType  isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([phoneType  isEqualToString:@"iPhone11,8"]) return@"iPhone XR";
    
    if([phoneType  isEqualToString:@"iPhone11,2"]) return@"iPhone XS";
    
    if([phoneType  isEqualToString:@"iPhone11,4"]) return@"iPhone XS Max";
    
    if([phoneType  isEqualToString:@"iPhone11,6"]) return@"iPhone XS Max";
    
    return @"Unknown";
}


UIViewController* getCurrentViewController()
{
    UIViewController *result = nil;
    // 获取默认的window
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    // app默认windowLevel是UIWindowLevelNormal，如果不是，找到它。
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    // 获取window的rootViewController
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}
