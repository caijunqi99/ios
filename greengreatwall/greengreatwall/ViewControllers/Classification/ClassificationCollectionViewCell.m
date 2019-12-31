//
//  ClassificationCollectionViewCell.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/1.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "ClassificationCollectionViewCell.h"
@implementation ClassificationCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        //GPDebugLog(@"%s", __func__);
    }
    return self;
}

-(void)setString_gc_id:(NSString *)string_gc_id
{
    _string_gc_id = string_gc_id;
    self.contentView.backgroundColor = kColorViewBackground;
    if (!_contentVC) {
        _contentVC = [[ClassificationContentViewController alloc]init];
        _contentVC.view.frame = self.bounds;
        [_contentVC.view setWidth:GPScreenWidth - 100];
        _contentVC.string_gc_id = string_gc_id;
        [self addSubview:_contentVC.view];
    }
}


@end
