//
//  CategoryBar.m
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import "CategoryBar.h"

@interface CategoryBar ()
{
    UIScrollView    *_scrollBar;
    UIView          *_line;
    CGRect          _selfFrame;
    CGFloat         _buttonInset;
    
    NSArray         *_buttonsWidth;
    NSArray         *_buttonsHeight;
}
@end

@implementation CategoryBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _selfFrame = frame;
        [self initConfig];
    }
    return self;
}

- (void)initConfig
{
    _arrayButton = [@[] mutableCopy];
    _buttonHeight = 0;
    [self viewConfig];
}

- (void)viewConfig
{
    _scrollBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _selfFrame.size.width, _selfFrame.size.height)];
    _scrollBar.backgroundColor = [UIColor clearColor];
    _scrollBar.showsHorizontalScrollIndicator = NO;
    _scrollBar.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollBar];
}

- (void)updateData
{
    if (_isVertical) {
        _buttonsHeight = [self getButtonsHeightWithTitles:_itemTitles];
        if (_buttonsHeight.count)
        {
            CGFloat contentHeight = [self contentHeightAndAddNavTabBarItemsWithButtonsHeight:_buttonsHeight];
            _scrollBar.contentSize = CGSizeMake(0, contentHeight);
        }
    }else{
        _buttonsWidth = [self getButtonsWidthWithTitles:_itemTitles];
        if (_buttonsWidth.count)
        {
            CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_buttonsWidth];
            _scrollBar.contentSize = CGSizeMake(contentWidth, 0);
        }
    }
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    for (UIButton *btn in _arrayButton) {
        [btn removeFromSuperview];
    }
    [_arrayButton removeAllObjects];
    
    CGFloat buttonX = 0;
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = _font;
        [button.titleLabel setSize:CGSizeMake([widths[index] floatValue],_selfFrame.size.height-4)];
        button.frame = CGRectMake(buttonX, 0,[widths[index] floatValue] + _buttonInset*2, _selfFrame.size.height);
        //字体颜色
        [button setTitleColor:_titleColor forState:UIControlStateNormal];
        [button setTitleColor:_titleColorSelected forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor whiteColor]];
        
        
        //        [button.layer setBorderColor:[_titleColorSelected CGColor]];
        //        [button.layer setBorderWidth:0.3];
        
        [button addTarget:self action:@selector(itemPressed:type:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollBar addSubview:button];
        [_arrayButton addObject:button];
        buttonX += button.frame.size.width;
    }
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    return buttonX;
}

//计算数组内字体的宽度
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    CGFloat widthTotal = 0;
    for (NSString *title in titles)
    {
        CGFloat textWidth = [title widthWithFont:_fontSelected height:_selfFrame.size.height];
        widthTotal += (textWidth+2*_buttonInset);
        NSNumber *width = [NSNumber numberWithFloat:textWidth];
        [widths addObject:width];
    }
    if(_isSpread)
    {
        if (widthTotal<_selfFrame.size.width) {
            _buttonInset += (_selfFrame.size.width-widthTotal)/(2*[titles count]);
        }
    }
    
    return widths;
}

#pragma mark  下划线
- (void)showLineWithButtonWidth:(CGFloat)width
{
    //第一个线的位置
    _line = [[UIView alloc] initWithFrame:CGRectMake(_buttonInset, _selfFrame.size.height - 2.0f, width, 2.0f)];
    _line.backgroundColor = _lineColor;
    [_scrollBar addSubview:_line];
    
    UIButton *btn = _arrayButton[0];
    [btn setSelected:YES];
    [self itemPressed:btn type:0];
}


#pragma mark - 竖向

- (CGFloat)contentHeightAndAddNavTabBarItemsWithButtonsHeight:(NSArray *)Heights
{
    for (UIButton *btn in _arrayButton) {
        [btn removeFromSuperview];
    }
    [_arrayButton removeAllObjects];
    CGFloat buttonY = 0;
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = _font;
        [button.titleLabel setSize:CGSizeMake(_selfFrame.size.width,[Heights[index] floatValue])];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = LineBreakModeDefault;
        button.frame = CGRectMake(0, buttonY,_selfFrame.size.width,[Heights[index] floatValue]+ _buttonInset*2);
        
        //字体颜色
        [button setTitleColor:_titleColor forState:UIControlStateNormal];
        [button setTitleColor:_titleColorSelected forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setBackgroundImage:CreateImageWithColor(_buttonColor) forState:UIControlStateNormal];
        [button setBackgroundImage:CreateImageWithColor(_buttonColorSelected) forState:UIControlStateSelected];
        
        //        [button.layer setBorderColor:[_titleColorSelected CGColor]];
        //        [button.layer setBorderWidth:0.3];
        
        [button addTarget:self action:@selector(itemPressed:type:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollBar addSubview:button];
        [_arrayButton addObject:button];
        buttonY += button.frame.size.height;
    }
    [self showLineWithButtonHeight:[Heights[0] floatValue]];
    return buttonY;
}

//计算数组内字体的高度
- (NSArray *)getButtonsHeightWithTitles:(NSArray *)titles;
{
    NSMutableArray *Heights = [@[] mutableCopy];
    CGFloat HeightTotal = 0;
    for (NSString *title in titles)
    {
        if (_buttonHeight!=0)
        {
            NSNumber *height = [NSNumber numberWithFloat:_buttonHeight];
            [Heights addObject:height];
        }
        else
        {
            CGFloat textHeight = [title widthWithFont:_fontSelected height:_selfFrame.size.width];
            HeightTotal += (textHeight+2*_buttonInset);
            NSNumber *height = [NSNumber numberWithFloat:textHeight];
            [Heights addObject:height];
        }
    }
    if(_isSpread)
    {
        if (HeightTotal<_selfFrame.size.height) {
            _buttonInset += (_selfFrame.size.height-HeightTotal)/(2*[titles count]);
        }
    }
    return Heights;
}

#pragma mark 偏移
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    if (currentItemIndex != _currentItemIndex) {
        UIButton *btn = _arrayButton[_currentItemIndex];
        [btn setSelected:NO];
        [btn.titleLabel setFont:_font];
    }
    _currentItemIndex = currentItemIndex;
    UIButton *button = _arrayButton[currentItemIndex];
    [button setSelected:YES];
    [button.titleLabel setFont:_fontSelected];
    if (_isVertical) {
        CGFloat flag = _selfFrame.size.height;
        if (button.frame.origin.y + button.frame.size.height + 50 >= flag)
        {
            CGFloat offsetY = button.frame.origin.y + button.frame.size.height - flag;
            if (_currentItemIndex < [_itemTitles count]-1)
            {
                offsetY = offsetY + button.frame.size.height;
            }
            [_scrollBar setContentOffset:CGPointMake(0, offsetY) animated:YES];
        }
        else
        {
            [_scrollBar setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        //        CGFloat flag = _selfFrame.size.height;
        //        CGFloat offsetY = button.frame.origin.y + button.frame.size.height - flag;
        //
        //        if ((currentItemIndex <= [_itemTitles count]-2)&&(_currentItemIndex<currentItemIndex)&&(offsetY>=0))
        //        {
        //
        //            //GPDebugLog(@"offsetY:%f",offsetY);
        //            //GPDebugLog(@"_currentItemIndex:%ld \n currentItemIndex:%ld",(long)_currentItemIndex,(long)currentItemIndex);
        //
        //            UIButton *btn = (UIButton*)(_arrayButton[currentItemIndex+1]);
        //            offsetY = offsetY + btn.frame.size.height;
        //            //GPDebugLog(@"btn.frame.size.height:%f",btn.frame.size.height);
        //            //GPDebugLog(@"offsetY:%f",offsetY);
        //            [_scrollBar setContentOffset:CGPointMake(0, offsetY) animated:YES];
        //        }
        
        
        
        //下划线的偏移量
        [UIView animateWithDuration:0.1f animations:^{
            self->_line.frame = CGRectMake(self->_line.frame.origin.x, button.frame.origin.y + self->_buttonInset, self->_line.frame.size.width, [self->_buttonsHeight[currentItemIndex] floatValue]);
        }];
        
    }else{
        CGFloat flag = _selfFrame.size.width;
        if (button.frame.origin.x + button.frame.size.width + 50 >= flag)
        {
            CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
            if (_currentItemIndex < [_itemTitles count]-1)
            {
                offsetX = offsetX + button.frame.size.width;
            }
            [_scrollBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        }
        else
        {
            [_scrollBar setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        
        //下划线的偏移量
        [UIView animateWithDuration:0.1f animations:^{
            self->_line.frame = CGRectMake(button.frame.origin.x + self->_buttonInset, self->_line.frame.origin.y, [self->_buttonsWidth[currentItemIndex] floatValue], self->_line.frame.size.height);
        }];
        
    }
    
}

#pragma mark  下划线
- (void)showLineWithButtonHeight:(CGFloat)height
{
    
    //第一个线的位置
    _line = [[UIView alloc] initWithFrame:CGRectMake(_selfFrame.size.width - 2.0f, _buttonInset, 2.0f,  height)];
    _line.backgroundColor = _lineColor;
    [_scrollBar addSubview:_line];
    
    UIButton *btn = _arrayButton[0];
    [btn setSelected:YES];
    [self itemPressed:btn type:0];
}


- (void)itemPressed:(UIButton *)button type:(int)type
{
    NSInteger index = [_arrayButton indexOfObject:button];
    if (index != _currentItemIndex) {
        [_delegate itemDidSelectedWithIndex:index withCurrentIndex:_currentItemIndex];
        
        [self setCurrentItemIndex:index];
    }
}


@end
