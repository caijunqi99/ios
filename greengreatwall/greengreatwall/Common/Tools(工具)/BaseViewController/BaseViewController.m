//
//  BaseViewController.m
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UINavigationBarDelegate>
@property (nonatomic,strong)CLLocationManager *manager;
@end



@implementation BaseViewController

//- (void)loadView
//{
////    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
////    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
////    [self.view setBackgroundColor:[UIColor whiteColor]];
//}

//-(instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
//    }
//    return self;
//}

//是否由系统自动调整滚动视图的内边距，默认为YES，意味着系统将会根据导航条和TabBar的情况自动增加上下内边距以防止滚动视图的内容被Bar遮挡  https://www.jianshu.com/p/a75632bab095
-(BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}
//edgesForExtendedLayout = UIRectEdgeNone 设置后，控制器的view的frame的坐标Y增加64px紧挨着navigationBar下方，底部同理，该属性支持iOS7及以后的版本。
-(UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 屏幕旋转方向

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)tap
{
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    endEditingkeywindow;
    //    for (UITextField *tf in self.view.subviews)
    //    {
    //        [tf resignFirstResponder];
    //    }
    //    for (UITextView *tv in self.view.subviews)
    //    {
    //        [tv resignFirstResponder];
    //    }
}

-(UIModalPresentationStyle)modalPresentationStyle
{
    return UIModalPresentationFullScreen;
}

- (void)settingNavTitle:(NSString *)title
{
    UIColor *NavColor = [UIColor blackColor];
    [self settingNavTitle:title WithNavTitleColor:NavColor];
}

- (void)setBackButtonWithTarget:(id)target
                        action:(SEL)action
{
    UIImage *tmpImage = GetImage(@"黑色左箭头");
    CGSize newSize = CGSizeMake(14, 24);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    [tmpImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setLeftNavButtonImage:backButtonImage Title:@"" Frame:CGRectMake(10, 10, 14, 24) Target:target action:action];
}

- (void)setBackButtonWhiteWithTarget:(id)target
                              action:(SEL)action
{
    UIImage *tmpImage = GetImage(@"白色左箭头");
    CGSize newSize = CGSizeMake(14, 24);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    [tmpImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setLeftNavButtonImage:backButtonImage Title:@"" Frame:CGRectMake(10, 10, 14, 24) Target:target action:action];
}



- (void)settingNavTitle:(NSString *)title WithNavTitleColor:(UIColor*)color
{
    CGRect titleLabelRect = CGRectMake(90, 7, self.view.frame.size.width-180, 30);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelRect];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = color;
    titleLabel.font = FontMediumWithSize(18);
    titleLabel.numberOfLines = 1;
    titleLabel.text = title;
    titleLabel.clipsToBounds = YES;
    self.navigationItem.titleView = titleLabel;
    
    NSShadow *NavShadow = [[NSShadow alloc]init];
    NavShadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
    NavShadow.shadowOffset = CGSizeMake(0, 0);
    UIFont *NavFont = FontMediumWithSize(18);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     
                                                                     NavShadow, NSShadowAttributeName,
                                                                     NavFont, NSFontAttributeName,
                                                                     nil]];//color, NSBackgroundColorAttributeName,
}

- (void)setRightNavButtonWithImage:(UIImage *)image
                             Title:(NSString *)title
                             Frame:(CGRect)frame
                            Target:(id)target
                            action:(SEL)action
{
    if (target == nil && action == nil)
        return;
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    
//    [navButton.widthAnchor constraintEqualToConstant:frame.size.width].active = YES;
//    [navButton.heightAnchor constraintEqualToConstant:frame.size.height].active = YES;
    [navButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    
    [navButton setClipsToBounds:YES];
    [navButton.layer setMasksToBounds:YES];
    
    [navButton.titleLabel setClipsToBounds:YES];
    [navButton.titleLabel.layer setMasksToBounds:YES];
    [navButton.titleLabel setFont:FontMediumWithSize(18)];
    [navButton.titleLabel setTextColor:[UIColor blackColor]];
    [navButton setTitle:title forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [navButton setImage:image forState:UIControlStateNormal];
    navButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    { // iOS 7以上
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                                        target:nil
//                                                                                        action:nil];
//        negativeSpacer.width = -6;
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: navItem, nil] animated:NO];//negativeSpacer,
    }
    else
    {
        self.navigationItem.rightBarButtonItem = navItem;
    }
}

// 设置导航栏左侧按钮
- (void)setLeftNavButtonImage:(UIImage *)image
                        Title:(NSString *)title
                        Frame:(CGRect)frame
                       Target:(id)target
                       action:(SEL)action
{
    if (target == nil && action == nil)
        return;
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    
//    [navButton.widthAnchor constraintEqualToConstant:frame.size.width].active = YES;
//    [navButton.heightAnchor constraintEqualToConstant:frame.size.height].active = YES;
    [navButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    
    [navButton setClipsToBounds:YES];
    [navButton.layer setMasksToBounds:YES];
    
    [navButton.titleLabel setClipsToBounds:YES];
    [navButton.titleLabel.layer setMasksToBounds:YES];
    [navButton.titleLabel setFont:FontMediumWithSize(18)];
    [navButton.titleLabel setTextColor:[UIColor blackColor]];
    [navButton setTitle:title forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [navButton setImage:image forState:UIControlStateNormal];
    navButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    { // iOS 7以上
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil
                                                                                        action:nil];
        negativeSpacer.width = -6;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, navItem, nil] animated:NO];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = navItem;
    }
}

// 设置导航栏右侧按钮
- (void)setRightNavButtonImage:(UIImage *)image
                         title:(NSString*)title
                         frame:(CGRect)frame
                        Target:(id)target
                        action:(SEL)action
                   secondImage:(UIImage *)secondImage
                   secondTitle:(NSString*)secondTitle
                   secondFrame:(CGRect)secondFrame
                  secondTarget:(id)secondtarget
                  secondAction:(SEL)secondAction
{
    if (target == nil && action == nil)
    {
        return;
    }
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    [navButton setImage:image forState:UIControlStateNormal];
    [navButton.titleLabel setFont:FontMediumWithSize(18)];
    [navButton setTitle:title forState:UIControlStateNormal];
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    // 右侧第二个按钮
    UIBarButtonItem *secondNavItem = [self setSecondNavButtonImage:secondImage
                                                             title:secondTitle
                                                             frame:secondFrame
                                                            Target:secondtarget
                                                            action:secondAction];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    { // iOS 7以上
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil
                                                                                        action:nil];
        negativeSpacer.width = -6;
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, navItem, secondNavItem, nil] animated:NO];
    }
    else
    {
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:navItem, secondNavItem, nil] animated:NO];
    }
}

// 设置右侧第二个按钮
- (UIBarButtonItem *)setSecondNavButtonImage:(UIImage *)image
                                       title:(NSString *)title
                                       frame:(CGRect)frame
                                      Target:(id)target
                                      action:(SEL)action
{
    if (target == nil && action == nil)
        return nil;
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [navButton setFrame:frame];
    [navButton setImage:image forState:UIControlStateNormal];
    [navButton.titleLabel setFont:FontMediumWithSize(18)];
    [navButton setTitle:title forState:UIControlStateNormal];
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    return navItem;
}

- (NSString *)getNoBlankReturnMarkString:(NSString *)jsonStr{
    NSMutableString * mutableStr = [[NSMutableString alloc] initWithString:jsonStr];
    [mutableStr replaceOccurrencesOfString:@"%0A" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutableStr.length)];
    //    [mutableStr replaceOccurrencesOfString:@"%20" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutableStr.length)];
    return [mutableStr copy];
}

-(void)getLocationAuthorizationStatusWithSuccess:(CallBackBlock)block
{
    //确定用户的位置服务是否启用,位置服务在设置中是否被禁用
    BOOL enable      =[CLLocationManager locationServicesEnabled];
    NSInteger status =[CLLocationManager authorizationStatus];
    if(  !enable || status< 2){
        //尚未授权位置权限
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
        {
            //系统位置授权弹窗
            self.manager =[[CLLocationManager alloc]init];
            [self.manager requestAlwaysAuthorization];
            [self.manager requestWhenInUseAuthorization];
        }
    }else{
        if (status == kCLAuthorizationStatusDenied) {
            //拒绝使用位置
            [HPAlertTools showAlertWith:self title:nil message:@"地点功能需要开启位置授权" callbackBlock:^(NSInteger btnIndex) {
                //GPDebugLog(@"%d",btnIndex);
                if (btnIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
                
            } cancelButtonTitle:@"暂不设置" destructiveButtonTitle:@"现在去设置" otherButtonTitles:nil];
            
        }else{
            block(0);
            //允许使用位置
//            MapLocationVC *mapVC =[[MapLocationVC alloc]init];
//            mapVC.fromComment =YES;
//            mapVC.delegate =self;
//            if ([self.delegate respondsToSelector:@selector(presentVC:)]) {
//                [self.delegate presentVC:mapVC];
//            }
        }
    }
}

-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    UIImage *tmpImage = GetImage(@"黑色左箭头");
    CGSize newSize = CGSizeMake(14, 24);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    [tmpImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect frame = CGRectMake(10, 10, 14, 24);
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    
    [navButton.widthAnchor constraintEqualToConstant:frame.size.width].active = YES;
    [navButton.heightAnchor constraintEqualToConstant:frame.size.height].active = YES;
    
    [navButton setClipsToBounds:YES];
    [navButton.layer setMasksToBounds:YES];
    [navButton.titleLabel setClipsToBounds:YES];
    [navButton.titleLabel.layer setMasksToBounds:YES];
    
    [navButton.titleLabel setFont:FontMediumWithSize(18)];
    [navButton setImage:backButtonImage forState:UIControlStateNormal];
    navButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [navButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    item.backBarButtonItem = navItem;
    
    return YES;
}

-(void)pushVCwithTitle:(NSString*)title
{
    PushViewController *pushVC = [[PushViewController alloc]init];
    pushVC.hidesBottomBarWhenPushed = YES;
    pushVC.titleNavi = title;
    [self.navigationController pushViewController:pushVC animated:YES];
}

-(void)popToController:(NSString *)stringClassName{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        Class className = NSClassFromString(stringClassName);
        if ([controller isKindOfClass:[className class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
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
