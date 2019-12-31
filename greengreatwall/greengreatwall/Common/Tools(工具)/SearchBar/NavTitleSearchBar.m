//
//  NavTitleSearchBar.m
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import "NavTitleSearchBar.h"
@interface NavTitleSearchBar()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchTF;
@end

@implementation NavTitleSearchBar
@synthesize searchDelegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
//    self.placeholder = @"搜索服务、商铺";
    self.layer.cornerRadius = CGRectGetHeight(frame)/2.0;
    self.layer.masksToBounds = YES;

    //设置背景图是为了去掉上下黑线
    self.backgroundImage = CreateImageWithColor(rgb(244, 244, 244));
    // 设置SearchBar的主题颜色
    self.barTintColor = rgb(244, 244, 244);
    //设置背景色
    self.backgroundColor = [UIColor whiteColor];
    //修改cancel
    self.showsCancelButton = NO;
    self.barStyle = UIBarStyleDefault;
    self.keyboardType = UIKeyboardTypeNumberPad;
    //self.self.searchBarStyle = UISearchBarStyleMinimal;//没有背影，透明样式
    //
    self.showsSearchResultsButton = NO;
    //设置搜索Icon
    [self setImage:GetImage(@"首页搜索icon＊") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

    //一下代码为修改placeholder字体的颜色和大小
    UITextField *searchField;
    if (@available(iOS 13.0, *)) {
        searchField = self.searchTextField;
    } else {
        // Fallback on earlier versions
        searchField = [self valueForKey:@"_searchField"];
    }
    searchField.delegate = self;
    //设置圆角和边框颜色
    if(searchField) {
        [searchField setBackgroundColor:[UIColor clearColor]];
        // 根据@"_placeholderLabel" 找到placeholder的字体颜色
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(searchField, ivar);
        if (placeholderLabel) {
//            placeholderLabel.textColor = [UIColor whiteColor];
            placeholderLabel.font = FontRegularWithSize(12);
        }else{
            //GPDebugLog(@"placeholderLabel is nil");
        }
        

        // 输入文本颜色
//        searchField.textColor= [UIColor whiteColor];
        searchField.font= FontRegularWithSize(12);

        //只有编辑时出现出现那个叉叉
        searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

/* 获取对象的所有属性 */
-(NSArray *)getAllPropertiesWithClassName:(id)className
{
    u_int count;
    u_int icount;
    // 传递count的地址过去 &count
    objc_property_t *properties  =class_copyPropertyList([className class], &count);
    //arrayWithCapacity的效率稍微高那么一丢丢
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    Ivar *ivars = class_copyIvarList([className class], &icount);
    //arrayWithCapacity的效率稍微高那么一丢丢
    NSMutableArray *ivarsArray = [NSMutableArray arrayWithCapacity:icount];
    for (int i = 0; i < count ; i++)
    {
        //此刻得到的propertyName为c语言的字符串
        const char* propertyName =property_getName(properties[i]);
        //此步骤把c语言的字符串转换为OC的NSString
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    for (int i = 0; i < icount ; i++)
    {
        //此刻得到的propertyName为c语言的字符串
        const char* ivarName =ivar_getName(ivars[i]);
        //此步骤把c语言的字符串转换为OC的NSString
        [ivarsArray addObject: [NSString stringWithUTF8String: ivarName]];
    }
    //class_copyPropertyList底层为C语言，所以我们一定要记得释放properties
    // You must free the array with free().
    free(properties);
    free(ivars);
    //GPDebugLog(@"propertiesArray:%@",propertiesArray);
    //GPDebugLog(@"ivarsArray:%@",ivarsArray);
    return propertiesArray;
}
#pragma mark - 代理协议

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.searchDelegate respondsToSelector:@selector(XDSearchBarViewShouldBeginEditing:)]) {
        return [self.searchDelegate XDSearchBarViewShouldBeginEditing:textField];
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.searchDelegate respondsToSelector:@selector(XDSearchBarViewShouldReturn:)]) {
        [self.searchDelegate XDSearchBarViewShouldReturn:textField.text];
    }
    return YES;
}


@end
