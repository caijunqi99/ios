//
//  GPWKWebViewWithHeaderAndFooter.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/4.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPWKWebViewWithHeaderAndFooter : WKWebView

//wkWebview网页
@property(nonatomic,strong)WKWebView * wkWebview;

//头部视图
@property(nonatomic,strong)UIView * headerView;
//尾部视图
@property(nonatomic,strong)UIView * footView;

//HTML
@property(nonatomic,strong)NSString * htmlString;

//移除KVO
@property(nonatomic,strong)NSString * remoDeallocKvo;


//与JS有交互的WKWebViewConfiguration不会走Init方法需要手动调用创建UI
@property(nonatomic,strong)NSString * actionJS;


@end

NS_ASSUME_NONNULL_END
