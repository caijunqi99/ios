//
//  InputPayPassword.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/26.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class InputPayPassword;
@protocol InputPayPasswordViewDelegate <NSObject>
@optional
- (void)InputPayPasswordView:(InputPayPassword *)view didClickSureWithPassword:(NSString *)password;
@end
@interface InputPayPassword : UIView
@property (nonatomic, weak)id<InputPayPasswordViewDelegate>delegate;
- (void)show;
- (void)dismiss;
@end


NS_ASSUME_NONNULL_END
