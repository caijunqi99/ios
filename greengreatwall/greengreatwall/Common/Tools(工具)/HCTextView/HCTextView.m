//
//  HCTextView.m
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import "HCTextView.h"

@implementation HCTextView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.editable = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil]; //注册textView输入内容改变的通知
        
    }
     return self;
}


- (void)setTextViewLayerCornerRadius:(float)radius borderWidth:(float)viewBorderWidth borderColor:(UIColor *)viewBorderColor {
    
    if (self.haveLayer) {
        
        self.layer.cornerRadius = radius;
        self.layer.borderColor = viewBorderColor.CGColor;
        self.layer.borderWidth = viewBorderWidth;
    }
    
}


-(void)setPlaceholder:(NSString *)placeholder{
    
    if (_placeholder != placeholder) {
        
        _placeholder = placeholder;
        
        [self.placeHolderLabel removeFromSuperview];
        
        self.placeHolderLabel = nil;
        
        [self setNeedsDisplay];
        
        
    }
}

- (void)textChanged:(NSNotification *)notification{
    
    if ([[self placeholder] length] == 0) {
        return;
    }
    
    if ([[self text] length] == 0) { //输入内容为空
        
        [self viewWithTag:888].hidden = NO; // 提示字显示
    }
    
    else {//输入内容不为空
        
        [self viewWithTag:888].hidden = YES; //提示字隐藏
    }
    
}



-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    if ([[self placeholder] length] > 0) {
        if (_placeHolderLabel == nil) {
            _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, self.bounds.size.width - 16, 0)];
            _placeHolderLabel.lineBreakMode = LineBreakModeDefault;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.placeholderFont;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.tag = 888;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if ([[self text] length] == 0 && [[self placeholder] length] >0) {
        [self viewWithTag:888].hidden = NO; //设置提示字显示
    }
    
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
