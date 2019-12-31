//
//  BaseViewController.h
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  回调block
 */
typedef void (^CallBackBlock)(NSInteger btnIndex);

@interface BaseViewController : UIViewController

-(void)getLocationAuthorizationStatusWithSuccess:(CallBackBlock)block;
// 设置导航条标题
- (void)settingNavTitle:(NSString *)title;
- (void)settingNavTitle:(NSString *)title WithNavTitleColor:(UIColor*)color;

- (void)setBackButtonWithTarget:(id)target
                         action:(SEL)action;
- (void)setBackButtonWhiteWithTarget:(id)target
                              action:(SEL)action;
// 设置导航条右侧按钮
- (void)setRightNavButtonWithImage:(UIImage *)image
                             Title:(NSString *)title
                             Frame:(CGRect)frame
                            Target:(id)target
                            action:(SEL)action;


// 设置导航栏左侧按钮
- (void)setLeftNavButtonImage:(UIImage *)image
                        Title:(NSString *)title
                        Frame:(CGRect)frame
                       Target:(id)target
                       action:(SEL)action;

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
                  secondAction:(SEL)secondAction;

// 设置右侧第二个按钮
- (UIBarButtonItem *)setSecondNavButtonImage:(UIImage *)image
                                       title:(NSString *)title
                                       frame:(CGRect)frame
                                      Target:(id)target
                                      action:(SEL)action;


- (NSString *)getNoBlankReturnMarkString:(NSString *)jsonStr;

-(void)pushVCwithTitle:(NSString*)title;

-(void)popToController:(NSString *)stringClassName;

@end

NS_ASSUME_NONNULL_END
