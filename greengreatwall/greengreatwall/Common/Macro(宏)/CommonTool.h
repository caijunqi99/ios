//
//  CommonTool.h
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#ifndef Functions_h
#define Functions_h

#if defined __cplusplus
extern "C" {
#endif

#import <CoreLocation/CoreLocation.h>
#pragma mark - 判断是否为字符串
extern Boolean IsStringEmptyOrNull(NSString *str);
#pragma mark - 返回一个字符串，如果为null返回空字符串@""
extern NSString* StringNullOrNot(NSString *str);
#pragma mark - MBProgressHUD加载画面
extern void ShowAutoHideMBProgressHUD(UIView *onView, NSString *labelText);
extern void WaittingMBProgressHUD(UIView *onView, NSString *labelText);
extern void SuccessMBProgressHUD(UIView *onView, NSString *labelText);
extern void FailedMBProgressHUD(UIView *onView, NSString *labelText);
extern void FinishMBProgressHUD(UIView *onView);
#pragma mark - MD5加密
extern NSString* EncryptPassword(NSString *str);
#pragma mark - 获取键盘视图
extern UIView* GetKeyBoardView(void);
#pragma mark - 生成一张纯色图片
extern UIImage* GetImageUseColor(UIColor *color, CGRect frame);
extern UIImage* CreateImageWithColor(UIColor *color);
extern UIImage* stretcheImage(UIImage *img,UIEdgeInsets edge);
#pragma mark - 解析json
extern id DataWithJSON(id returnData);
#pragma mark- 计算文字的size
extern CGRect RectWithTextAndFontAndBreakModeAndWidth(NSString *text,UIFont *font,NSLineBreakMode mode,float width);
extern CGRect RectWithTextAndFontAndBreakModeAndHeight(NSString *text,UIFont *font,NSLineBreakMode mode,float height);
extern float getWidthWithTextAndFontAndBreakModeAndHeight(NSString *text,UIFont *font,NSLineBreakMode mode,float height);
extern float getHeightWithTextAndFontAndBreakModeAndWidth(NSString *text,UIFont *font,NSLineBreakMode mode,float width);
extern CGRect RectWithScale(CGRect originRect,CGFloat scale);

#pragma mark- 显示提示信息
extern void ShowMessageInSeconds(NSString * message,NSTimeInterval time);

#pragma mark - 设置不同字体颜色
extern void FuwenbenLabelWithFontAndColorInRange(UILabel *label,id font,UIColor *vaColor,NSRange range);
#pragma mark - 通知
extern void NSNotificationRemoveObserver(id anything,NSString *name);
extern void NSNotificationAddObserver(id anything,SEL selectorName,NSString *name);
extern void NSNotificationPost(NSString *name);
extern NSString* GetStringNow(void);
extern NSString * phoneType(void);

extern UIViewController* getCurrentViewController(void);

#if defined __cplusplus
}
#endif

#endif
