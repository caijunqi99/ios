//
//  CategoryBarWithImages.m
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import "CategoryBarWithImages.h"

@implementation CategoryBarWithImages

-(void)setArrayItemImageUrlString:(NSArray *)arrayItemImageUrlString
{
    _arrayItemImageUrlString = arrayItemImageUrlString;
}

-(void)updateData
{
    [super updateData];
    for (NSInteger i = 0; i< self.arrayItemImageUrlString.count; i++) {
        UIButton *button = self.arrayButton[i];
        
        if ([_arrayItemImageUrlString[i] isKindOfClass:[NSString class]]) {
            if ([_arrayItemImageUrlString[i] hasPrefix:@"http"]) {
                [button sd_setImageWithURL:[NSURL URLWithString:_arrayItemImageUrlString[i]] forState:UIControlStateNormal placeholderImage:GetImage(@"水果")];
            }
            else
            {
                [button setImage:GetImage(_arrayItemImageUrlString[i]) forState:UIControlStateNormal];
            }
            
        }
        else if([_arrayItemImageUrlString[i] isKindOfClass:[UIImage class]])
        {
            [button setImage:_arrayItemImageUrlString[i] forState:UIControlStateNormal];
        }
        [button layoutButtonWithEdgeInsetsStyle:HPButtonEdgeInsetsStyleTop imageTitleSpace:0];
        
        button.imageView.contentMode = contentModeDefault;
//        [button setImageEdgeInsets:UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height, 0, 0, -button.titleLabel.intrinsicContentSize.width)];
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(button.currentImage.size.height +5, -button.currentImage.size.width, 0, 0)];
        
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
