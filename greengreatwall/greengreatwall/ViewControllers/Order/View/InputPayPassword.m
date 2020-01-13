//
//  InputPayPassword.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/26.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "InputPayPassword.h"


#define HOME_INDICATOR_HEIGHT 0.0f

#define View_Max_Height (GPScreenHeight - HOME_INDICATOR_HEIGHT - kNavBarAndStatusBarHeight - 100)


@interface InputPayPassword()<UIGestureRecognizerDelegate>
/**承载所有内容的视图*/
@property (nonatomic, strong)UIView *contentView;

/**输入框说明*/
@property (nonatomic, strong)UILabel *titleL;
/**密码输入框*/
@property (nonatomic, strong)UITextField *passwordT;
/**确定按钮*/
@property (nonatomic, strong)UIButton *sureBtn;
@end
@implementation InputPayPassword

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)init {
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
        [self setUpView];
    }
    return self;
}

#pragma mark - 设置界面
- (void)setUpView{
    self.frame = CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - HOME_INDICATOR_HEIGHT);
    self.backgroundColor =  RGBA(0, 0, 0, 0.4);
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.passwordT];
    [self.contentView addSubview:self.sureBtn];
}

#pragma makr - 懒加载内容视图

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(20, GPScreenHeight - HOME_INDICATOR_HEIGHT, GPScreenWidth - 40, 150)];
        //绘制圆角
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = path.CGPath;
        _contentView.layer.mask = maskLayer;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}


- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.contentView.width - 40, 30)];
        _titleL.numberOfLines = 1;
        _titleL.lineBreakMode = LineBreakModeDefault;
        _titleL.font = FontRegularWithSize(12);
        _titleL.text = @"请输入支付密码";
        _titleL.textColor = [UIColor blackColor];
        _titleL.backgroundColor = [UIColor whiteColor];
    }
    return _titleL;
}

-(UITextField *)passwordT
{
    if (!_passwordT) {
        _passwordT = [UITextField initTextFieldFont:16 LeftImageName:nil Placeholder:@"请输入支付密码"];
        
        [_passwordT setFrame:CGRectMake(20, 50, self.contentView.width - 40, 40)];
        _passwordT.secureTextEntry = YES;
        [_passwordT border:1 color:kColorTheme];
    }
    return _passwordT;
}


- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, self.passwordT.maxY + 10, self.contentView.width - 80, 40)];
        _sureBtn.backgroundColor = kColorTheme;
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.layer.cornerRadius = 20;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _sureBtn;
}
#pragma mark - 确定按钮
- (void)sureAction {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(InputPayPasswordView:didClickSureWithPassword:)]) {
        [self.delegate InputPayPasswordView:self didClickSureWithPassword:_passwordT.text];
    }
}
#pragma mark - 弹出视图
- (void)show {
    [[self lastWidow] addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView setFrame:CGRectMake(20, GPScreenHeight/2.0 - HOME_INDICATOR_HEIGHT - self.contentView.height, GPScreenWidth - 40, self.contentView.height)];
    }];
}
#pragma mark - 点击方法
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (CGRectContainsPoint(self.contentView.frame, [tap locationInView:self])) {
        
    }else {
        [self dismiss];
    }
}
#pragma mark - 隐藏视图
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView setFrame:CGRectMake(20, GPScreenHeight - HOME_INDICATOR_HEIGHT, GPScreenWidth -40, self.contentView.height)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - 获取最上层window
- (UIWindow *)lastWidow{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

@end
