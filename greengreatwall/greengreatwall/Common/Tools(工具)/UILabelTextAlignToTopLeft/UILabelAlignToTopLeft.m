//
//  UILabelAlignToTopLeft.m
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import "UILabelAlignToTopLeft.h"

@implementation UILabelAlignToTopLeft

- (id)initWithFrame:(CGRect)frame {
    
    return [super initWithFrame:frame];
    
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    textRect.origin.y = bounds.origin.y;
    
    return textRect;
    
}

-(void)drawTextInRect:(CGRect)requestedRect {
    
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    
    [super drawTextInRect:actualRect];
    
}

@end
