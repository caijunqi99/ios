//
//  ClassificationContentCollectionHeader.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/25.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ClassificationContentCollectionHeader.h"

@implementation ClassificationContentCollectionHeader

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.95];
        [self createLab];
    }
    return self;
}
- (void)createLab{
    self.labelTitle = [UILabel initLabelTextFont:FontMediumWithSize(14) textColor:kColorFontMedium title:@""];
    [self addSubview:self.labelTitle];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.top.bottom.equalTo(self);
    }];
}

-(void)setStringTitle:(NSString *)stringTitle
{
    self.labelTitle.text = stringTitle;
}

@end
