//
//  StoreGoodsIndexCollectionViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/2.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "StoreGoodsIndexCollectionViewCell.h"

@implementation StoreGoodsIndexCollectionViewCell

-(void)layoutSubviews
{
    [_imageViewLogo sd_setImageWithURL:[NSURL URLWithString:_dic[@"goods_image_url"]] placeholderImage:defaultImage];
    
    [_labelTitle setText:[NSString stringWithFormat:@"%@",_dic[@"goods_name"]]];
    [_labelPrice setText:[NSString stringWithFormat:@"¥%@",_dic[@"goods_price"]]];
    
    [_labelPriceOrigin setText:[NSString stringWithFormat:@"¥%@",_dic[@"goods_marketprice"]]];
    [_labelPriceOrigin addDeletelineColor:[UIColor grayColor] toText:[NSString stringWithFormat:@"¥%@",_dic[@"goods_marketprice"]]];
    
    
        
    [_imageViewLogo setFrame:CGRectMake(10, 10, self.contentView.width - 20, (self.contentView.width - 20)*(160.0/220.0))];
    [_imageViewLogo setContentMode:contentModeDefault];
    [_imageViewLogo setClipsToBounds:YES];
    
    
    [_labelTitle setFrame:CGRectMake(10, _imageViewLogo.bottom + 5, self.contentView.frame.size.width-40, 50)];
    [_labelTitle setFont:FontMediumWithSize(15)];
    
    [_labelPrice setFrame:CGRectMake(10, _labelTitle.bottom + 5,100, 20)];
    [_labelPrice setFont:FontRegularWithSize(15)];
    
    [_labelPriceOrigin setFrame:CGRectMake(_labelPrice.right + 10, _labelPrice.top,self.contentView.frame.size.width-_labelPrice.right - 20 , 20)];
    [_labelPriceOrigin setFont:FontRegularWithSize(15)];
    
    FuwenbenLabelWithFontAndColorInRange(_labelPrice, FontMediumWithSize(16), GPHexColor(0xEA5951), NSMakeRange(0, 2));
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _imageViewLogo = [[UIImageView alloc]init];
        
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.numberOfLines = 2;
        _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTitle.textColor = kColorFontMedium;
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textAlignment = NSTextAlignmentLeft;
        
        _labelPrice = [[UILabel alloc] init];
        _labelPrice.numberOfLines = 1;
        _labelPrice.lineBreakMode = NSLineBreakByCharWrapping;
        _labelPrice.textColor = [UIColor redColor];
        _labelPrice.backgroundColor = [UIColor clearColor];
        _labelPrice.textAlignment = NSTextAlignmentLeft;
        
        _labelPriceOrigin = [[UILabel alloc] init];
        _labelPriceOrigin.numberOfLines = 1;
        _labelPriceOrigin.lineBreakMode = NSLineBreakByCharWrapping;
        _labelPriceOrigin.textColor = [UIColor grayColor];
        _labelPriceOrigin.backgroundColor = [UIColor clearColor];
        _labelPriceOrigin.textAlignment = NSTextAlignmentRight;
        
        
        cellSetBackgroundColor(kColorCellBackground);
        
        [self.contentView addSubview:_imageViewLogo];
        [self.contentView addSubview:_labelTitle];
        [self.contentView addSubview:_labelPrice];
        [self.contentView addSubview:_labelPriceOrigin];
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

