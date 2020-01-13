//
//  ClassificationContentCollectionViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/22.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ClassificationContentCollectionViewCell.h"

@implementation ClassificationContentCollectionViewCell

-(void)layoutSubviews
{
    CGFloat width = (GPScreenWidth - 100)/3.0;
    CGFloat height = width;
    
    [_imageViewLogo sd_setImageWithURL:[NSURL URLWithString:_dic[@"image"]] placeholderImage:defaultImage];
    
    [_labelTitle setText:[NSString stringWithFormat:@"%@",_dic[@"gc_name"]]];
    
    [_imageViewLogo setFrame:CGRectMake(20, 5, self.contentView.width - 40, (self.contentView.width - 40))];
    [_imageViewLogo setContentMode:contentModeDefault];
    [_imageViewLogo setClipsToBounds:YES];
    
    
    [_labelTitle setFrame:CGRectMake(20, _imageViewLogo.bottom + 5, self.contentView.width-40, 20)];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _imageViewLogo = [[UIImageView alloc]init];
        
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.numberOfLines = 1;
        _labelTitle.lineBreakMode = LineBreakModeDefault;
        _labelTitle.textColor = kColorFontMedium;
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        [_labelTitle setFont:FontMediumWithSize(15)];
        
        cellSetBackgroundColor(kColorCellBackground);
        
        [self.contentView addSubview:_imageViewLogo];
        [self.contentView addSubview:_labelTitle];
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    [self layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
