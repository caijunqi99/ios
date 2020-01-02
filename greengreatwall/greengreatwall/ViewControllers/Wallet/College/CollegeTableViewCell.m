//
//  CollegeTableViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/2.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "CollegeTableViewCell.h"

@implementation CollegeTableViewCell

-(void)layoutSubviews
{
    [_imageViewLeft sd_setImageWithURL:URL(_dic[@"article_pic"]) placeholderImage:defaultImage];
    
    [_labelTitle setText:[NSString stringWithFormat:@"%@",_dic[@"article_title"]]];
    
//    [_labelPriceOrigin setText:[NSString stringWithFormat:@"%@",_dic[@"goods_marketprice"]]];
//    [_labelPriceOrigin addDeletelineColor:[UIColor grayColor] toText:_dic[@"goods_marketprice"]];
//    
//    [_labelPrice setText:[NSString stringWithFormat:@"%@",_dic[@"goods_price"]]];
    
    [_labelTime setText:[NSString stringWithFormat:@"%@",_dic[@"article_time"]]];
    
    [_imageViewLeft setFrame:RectWithScale(CGRectMake(50, 20, 200, 200), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelTitle setFrame:RectWithScale(CGRectMake(300, 30, 750, 150), GPCommonLayoutScaleSizeWidthIndex)];
    
//    [_labelPriceOrigin setFrame:RectWithScale(CGRectMake(340, 230, 360, 40), GPCommonLayoutScaleSizeWidthIndex)];
//    [_labelPrice setFrame:RectWithScale(CGRectMake(340, 280, 360, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    [_labelTime setFrame:RectWithScale(CGRectMake(300, 180, 750, 30), GPCommonLayoutScaleSizeWidthIndex)];
    
//    [_buttonDetail setFrame:RectWithScale(CGRectMake(30, 40, 280, 280), GPCommonLayoutScaleSizeWidthIndex)];
    
    
//    FuwenbenLabelWithFontAndColorInRange(_labelPrice, FontRegularWithSize(10), GPHexColor(0x333333), NSMakeRange(_labelPrice.text.length - 3, 3));
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        _imageViewLeft = [[UIImageView alloc]init];
        [_imageViewLeft setContentMode:contentModeDefault];
        [_imageViewLeft setClipsToBounds:YES];
        
        _labelTitle = [[UILabelAlignToTopLeft alloc] init];
        _labelTitle.numberOfLines = 5;
        _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTitle.textColor = kColorFontMedium;
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textAlignment = NSTextAlignmentLeft;
        [_labelTitle setFont:FontMediumWithSize(16)];
        
//        _labelPriceOrigin = [[UILabel alloc] init];
//        _labelPriceOrigin.numberOfLines = 1;
//        _labelPriceOrigin.lineBreakMode = NSLineBreakByCharWrapping;
//        _labelPriceOrigin.textColor = GPHexColor(0xAAAAAA);
//        _labelPriceOrigin.backgroundColor = [UIColor clearColor];
//        _labelPriceOrigin.textAlignment = NSTextAlignmentLeft;
//        [_labelPriceOrigin setFont:FontMediumWithSize(12)];
//
//        _labelPrice = [[UILabel alloc] init];
//        _labelPrice.numberOfLines = 1;
//        _labelPrice.lineBreakMode = NSLineBreakByCharWrapping;
//        _labelPrice.textColor = [UIColor redColor];
//        _labelPrice.backgroundColor = [UIColor clearColor];
//        _labelPrice.textAlignment = NSTextAlignmentLeft;
//        [_labelPrice setFont:FontMediumWithSize(18)];
        
        
        _labelTime = [[UILabel alloc] init];
        _labelTime.numberOfLines = 1;
        _labelTime.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTime.textColor = GPHexColor(0xAAAAAA);
        _labelTime.backgroundColor = [UIColor clearColor];
        _labelTime.textAlignment = NSTextAlignmentLeft;
        [_labelTime setFont:FontRegularWithSize(12)];
        
//        _buttonDetail = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        [_buttonDetail setTitle:@"查看详情" forState:UIControlStateNormal];
//        [_buttonDetail.titleLabel setFont:FontRegularWithSize(12)];
//        [_buttonDetail setTitleColor:GPHexColor(0xFFFFFF) forState:UIControlStateNormal];
//        [_buttonDetail setTag:3];
//        [_buttonDetail setBackgroundColor:GPHexColor(0xFEB466)];
//        [_buttonDetail addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        cellSetBackgroundColor(kColorCellBackground);
                
        [self.contentView addSubview:_imageViewLeft];
        [self.contentView addSubview:_labelTitle];
//        [self.contentView addSubview:_labelPriceOrigin];
//        [self.contentView addSubview:_labelPrice];
        [self.contentView addSubview:_labelTime];
//        [self.contentView addSubview:_buttonDetail];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [_buttonDetail addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
//    if (self.btnClick) {
//        self.btnClick(btn);
//    }
    
    if ([buttonName containsString:@"日常保洁"])
    {
        
    }
    else if([buttonName containsString:@"深度保洁"])
    {
        
    }
}

@end
