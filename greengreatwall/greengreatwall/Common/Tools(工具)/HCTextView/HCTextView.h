//
//  HCTextView.h
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef RGB
#define RGB(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#endif

//可以通过屏幕等比例来设置不同字体适应于不同屏幕手机字体大小
#define TEXTFONTSIZE(X) [UIFont systemFontOfSize:X *([UIScreen mainScreen].bounds.size.width / 320.0)]

@interface HCTextView : UITextView <UITextViewDelegate>

/**
 * 提示字label
 */
@property (nonatomic, strong) UILabel * placeHolderLabel;

/**
 * 提示字
 */
@property (nonatomic, strong) NSString * placeholder;

/**
 * 提示字颜色
 */
@property (nonatomic, strong) UIColor * placeholderColor;

/**
 * 提示字字体大小
 */
@property (nonatomic, strong) UIFont * placeholderFont;


/**
 * textView是否拥有边框
 */
@property (nonatomic, assign) BOOL haveLayer;

/**
 * 设置textView的边框属性
 *
 * frameRadius textView的圆角值
 * borderWidth textView的边框宽度
 * borderColor textView的边框颜色
 *
 */

- (void) setTextViewLayerCornerRadius:(float) radius borderWidth: (float)viewBorderWidth borderColor: (UIColor *) viewBorderColor;

/**
 *  监测当输入时改变提示字的状态
 *
 *  @param notification 监测
 */
- (void) textChanged:(NSNotification * )notification;




@end
