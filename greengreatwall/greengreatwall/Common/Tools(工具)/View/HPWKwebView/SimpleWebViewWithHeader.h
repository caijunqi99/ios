//
//  SimpleWebViewWithHeader.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/5.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleWebViewWithHeader : WKWebView

-(void)setHeaderView:(UIView*)headerView andFooterView:(UIView*)footerView withHtmlString:(NSString *)htmlString andTitle:(NSString *)titleString;

@end

NS_ASSUME_NONNULL_END
