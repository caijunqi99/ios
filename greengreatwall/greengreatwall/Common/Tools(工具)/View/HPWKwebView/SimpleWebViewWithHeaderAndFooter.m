//
//  SimpleWebViewWithHeaderAndFooter.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/5.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "SimpleWebViewWithHeaderAndFooter.h"

@interface SimpleWebViewWithHeaderAndFooter()<WKNavigationDelegate>
{
    UIView          *_viewHeader;
    UIView          *_viewFooter;
    NSString        *_htmlString;
}
@end

@implementation SimpleWebViewWithHeaderAndFooter

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //打开垂直滚动条
        self.scrollView.showsVerticalScrollIndicator=YES;
        //关闭水平滚动条
        self.scrollView.showsHorizontalScrollIndicator=NO;
        //设置滚动视图的背景颜色
        self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.navigationDelegate = self;
        //两条属性关闭黑影
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
    
}

-(void)setHeaderView:(UIView*)headerView andFooterView:(UIView*)footerView withHtmlString:(NSString *)htmlString andTitle:(NSString *)titleString
{
    
    _htmlString = htmlString;
    _viewHeader = headerView;
    _viewHeader.userInteractionEnabled = YES;
    _viewFooter = footerView;
    _viewFooter.userInteractionEnabled = YES;
    //设置样式
    NSString *string = [NSString stringWithFormat:@"<html><head><title>%@</title></head><body><p style='padding-top:%fpx;'></p><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx !important;height:auto}body{max-width:%fpx !important;}</style>%@<p style='padding-bottom:%fpx;'></p></body></html>",titleString,headerView.frame.size.height, GPScreenWidth - 20,GPScreenWidth - 20, htmlString,footerView.frame.size.height];
    
    [self loadHTMLString:string baseURL:nil];
}

//页面加载完后获取高度，设置脚,注意，控制器里不能重写代理方法，否则这里会不执行
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
    // 不执行前段界面弹出列表的JS代码，关闭系统的长按保存图片
    [self evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    
    // WKWebView禁止放大缩小(捏合手势)
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    
    
    //获取网页高度    document.documentElement.clientHeight   document.body.offsetHeight;
//    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
    [webView evaluateJavaScript:@"document.documentElement.clientHeight;" completionHandler:^(id Result, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat documentHeight = [Result doubleValue];
            
            
            [self.scrollView addSubview:self->_viewHeader];
            [self.scrollView bringSubviewToFront:self->_viewHeader];
            
            [self->_viewFooter setBottom:documentHeight];
            [self.scrollView addSubview:self->_viewFooter];
            [self.scrollView bringSubviewToFront:self->_viewFooter];
        });
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
