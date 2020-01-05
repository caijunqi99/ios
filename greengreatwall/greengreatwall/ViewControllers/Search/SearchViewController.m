//
//  SearchViewController.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/5.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "SearchViewController.h"

#import "XDAutoresizeLabelFlow.h"
#import "XDAutoresizeLabelFlowHeader.h"
#import "XDDataBase.h"

#import "SearchResultListViewController.h"

@interface SearchViewController ()<UISearchBarDelegate,XDSearchBarViewDelegate>
@property (nonatomic, strong) NavTitleSearchBar *searchBar;
@property (nonatomic, strong) XDAutoresizeLabelFlow *recordView;
@property (nonatomic, strong) NSMutableArray *arraySearchHistory;
@property (nonatomic, strong) NSMutableArray *arraySearchHot;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arraySearchHistory = @[@[],@[]].mutableCopy;
    [[XDDataBase sharedXDDataBase] openSearchRecordDataBase];
    [self createInterface];
    
    [self netRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.searchBar) {
        // 清除搜索框文字
        //        self.searchBar.sea.text = @"";
    }
    // 查询数据库数据 刷新搜索记录
    HPWeakSelf(self)
    [[XDDataBase sharedXDDataBase] querySearchRecord:^(NSArray *resultArray) {
        //        //GPDebugLog(@"%@",resultArray);
        [weakself.arraySearchHistory replaceObjectAtIndex:0 withObject:resultArray];
        [weakself.recordView reloadAllWithTitles:weakself.arraySearchHistory];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - 内部逻辑实现
// 执行搜索
- (void)performSearchAction:(NSString *)keyword {
    if (keyword.length) {
        [[XDDataBase sharedXDDataBase] addSearchRecordText:keyword];
        
        [self.recordView reloadAllWithTitles:self.arraySearchHistory];
        
        SearchResultListViewController *vc = [[SearchResultListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.keyword = keyword;//   手机
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -XDSearchBarViewDelegate

- (void)XDSearchBarViewShouldReturn:(NSString *)keyword {
    [self performSearchAction:keyword];
}

-(BOOL)XDSearchBarViewShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

#pragma mark - 数据请求 / 数据处理
#pragma mark - 视图布局
- (void)createInterface {
    // 搜索框
    [self setupSearchBar];
    [self setupTopRightButton];
    
    viewSetBackgroundColor(kColorBasic);
    
    // 热门搜索数据
    _arraySearchHot = [NSMutableArray arrayWithCapacity:0];
    [self.arraySearchHistory replaceObjectAtIndex:1 withObject:_arraySearchHot];
    
    // collectionview
    HPWeakSelf(self)
    self.recordView = [[XDAutoresizeLabelFlow alloc] initWithFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight- kTabBarHeight) titles:self.arraySearchHistory sectionTitles:@[@"历史搜索",@"大家都在搜"] selectedHandler:^(NSIndexPath *indexPath, NSString *title) {
        [weakself performSearchAction:title];
    }];
    
//    [self.recordView reloadAllWithTitles:@[]];
    
    self.recordView.deleteHandler = ^(NSIndexPath *indexPath) {
        //GPDebugLog(@"删除搜索记录");
        [[XDDataBase sharedXDDataBase] deleteAllSearchRecord];
        [(NSMutableArray*)(weakself.arraySearchHistory[0]) removeAllObjects];
        [weakself.recordView reloadAllWithTitles:weakself.arraySearchHistory];
    };
    
    [self.view addSubview:self.recordView];
    
}

#pragma mark - topLeftButton
- (void)setupSearchBar {
    
    //添加搜索框
    UIView *wrapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth -  44 - 40, 32)];
    
    _searchBar = [[NavTitleSearchBar alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth -  44 - 40, 32)];
    _searchBar.searchDelegate = self;
    _searchBar.placeholder = @"搜索商品";
    _searchBar.backgroundColor = rgb(244, 244, 244);
    [wrapView addSubview:_searchBar];
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:wrapView];
    self.navigationItem.leftBarButtonItems = @[item];
}

- (void)topLeftButtonDidClicked {
    
}

#pragma mark - topRightButton
- (void)setupTopRightButton {
    UIButton *topRightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [topRightButton setTitle:@"取消" forState: UIControlStateNormal];
    [topRightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [topRightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    topRightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    topRightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    topRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    topRightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    topRightButton.frame = CGRectMake(0, 0, 40, 25);
    [topRightButton addTarget:self action:@selector(topRightButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    topRightButton.backgroundColor = [UIColor clearColor];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:topRightButton];
    
    
    self.navigationItem.rightBarButtonItems = @[item];
}

- (void)topRightButtonDidClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)netRequest
{
    HPWeakSelf(self)
    [HPNetManager POSTWithUrlString:Hostindexsearch_key_list isNeedCache:NO parameters:nil successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            [self->_arraySearchHot addObjectsFromArray:[NSArray arrayWithArray:response[@"result"][@"list"]]];
            [weakself.arraySearchHistory replaceObjectAtIndex:1 withObject:self->_arraySearchHot];
            [self.recordView reloadAllWithTitles:weakself.arraySearchHistory];
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

@end
