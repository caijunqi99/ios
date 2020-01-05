//
//  AppDelegate.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/18.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "AppDelegate.h"

#include <sys/sysctl.h>

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
//微信开放平台sdk，支付
#import <WXApi.h>
//支付宝sdk
#import <AlipaySDK/AlipaySDK.h>
//支付宝商品信息
#import "APOrderInfo.h"
//rsa授权
#import "APRSASigner.h"
//tabbar
#import "IndexTabBarViewController.h"
#import "LoginViewController.h"
#import <IQKeyboardManager.h>
@interface AppDelegate ()<JPUSHRegisterDelegate,WXApiDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager; //主引擎类
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // 本地通知内容获取：
    NSDictionary *localNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        
    }
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    //设置主窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].idleTimerDisabled = TRUE;
    // 设置顶部状态栏为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self setTabbarApperence];
    [self setNavigationBarApperence];
    [self setApperence];
    [self setIQKeyboardManager];
    [self startBaiduMap];
    
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    
    
    //向微信注册
    [WXApi registerApp:kWXAppID universalLink:kWXUniversalLink];
    //    [self wxPay];
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:launchOptions appKey:kAppKeyJPUSH
                          channel:kChannelJPUSH
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        //GPDebugLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
    }];
    
    [self getVersion];
    
    UIViewController *rootVC;
    //GPDebugLog(@"token----------:%@",[HPUserDefault objectForKey:@"token"]);
//    if (IsStringEmptyOrNull([HPUserDefault objectForKey:@"token"]))
//    {
//        LoginViewController *vc = [[LoginViewController alloc]init];
//        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:vc];
//        rootVC = nav;
//    }
//    else
//    {
        
        //设置indextabbar为主窗口的根视图控制器
        IndexTabBarViewController *vc = [IndexTabBarViewController shareInstance];
        rootVC = vc;
//    }
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)getVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [HPNetManager POSTWithUrlString:HostVersionGetVersion isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:appVersion,@"version_num",@"2",@"type", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            if (![[NSString stringWithFormat:@"%@",response[@"result"][@"version_num"]] isEqualToString:appVersion] )
            {
                if ([[NSString stringWithFormat:@"%@",response[@"result"][@"mode"]] isEqualToString:@"1"])
                {
                    [HPAlertTools showAlertWith:getCurrentViewController() title:@"提示信息" message:@"有新版本" callbackBlock:^(NSInteger btnIndex) {
                        if (btnIndex == 1) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/apple-store/id1489580567?ct=web&mt=8"]];
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1489580567?mt=8"]];
                        }
                    } cancelButtonTitle:@"以后再说" destructiveButtonTitle:@"前往更新" otherButtonTitles:nil];
                }
                else if([[NSString stringWithFormat:@"%@",response[@"result"][@"mode"]] isEqualToString:@"2"])
                {
                    [HPAlertTools showAlertWith:getCurrentViewController() title:@"提示信息" message:@"有新版本" callbackBlock:^(NSInteger btnIndex) {
                        if (btnIndex == 1) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/apple-store/id1489580567?ct=web&mt=8"]];
                            [self exitApplication];
                        }else if (btnIndex == 0) {
                            [self exitApplication];
                        }
                    } cancelButtonTitle:@"以后再说" destructiveButtonTitle:@"前往更新" otherButtonTitles:nil];
                }
            }
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:getCurrentViewController() title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

- (void)exitApplication {
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0)
    {
        exit(0);
    }
}

#pragma mark-- 启动百度地图
- (void)startBaiduMap{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiduMapKey  generalDelegate:nil];
    //    BOOL ret = [_mapManager start:@"kBR0WvPmBQm61Oztynf5lmwoMS27NAU5"  generalDelegate:nil];//中盐域名
    if (!ret) {
        //GPDebugLog(@"BaiDuMap Manager Start Failed!");
    }else{
        //GPDebugLog(@"授权成功！");
    }
    [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK: BMK_COORDTYPE_BD09LL];
    
    
    
}

-(void)wxPay
{
    //向微信注册
    [WXApi registerApp:kWXAppID universalLink:kWXUniversalLink];
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"10000100";
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
    request.timeStamp= (UInt32)@"1397527777";
    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    [WXApi sendReq:request completion:^(BOOL success) {
        
    }];
}

#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
// 选中商品调用支付宝极简支付
//
- (void)doAPPay
{
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = kAliPayAppID;
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"缺少appId或者私钥,请检查参数设置"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:action];
        //        [self presentViewController:alert animated:YES completion:^{ }];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    //GPDebugLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc]initWithPrivateKey:((rsa2PrivateKey.length >1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"greengreatwall";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //GPDebugLog(@"reslut = %@",resultDic);
        }];
    }
}

#pragma mark -
#pragma mark   ==============产生随机订单号==============

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的 Extras 附加字段，key 是自己定义的
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    //GPDebugLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

-(void)createPlistByJsonFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.json" ofType:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
    NSString *newPath = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] bundlePath],@"/area.plist" ];
    //GPDebugLog(@"newPath:%@",newPath);
    [array writeToFile:newPath atomically:YES];
}

-(void)setApperence
{
    //GPDebugLog(@"手机型号:%@--屏幕宽:%f--屏幕高:%f",[AppDelegate deviceVersion],GPScreenWidth,GPScreenHeight);
    
    [[UITableView appearance]setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[UITableViewCell appearance]setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[UIScrollView appearance]setShowsVerticalScrollIndicator:NO];
    [[UIScrollView appearance]setShowsHorizontalScrollIndicator:NO];
    
    
    
    //    [UIView appearance].shouldAnimateBadge = YES;
    //    [UIView appearance].shouldHideBadgeAtZero = YES;
}

-(void)setIQKeyboardManager
{
    //默认为YES，关闭为NO
    [IQKeyboardManager sharedManager].enable = YES;
    //键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //隐藏键盘上面的toolBar,默认是开启的
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    //如果某一个文本框确实不需要键盘上面的toolBar
    //textField.inputAccessoryView = [[UIView alloc] init];
    
    /*
     //如果某个页面不想让键盘弹出
     - (void) viewWillAppear: (BOOL)animated {
     //关闭自动键盘功能
     [IQKeyboardManager sharedManager].enable = NO;
     }
     - (void) viewWillDisappear: (BOOL)animated {
     //开启自动键盘功能
     [IQKeyboardManager sharedManager].enable = YES;
     }
     //链接：https://www.jianshu.com/p/d3975b29c21d
     */
}

//https://www.jianshu.com/p/6a22f3d45234
+ (NSString*)deviceVersion
{
    
    size_t size;
    
    int nR = sysctlbyname("hw.machine",NULL, &size,NULL,0);
    
    char *machine = (char*)malloc(size);
    
    nR = sysctlbyname("hw.machine", machine, &size,NULL,0);
    
    NSString *deviceString = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    free(machine);
    
    
    
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    
    if ([deviceString isEqualToString:@"iPhone1,2"])return @"iPhone 3G";
    
    if ([deviceString isEqualToString:@"iPhone2,1"])return @"iPhone 3GS";
    
    if ([deviceString isEqualToString:@"iPhone3,1"])return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone3,2"])return @"Verizon iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone4,1"])return @"iPhone 4S";
    
    if ([deviceString isEqualToString:@"iPhone5,1"])return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,2"])return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,3"])return @"iPhone 5C";
    
    if ([deviceString isEqualToString:@"iPhone5,4"])return @"iPhone 5C";
    
    if ([deviceString isEqualToString:@"iPhone6,1"])return @"iPhone 5S";
    
    if ([deviceString isEqualToString:@"iPhone6,2"])return @"iPhone 5S";
    
    if ([deviceString isEqualToString:@"iPhone7,1"])return @"iPhone 6 Plus";
    
    if ([deviceString isEqualToString:@"iPhone7,2"])return @"iPhone 6";
    
    if ([deviceString isEqualToString:@"iPhone8,1"])return @"iPhone 6s";
    
    if ([deviceString isEqualToString:@"iPhone8,2"])return @"iPhone 6s Plus";
    
    if ([deviceString isEqualToString:@"iPhone8,4"])return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone9,1"])return @"iPhone 7";
    
    if ([deviceString isEqualToString:@"iPhone9,3"])return @"iPhone 7";
    
    if ([deviceString isEqualToString:@"iPhone9,4"])return @"iPhone 7 plus";
    
    if ([deviceString isEqualToString:@"iPhone9,2"])return @"iPhone 7 plus";
    
    if ([deviceString isEqualToString:@"iPhone10,1"])return @"iPhone 8";
    
    if ([deviceString isEqualToString:@"iPhone10,4"])return @"iPhone 8";
    
    if ([deviceString isEqualToString:@"iPhone10,5"])return @"iPhone 8 plus";
    
    if ([deviceString isEqualToString:@"iPhone10,2"])return @"iPhone 8 plus";
    
    if ([deviceString isEqualToString:@"iPhone10,3"])return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPhone10,6"])return @"iPhone X";
    
    //iPad
    
    if ([deviceString isEqualToString:@"iPad1,1"])return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad2,1"])return @"iPad 2 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,2"])return @"iPad 2 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,3"])return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad2,4"])return @"iPad 2 (32nm)";
    
    if ([deviceString isEqualToString:@"iPad2,5"])return @"iPad mini (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,6"])return @"iPad mini (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,7"])return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])return @"iPad 3(WiFi)";
    
    if ([deviceString isEqualToString:@"iPad3,2"])return @"iPad 3(CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,3"])return @"iPad 3(4G)";
    
    if ([deviceString isEqualToString:@"iPad3,4"])return @"iPad 4 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad3,5"])return @"iPad 4 (4G)";
    
    if ([deviceString isEqualToString:@"iPad3,6"])return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,2"])return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,3"])return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad5,3"])return @"iPad Air 2";
    
    if ([deviceString isEqualToString:@"iPad5,4"])return @"iPad Air 2";
    
    if ([deviceString isEqualToString:@"i386"])return @"Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])return @"Simulator";
    
    
    
    if ([deviceString isEqualToString:@"iPad4,4"]||[deviceString isEqualToString:@"iPad4,5"]||[deviceString isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]||[deviceString isEqualToString:@"iPad4,8"]||[deviceString isEqualToString:@"iPad4,9"])return @"iPad mini 3";
    
    if ([deviceString isEqualToString:@"iPad5,1"]||[deviceString isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
    
    if ([deviceString isEqualToString:@"iPad6,7"])return @"iPad Pro (12.9-inch)";
    
    if ([deviceString isEqualToString:@"iPad6,8"])return @"iPad Pro (12.9-inch)";
    
    if ([deviceString isEqualToString:@"iPad6,3"])return @"iPad Pro (9.7-inch)";
    
    if ([deviceString isEqualToString:@"iPad6,4"])return @"iPad Pro (9.7-inch)";
    
    if ([deviceString isEqualToString:@"iPad6,11"])return @"iPad(5G)";
    
    if ([deviceString isEqualToString:@"iPad6,12"])return @"iPad(5G)";
    
    if ([deviceString isEqualToString:@"iPad7,2"])return @"iPad Pro (12.9-inch, 2g)";
    
    if ([deviceString isEqualToString:@"iPad7,1"])return @"iPad Pro(12.9-inch, 2g)";
    
    if ([deviceString isEqualToString:@"iPad7,3"])return @"iPad Pro (10.5-inch)";
    
    if ([deviceString isEqualToString:@"iPad7,4"])return @"iPad Pro (10.5-inch)";
    
    return @"";
}




-(void)setNavigationBarApperence
{
    //设置navigationbar通用样式
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontMediumWithSize(19),NSFontAttributeName,
                                                          [UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance]setBackgroundImage:CreateImageWithColor([UIColor whiteColor]) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
    
    //设置导航条默认返回按钮的样式
    UIImage *tmpImage = GetImage(@"黑色左箭头");
    CGSize newSize = CGSizeMake(14, 24);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    [tmpImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
    //translucent：这是iOS7中给UITabBar、UINavigationBar新增的属性，如果为YES，那么显示的是半透明的效果，能够模糊看到被bar遮盖的东西，如果设置为NO，则没有模糊透明的效果。
    //https://www.jianshu.com/p/a75632bab095
    
    //setBarTintColor 设置颜色在导航中会变色，怎么让他不变颜色，一句代码就可以改变，加上上面[[UINavigationBar appearance] setTranslucent:NO]代码即可;
    //[[UINavigationBar appearance] setTranslucent:NO]这句话是控制导航栏颜色是否透明。
    //https://blog.csdn.net/defuliu66/article/details/51330019
    //    iOS7之前，setTintColor是可以修改背景色的，iOS7之后修改背景色只能用setBarTintColor。
    //    在这里只看看iOS7后navigationBar 的效果：
    //    [self.navigationController.navigationBar setTintColor: NE_BARCOLOR_WHITE];
    //    [self.navigationController.navigationBar setBarTintColor: NE_BARCOLOR_ORANGE];
    //    可以看出我的宏定义一个是白色，一个是橙色，设置tintColor后文字和图标变成白色，而背景变成橙色。
    //    [self.navigationController.navigationBar setTintColor:NE_BACKCOLOR_RED];
    //    [self.navigationController.navigationBar setBarTintColor:NE_BACKCOLOR_YELLOW];
    //    图标和文字变红色，背景色变为黄色。
    //https://blog.csdn.net/youshaoduo/article/details/54669796
    
    //    [UINavigationBar appearance].translucent = NO;
    
}

-(void)setTabbarApperence
{
    //设置tabbar通用样式
    [[UITabBar appearance] setTintColor:kColorTheme];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    /**
     初始化类：
     1.appearance：只要一个类遵守UIAppearance协议，就能获取全局的外观，如：UIView。
     2.获取项目中所有的tabBarItem外观标识（推荐，不会改变别人的）：
     UITabBarItem *item = [UITabBarItem appearance];
     3.获取当前类下面的所有tabBarItem外观标识：
     UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
     */
    // 设置TabBarItem选中文字颜色
    //    UITabBarItem *bar = [UITabBarItem appearance];
    //    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor hex:@"1296db"], NSFontAttributeName: [UIFont hp_systemFontOfSize:14]} forState:UIControlStateSelected];
    //    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor hex:@"707070"], NSFontAttributeName:[UIFont hp_systemFontOfSize:14]} forState:UIControlStateNormal];
    //    [UITabBar appearance].translucent = NO;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            GPDebugLog(@"result = %@",resultDic);
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                HPNOTIF_POST(@"paysuccess", nil);
            }else if ([resultDic[@"resultStatus"] integerValue] == 6001) {
                HPNOTIF_POST(@"paycancel", nil);
            }else{
                HPNOTIF_POST(@"payfail", resultDic[@"resultStatus"]);
            }
        }];
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

-(void) onReq:(BaseReq*)reqonReq
{
    
}

-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode)
        {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                GPDebugLog(@"支付成功");
                HPNOTIF_POST(@"paysuccess", nil);
            }
                break;
            case WXErrCodeUserCancel:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                //交易取消
                HPNOTIF_POST(@"paycancel", nil);
            }
                break;
            default:
            {
                GPDebugLog(@"支付失败， retcode=%d",resp.errCode);
                HPNOTIF_POST(@"payfail", nil);
            }
                break;
        }
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

#pragma mark - 生命周期
- (void)applicationWillEnterForeground:(UIApplication *)application{
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    
}
- (void)applicationWillResignActive:(UIApplication *)application{
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    
}
- (void)applicationWillTerminate:(UIApplication *)application{
    
}




#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer  API_AVAILABLE(ios(10.0)){
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"LeJuYouJia"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    //GPDebugLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //GPDebugLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

void uncaughtExceptionHandler(NSException *exception) {
    //GPDebugLog(@"CRASH: %@", exception);
    //GPDebugLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

@end
