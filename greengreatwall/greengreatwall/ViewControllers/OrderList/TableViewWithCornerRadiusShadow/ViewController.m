//
//  ViewController.m
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import "ViewController.h"
#import "GroupShadowTableView.h"
 
@interface ViewController () <GroupShadowTableViewDelegate,GroupShadowTableViewDataSource>
@property (strong, nonatomic)  GroupShadowTableView *tableView;
 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[GroupShadowTableView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight) style:UITableViewStyleGrouped];
    self.tableView.groupShadowDelegate = self;
    self.tableView.groupShadowDataSource = self;
    self.tableView.showSeparator = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    
}
 
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
//MARK: - GroupShadowTableViewDataSource
- (NSInteger)numberOfSectionsInGroupShadowTableView:(GroupShadowTableView *)tableView {
    return 5;
}
- (NSInteger)groupShadowTableView:(GroupShadowTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
 
- (UITableViewCell *)groupShadowTableView:(GroupShadowTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"section -> %@ ; row -> %@",@(indexPath.section) ,@(indexPath.row)];
    return cell;
     
}
 
 
//MARK: - GroupShadowTableViewDelegate
- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
 
- (void)groupShadowTableView:(GroupShadowTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
 
@end
