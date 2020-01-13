//
//  ProAttrSelectView.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/9.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ProAttrSelectView.h"

#define HOME_INDICATOR_HEIGHT 0.0f

#define View_Max_Height (GPScreenHeight - HOME_INDICATOR_HEIGHT - kNavBarAndStatusBarHeight - 100)
#define Attr_Btn_Height 30.0f


@interface ProAttrSelectView()<UIGestureRecognizerDelegate,AttrSectionViewDelegate>
/**承载所有内容的视图*/
@property (nonatomic, strong)UIView *contentView;
/**产品图片*/
@property (nonatomic, strong)UIImageView *imageV;

/**产品名称*/
@property (nonatomic, strong)UILabelAlignToBottomLeft *titleL;
/**产品价格*/
@property (nonatomic, strong)UILabel *priceL;
/**属性描述*/
@property (nonatomic, strong)UILabel *desL;
/**承载属性的滑动视图*/
@property (nonatomic, strong)UIScrollView *attrScrollView;
/**删除按钮*/
@property (nonatomic, strong)UIButton *deleteBtn;
/**确定按钮*/
@property (nonatomic, strong)UIButton *sureBtn;
/**后台的属性数据*/
@property (nonatomic, strong)NSArray *dataSource;
///**后台的属性数据*/
//@property (nonatomic, strong)NSString *imageUrlstring;
///**后台的属性数据*/
//@property (nonatomic, strong)NSString *goodsName;
/**计数视图*/
@property (nonatomic, strong)CountView *countV;
@end
@implementation ProAttrSelectView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithData:(NSArray *)data {
    if ([super init]) {
        self.layer.masksToBounds = YES;
        self.dataSource = data;
        self.selectedAttrs = [NSMutableArray array];
        [self setUpView];
        
    }
    return self;
}
#warning edit this
- (instancetype)initWithImageUrlString:(NSString *)imageUrlString andGoodsName:(NSString *)goodsName{
    if ([super init]) {
        self.layer.masksToBounds = YES;
//        self.imageUrlstring = imageUrlString;
//        self.goodsName = goodsName;
        [self.titleL setText:goodsName];
        [self.imageV sd_setImageWithURL:URL(imageUrlString)];
        
        self.selectedAttrs = [NSMutableArray array];
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
    
    
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleL];
    //    [self.contentView addSubview:self.priceL];
    //    [self.contentView addSubview:self.desL];
    [self.contentView addSubview:self.deleteBtn];
    
    
    //添加分割线1
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 119, GPScreenWidth, 1)];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line1];
#warning edit this
    //添加属性分区
    [self.contentView addSubview:self.attrScrollView];
    
    CGFloat attrSectionY = 0;
    //    for (int i = 0; i < self.dataSource.count; i++) {
    //        AttrSectionView *view = [[AttrSectionView alloc]initWithFrame:CGRectMake(0, attrSectionY, GPScreenWidth, 0) andData:self.dataSource[i] andSection:i];
    //        view.delegate = self;
    //        [self.attrScrollView addSubview:view];
    //        attrSectionY += view.height;
    //
    //        [self.selectedAttrs addObject:@""];
    //    }
    //添加计数
    self.countV = [[CountView alloc]initWithFrame:CGRectMake(0, attrSectionY, GPScreenWidth, 50)];
    [self.attrScrollView addSubview:self.countV];
    //设置最终的contentsize
    self.attrScrollView.contentSize = CGSizeMake(GPScreenWidth, self.countV.maxY);
    
    
    //添加分割线2
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.attrScrollView.maxY, GPScreenWidth, 1)];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line2];
    //确定按钮
    [self.contentView addSubview:self.sureBtn];
    //配置contentView最终高度
    if (self.attrScrollView.contentSize.height < self.self.attrScrollView.height ) {
        self.attrScrollView.height = self.attrScrollView.contentSize.height;
        self.contentView.height = self.attrScrollView.maxY + 60;
        line2.top = self.attrScrollView.maxY;
        self.sureBtn.top = line2.maxY + 10;
    }
}
#pragma mark - 某个属性被选中
- (void)attrSectionView:(AttrSectionView *)view didSelectedAttr:(NSString *)attr atSection:(NSInteger )section {
    [self.selectedAttrs replaceObjectAtIndex:section withObject:attr];
    self.desL.text = [NSString stringWithFormat:@"已经选择：%@", [self.selectedAttrs componentsJoinedByString:@" "]];
}
#pragma makr - 懒加载内容视图
- (UIScrollView *)attrScrollView {
    if (!_attrScrollView) {
        _attrScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 120, GPScreenWidth, self.contentView.height - 180)];
        _attrScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _attrScrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, GPScreenHeight - HOME_INDICATOR_HEIGHT, GPScreenWidth, View_Max_Height)];
        //绘制圆角
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = path.CGPath;
        _contentView.layer.mask = maskLayer;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
        _imageV.backgroundColor = [UIColor grayColor];
        _imageV.layer.cornerRadius = 5;
        _imageV.layer.masksToBounds = YES;
    }
    return _imageV;
}

- (UILabelAlignToBottomLeft *)titleL {
    if (!_titleL) {
        _titleL = [[UILabelAlignToBottomLeft alloc]initWithFrame:CGRectMake(self.imageV.right + 10, 10, GPScreenWidth - self.imageV.right - 20, 100)];
        _titleL.numberOfLines = 5;
        _titleL.lineBreakMode = LineBreakModeDefault;
        _titleL.font = FontRegularWithSize(12);
        _titleL.text = @"商品名称";
        _titleL.textColor = [UIColor blackColor];
        _titleL.backgroundColor = [UIColor whiteColor];
    }
    return _titleL;
}


- (UILabel *)priceL {
    if (!_priceL) {
        _priceL = [[UILabel alloc]initWithFrame:CGRectMake(self.imageV.right + 10, 70, GPScreenWidth - 50, 20)];
        _priceL.font = FontRegularWithSize(15);
        _priceL.text = @"商品价格暂无";
        _priceL.textColor = [UIColor blackColor];
        _priceL.backgroundColor = [UIColor whiteColor];
    }
    return _priceL;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(GPScreenWidth - 30, 10, 20, 20)];
        [_deleteBtn setImage:GetImage(@"icon_delete") forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (UILabel *)desL {
    if (!_desL) {
        _desL = [[UILabel alloc]initWithFrame:CGRectMake(self.priceL.left, self.priceL.maxY, self.priceL.width, 20)];
        _desL.font = FontRegularWithSize(14);
        _desL.text = @"请选择商品属性";
        _desL.textColor = [UIColor blackColor];
        _desL.backgroundColor = [UIColor whiteColor];
    }
    return _desL;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, self.attrScrollView.maxY + 10, GPScreenWidth - 40, 40)];
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
    //    for (NSString *attr in self.selectedAttrs) {
    //        if ([attr isEqualToString:@""]) {
    //            GPDebugLog(@"您还有属性还没有选中");
    //            return;
    //        }
    //    }
    
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(proAttrSelectView:didClickSureWithAttrs:count:)]) {
        [self.delegate proAttrSelectView:self didClickSureWithAttrs:self.selectedAttrs count:self.countV.count];
    }
}
#pragma mark - 弹出视图
- (void)show {
    [[self lastWidow] addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView setFrame:CGRectMake(0, GPScreenHeight - HOME_INDICATOR_HEIGHT - self.contentView.height, GPScreenWidth, self.contentView.height)];
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
        [self.contentView setFrame:CGRectMake(0, GPScreenHeight - HOME_INDICATOR_HEIGHT, GPScreenWidth, self.contentView.height)];
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


@interface AttrSectionView()
/**属性单元的数据*/
@property (nonatomic, strong)NSDictionary *data;
/**属性单元的类型*/
@property (nonatomic, strong)UILabel *attrTypeL;
/**已经选中的属性*/
@property (nonatomic, strong)NSString *selectedAttr;
@end
@implementation AttrSectionView
#define Attr_Btn_H 10.0f //按钮左右间距
#define Attr_Btn_V 10.0f //按钮上下间距

- (instancetype)initWithFrame:(CGRect)frame andData:(NSDictionary *)data andSection:(NSInteger )section{
    if ([super initWithFrame:frame]) {
        _data = data;
        self.tag = section;
        [self setupView];
    }
    return self;
}
#pragma mark - 设置视图
- (void)setupView {
    [self addSubview:self.attrTypeL];
    //配置属性按钮
    NSArray *array = self.data.allValues.firstObject;
    //布局过程中当前按钮的最大X
    CGFloat lastright = Attr_Btn_H;
    //布局过程中当前按钮最大的Y
    CGFloat lastMaxY =  40;
    for (int i = 0; i < array.count; i++) {
        AttrBtn *btn = [AttrBtn attrBtnWithTitle:array[i]];
        [btn addTarget:self action:@selector(attrBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (btn.width + lastright + Attr_Btn_H > self.frame.size.width) {
            //如果这个按钮的宽度过大，两种情况一种是这一行只有这一个按钮，它就是太长 ，另一种是还有别的按钮，要换行
            if (lastright == Attr_Btn_H) {
                //第一种情况 独占一行
                btn.frame = CGRectMake(lastright, lastMaxY, self.frame.size.width - 2 * Attr_Btn_H, btn.height);
                //最大高度改变
                lastMaxY = lastMaxY + btn.height + Attr_Btn_V;
            }else {
                //需要换行
                lastMaxY = lastMaxY + btn.height + Attr_Btn_V;
                lastright = Attr_Btn_H;
                btn.frame = CGRectMake(lastright, lastMaxY, btn.width + lastright + Attr_Btn_H > self.width ? self.width - 2 * Attr_Btn_H : btn.width, btn.height);
                lastright = btn.right + Attr_Btn_H;
            }
        }else {
            //可以放得下，不需要换行
            btn.frame = CGRectMake(lastright, lastMaxY, btn.width, btn.height);
            lastright = lastright + btn.width + Attr_Btn_H;
        }
        [self addSubview:btn];
    }
    //设置高度
    self.frame = CGRectMake(self.left, self.top, self.width, lastMaxY + Attr_Btn_Height + Attr_Btn_H);
}
#pragma mark - 设置某个属性是否可用
- (void)setAttrEnable:(BOOL)enable withTitle:(NSString *)title {
    for (UIView *subV in self.subviews) {
        if ([subV isKindOfClass:[AttrBtn class]]) {
            AttrBtn *tempBtn = (AttrBtn *)subV;
            //根据标题获取到属性按钮
            if ([title isEqualToString:tempBtn.titleLabel.text]) {
                if (tempBtn.enabled == enable) {
                    break;
                }else {
                    tempBtn.enabled = enable;
                    if (tempBtn.isEnabled != YES && tempBtn.isSelected == YES) {
                        self.selectedAttr = nil;
                        tempBtn.selected = NO;
                    }
                    //设置背景颜色
                    if (tempBtn.isEnabled == YES) {
                        tempBtn.alpha = 1;
                    }else {
                        tempBtn.alpha = 0.5;
                    }
                }
                break;
            }
        }
    }
}
#pragma mark - 点击属性按钮
- (void)attrBtnClicked:(AttrBtn *)btn {
    if (btn.isSelected == YES) {
        btn.selected = NO;
        if ([self.delegate respondsToSelector:@selector(attrSectionView:didSelectedAttr:atSection:)]) {
            [self.delegate attrSectionView:self didSelectedAttr:@"" atSection:self.tag];
        }
        return;
    }
    for (UIView *subV in self.subviews) {
        if ([subV isKindOfClass:[AttrBtn class]]) {
            AttrBtn *tempBtn = (AttrBtn *)subV;
            tempBtn.selected = NO;
        }
    }
    btn.selected = YES;
    if ([self.delegate respondsToSelector:@selector(attrSectionView:didSelectedAttr:atSection:)]) {
        [self.delegate attrSectionView:self didSelectedAttr:btn.titleLabel.text atSection:self.tag];
    }
}
#pragma mark - 懒加载
- (UILabel *)attrTypeL {
    if (!_attrTypeL) {
        _attrTypeL = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GPScreenWidth, 40)];
        _attrTypeL.font = FontRegularWithSize(15);
        _attrTypeL.textColor = [UIColor blackColor];
        _attrTypeL.text = self.data.allKeys.firstObject;
    }
    return _attrTypeL;
}

@end

//实现属性按钮
@implementation AttrBtn
+ (AttrBtn *)attrBtnWithTitle:(NSString *)title {
    AttrBtn *btn = [super buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = FontRegularWithSize(13);
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    //设置处于未点击状态下的按钮
    btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置处于点击状态下的按钮
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    //设置尺寸 按钮内部文字 + 20空隙
    CGSize size = [btn.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 30)];
    btn.frame = CGRectMake(0, 0, size.width + 20, Attr_Btn_Height);
    //监听按钮的点击状态
    [btn addObserver:btn forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    return btn;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"selected"]) {
        if (self.selected) {
            //选中状态
            self.backgroundColor = [UIColor redColor];
            self.layer.borderWidth = 1;
            self.layer.borderColor = [UIColor redColor].CGColor;
        }else {
            //未选中状态
            self.backgroundColor = [UIColor groupTableViewBackgroundColor];
            self.layer.borderWidth = 0;
        }
    }
}

@end


@interface CountView()<UITextFieldDelegate>
/**减按钮*/
@property (nonatomic, strong)UIButton *minusBtn;
/**计数输入框*/
@property (nonatomic, strong)UITextField *countT;
/**加按钮*/
@property (nonatomic, strong)UIButton *plusBtn;
@end
@implementation CountView
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        //强行设置frame 的宽高
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, GPScreenWidth, 50);
        self.backgroundColor = [UIColor whiteColor];
        self.count = 1;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    UILabel *tagL = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, self.height)];
    tagL.backgroundColor = [UIColor whiteColor];
    tagL.text = @"购买数量";
    tagL.textColor = [UIColor blackColor];
    [self addSubview:tagL];
    
    [self addSubview:self.minusBtn];
    [self addSubview:self.countT];
    [self addSubview:self.plusBtn];
}
#pragma mark - 懒加载计数视图
- (UIButton *)minusBtn {
    if (!_minusBtn) {
        _minusBtn = [[UIButton alloc]initWithFrame:CGRectMake(GPScreenWidth - 112, 10, 30, 30)];
        _minusBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _minusBtn.alpha = 0.5;
        [_minusBtn addTarget:self action:@selector(minusAction) forControlEvents:UIControlEventTouchUpInside];
        [_minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [_minusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //刚开始时不能再减
        _minusBtn.enabled = NO;
    }
    return _minusBtn;
}
- (UITextField *)countT {
    if (!_countT) {
        _countT = [[UITextField alloc]initWithFrame:CGRectMake(self.minusBtn.right + 1, self.minusBtn.top, 40, 30)];
        _countT.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _countT.alpha = 0.5;
        _countT.delegate = self;
        _countT.text = @"1";
        _countT.textColor = [UIColor blackColor];
        _countT.textAlignment = NSTextAlignmentCenter;
        _countT.keyboardType = UIKeyboardTypeNumberPad;
        _countT.userInteractionEnabled = NO;
    }
    return _countT;
}
- (UIButton *)plusBtn {
    if (!_plusBtn) {
        _plusBtn = [[UIButton alloc]initWithFrame:CGRectMake(_countT.right + 1, _countT.top, 30, 30)];
        _plusBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _plusBtn.alpha = 0.5;
        [_plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [_plusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_plusBtn addTarget:self action:@selector(plusAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
}
#pragma mark - 减号方法
- (void)minusAction {
    if (self.countT.text.integerValue <= 1) {
        return;
    }else {
        self.countT.text = [NSString stringWithFormat:@"%ld",self.countT.text.integerValue - 1];
        if ([self.countT.text isEqualToString:@"1"]) {
            self.minusBtn.enabled = NO;
        }else {
            self.minusBtn.enabled = YES;
        }
        self.count = self.countT.text.integerValue;
    }
}
#pragma mark -结束输入
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.integerValue < 1) {
        textField.text = @"1";
    }
    if ([textField.text isEqualToString:@"1"]) {
        self.minusBtn.enabled = NO;
    }else {
        self.minusBtn.enabled = YES;
    }
    self.count = self.countT.text.integerValue;
}
#pragma mark - 增加
- (void)plusAction {
    self.countT.text = [NSString stringWithFormat:@"%ld",self.countT.text.integerValue + 1];
    if ([self.countT.text isEqualToString:@"1"]) {
        self.minusBtn.enabled = NO;
    }else {
        self.minusBtn.enabled = YES;
    }
    self.count = self.countT.text.integerValue;
}
@end
//————————————————
//版权声明：本文为CSDN博主「知己子」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
//原文链接：https://blog.csdn.net/qq_20933903/article/details/84587121
