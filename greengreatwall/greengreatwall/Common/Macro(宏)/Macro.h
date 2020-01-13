//
//  Macro.h
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#pragma mark - 宏定义
/*调试模式下，输出调试数据*/
#ifdef DEBUG
#define GPDebugLog(fmt, ...) NSLog(@"%s [Line %d] %s", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:(fmt), ##__VA_ARGS__] UTF8String]);
#else
#define GPDebugLog( fmt, ... )
#endif

#pragma mark - ------ 字体 -------

/*苹方简体常规*/
#define FontRegularWithSize(fontSize)           [UIFont fontWithName:@"PingFangSC-Regular" size:(fontSize*SizeScale)]
/*苹方简体中黑体*/
#define FontMediumWithSize(fontSize)           [UIFont fontWithName:@"PingFangSC-Medium" size:(fontSize*SizeScale)]
//不同设备的屏幕比例(当然倍数可以自己控制)
#define SizeScale (([[UIScreen mainScreen] bounds].size.width)/414.0)

#define LineBreakModeDefault (NSLineBreakByTruncatingTail)
//NSLineBreakByCharWrapping|
#pragma mark - ----- 颜色 -------

//rgb颜色转换（16进制->10进制）
#define GPHexColor(hex)     ([UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0])

/*主题色*/
#define kColorTheme rgb(0, 185, 143)//                
/*基调色*/
#define kColorBasic GPHexColor(0xF6F6F6)//浅灰

/*基调色*/
#define kColorSearchBackGround GPHexColor(0xF6F6F6)//浅灰

/*字体色*/
#define kColorFontMedium GPHexColor(0x333333)//粗体黑
#define kColorFontRegular GPHexColor(0x777777)//粗体黑
/*分隔线颜色*/
#define kColorSeparatorLine        rgb(250, 251, 251)
/*self.view背景颜色*/
#define kColorViewBackground       [UIColor whiteColor]
/*cell背景颜色*/
#define kColorCellBackground       [UIColor whiteColor]

#pragma mark - 常用宏语句

#define contentModeDefault      UIViewContentModeScaleToFill
#define defaultImage            CreateImageWithColor([UIColor whiteColor])


#define viewSetBackgroundColor(color) [self.view setBackgroundColor:color];
#define cellSetBackgroundColor(color) [self.contentView setBackgroundColor:color];
#define removeAllSubViews(view)     [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
/*收起键盘*/
#define endEditingkeywindow        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
/*应用活跃窗口*/
#define GPKeyWindow          ([UIApplication sharedApplication].keyWindow)

// 第一个参数是当下的控制器适配iOS11 以下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}


#pragma mark - ------ 设备系统相关 -------

/*系统版本*/
#define HPSystemVersion   ([[UIDevice currentDevice] systemVersion])
#define HPCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define HPAPPVersion      ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])


/*判断是否为iphone*/
#define GPIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/*判断是否为iphoneX*/
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON)
#define IS_IPHONE_X_XS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )812) < DBL_EPSILON)
#define IS_IPHONE_XR_XSMax (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )896) < DBL_EPSILON)

//异性全面屏
#define phoneIsFullScreen    (IS_IPHONE_X_XS || IS_IPHONE_XR_XSMax)


 
#pragma mark - ------页面设计相关-高度常量-------

/*屏幕宽度*/
#define GPScreenWidth       ([[UIScreen mainScreen] bounds].size.width)
/*屏幕高度*/
#define GPScreenHeight      ([[UIScreen mainScreen] bounds].size.height)
/*通用间距*/
#define GPSpacing  (16.0)

/*获取屏幕尺寸布局宽度比例系数*/
#define GPCommonLayoutScaleSizeWidthIndex ([[UIScreen mainScreen] bounds].size.width/1080.0f)
/*获取屏幕尺寸布局高度比例系数，*/
#define GPCommonLayoutScaleSizeHeightIndex ([[UIScreen mainScreen] bounds].size.height/667.0f)

/*状态栏高度*/
#define kStatusBarHeight ((CGFloat)(phoneIsFullScreen?(44.0):(20.0)))
/*导航栏高度*/
#define kNavBarHeight (44.0)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight ((CGFloat)(phoneIsFullScreen?(88.0):(64.0)))
/*TabBar高度*/
#define kTabBarHeight ((CGFloat)(phoneIsFullScreen?(49.0 + 34.0):(49.0)))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight ((CGFloat)(phoneIsFullScreen?(44.0):(0)))
/*底部安全区域远离高度*/
#define kBottomSafeHeight ((CGFloat)(phoneIsFullScreen?(34.0):(0)))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight ((CGFloat)(phoneIsFullScreen?(24.0):(0)))


#pragma mark - UserDefaults
//#define HPUserdefault                [NSUserDefaults standardUserDefaults]

#define save(value,key)             [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define read(key)                   [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define DefaultsSynchronize         [[NSUserDefaults standardUserDefaults] synchronize]


#pragma mark - weak/strong 类型转换

#define HPWeakSelf(type)    __weak typeof(type) weak##type = type; // weak
#define HPStrongSelf(type)  __strong typeof(type) type = weak##type; // strong 需搭配weak使用！！！！

#pragma mark - 获取图片资源
#define GetImage(imageName)     [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

#define URL(URLName)            [NSURL URLWithString:[NSString stringWithFormat:@"%@",URLName]]

#define BASEURLAppend(URLName)  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,URLName]]


#pragma mark - ----- 通知 -------
#define HPNOTIF             [NSNotificationCenter defaultCenter]
#define HPNOTIF_ADD(n, f)   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(f) name:n object:nil]
#define HPNOTIF_ADDWithObject(n, f, o)   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(f) name:n object:o]
#define HPNOTIF_POST(n, o)  [[NSNotificationCenter defaultCenter] postNotificationName:n object:o]
#define HPNOTIF_REMV()      [[NSNotificationCenter defaultCenter] removeObserver:self]

#pragma mark - ------ GCD -------
// GCD - 一次性执行
#define HP_DISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

// GCD - 在Main线程上运行
#define HP_DISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

// GCD - 开启异步线程
#define HP_DISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

#pragma mark - ------系统目录-------
// 获取temp
#define HPPathTemp      NSTemporaryDirectory()

// 获取沙盒 Document
#define HPPathDocument  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// 获取沙盒 Cache
#define HPPathCache     [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define HPPathHomeDir   NSHomeDirectory()


#pragma mark - 以tag读取View
#define mViewByTag(parentView, tag, Class)  (Class *)[parentView viewWithTag:tag]

#pragma mark - 读取Xib文件的类
#define mViewByNib(Class, owner) [[[NSBundle mainBundle] loadNibNamed:Class owner:owner options:nil] lastObject]

#pragma mark - id对象与NSData之间转换
#define mObjectToData(object)   [NSKeyedArchiver archivedDataWithRootObject:object]
#define mDataToObject(data)     [NSKeyedUnarchiver unarchiveObjectWithData:data]

#pragma mark - 度弧度转换
#define mDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define mRadianToDegrees(radian) (radian * 180.0) / (M_PI)

#endif /* Macro_h */
