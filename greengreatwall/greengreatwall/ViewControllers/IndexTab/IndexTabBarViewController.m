//
//  IndexTabBarViewController.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/10/24.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "IndexTabBarViewController.h"
#import "IndexViewController.h"
#import "StoreListViewController.h"
#import "ClassificationViewController.h"

#import "ShoppingCartViewController.h"

#import "PersonnalViewController.h"

#import "SearchResultListViewController.h"
@interface IndexTabBarViewController ()
@end

@implementation IndexTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createInterface];
}

-(instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (instancetype)shareInstance
{
    static IndexTabBarViewController* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

-(void)setselectFirst
{
    [self setSelectedIndex:0];
}

- (void)createInterface{
    
    IndexViewController *indexVC = [[IndexViewController alloc] init];
    StoreListViewController *storeVC = [[StoreListViewController alloc]init];
    ClassificationViewController *classVC = [[ClassificationViewController alloc] init];
    ShoppingCartViewController *ShopCartVC = [[ShoppingCartViewController alloc]init];
    PersonnalViewController *personalVC = [[PersonnalViewController alloc] init];
    
    [self setVC:indexVC tabBarItemTitle:@"首页" image:@"首页" selectedImage:@"首页选中"];
    [self setVC:storeVC tabBarItemTitle:@"店铺" image:@"店铺" selectedImage:@"店铺选中"];
    [self setVC:classVC tabBarItemTitle:@"分类" image:@"分类" selectedImage:@"分类选中"];
    [self setVC:ShopCartVC tabBarItemTitle:@"购物车" image:@"购物车" selectedImage:@"购物车选中"];
    [self setVC:personalVC tabBarItemTitle:@"个人" image:@"我" selectedImage:@"我选中"];
    
}

- (void)setVC:(UIViewController *)vc tabBarItemTitle:(NSString *)title image:(NSString *)img selectedImage:(NSString *)selectedImg {
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage originalImageNamed:img] selectedImage:[UIImage originalImageNamed:selectedImg]];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    //GPDebugLog(@"%ld",(long)item.tag);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
