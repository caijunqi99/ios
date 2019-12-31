//
//  OrderListContentTableViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/28.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "OrderListContentTableViewCell.h"

@implementation OrderListContentTableViewCell

-(void)layoutSubviews
{
    [_imageViewLeft setFrame:RectWithScale(CGRectMake(20, 10, 240, 210), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelTitle setFrame:RectWithScale(CGRectMake(280, 20, 690, 90), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelGoodsType setFrame:RectWithScale(CGRectMake(280, 120, 690, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelPrice setFrame:RectWithScale(CGRectMake(280, 180, 430, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    [_labelCount setFrame:RectWithScale(CGRectMake(800, 180, 100, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    [_buttonToPay setFrame:RectWithScale(CGRectMake(400, 50, 100, 30), GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    //    FuwenbenLabelWithFontAndColorInRange(_labelSales, FontRegularWithSize(10), GPHexColor(0x333333), NSMakeRange(0, 3));
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _imageViewLeft = [[UIImageView alloc]init];
        [_imageViewLeft setImage:GetImage(@"商城购物车")];
        [_imageViewLeft setContentMode:contentModeDefault];
        [_imageViewLeft setClipsToBounds:YES];
        
        _labelTitle = [[UILabelAlignToTopLeft alloc] init];
        _labelTitle.numberOfLines = 3;
        _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTitle.textColor = kColorFontMedium;
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textAlignment = NSTextAlignmentLeft;
        [_labelTitle setFont:FontMediumWithSize(12)];
        
        _labelCount = [[UILabel alloc] init];
        _labelCount.numberOfLines = 1;
        _labelCount.lineBreakMode = NSLineBreakByCharWrapping;
        _labelCount.textColor = kColorFontMedium;
        _labelCount.backgroundColor = [UIColor clearColor];
        _labelCount.textAlignment = NSTextAlignmentCenter;
        [_labelCount setFont:FontMediumWithSize(12)];
        
        _labelPrice = [[UILabel alloc] init];
        _labelPrice.numberOfLines = 1;
        _labelPrice.lineBreakMode = NSLineBreakByCharWrapping;
        _labelPrice.textColor = rgb(255, 140, 0);
        _labelPrice.backgroundColor = [UIColor clearColor];
        _labelPrice.textAlignment = NSTextAlignmentLeft;
        [_labelPrice setFont:FontMediumWithSize(12)];
        
        
        _labelGoodsType = [[UILabelAlignToTopLeft alloc] init];
        _labelGoodsType.numberOfLines = 1;
        _labelGoodsType.lineBreakMode = NSLineBreakByTruncatingTail;
        _labelGoodsType.textColor = [UIColor blackColor];
        _labelGoodsType.backgroundColor = rgb(239, 240, 241);
        _labelGoodsType.textAlignment = NSTextAlignmentLeft;
        [_labelGoodsType setFont:FontRegularWithSize(12)];
        
        _buttonToPay = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_buttonToPay setTitle:@"进店" forState:UIControlStateNormal];
        [_buttonToPay.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonToPay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_buttonToPay setTag:1];
        _buttonToPay.layer.masksToBounds = YES;
        _buttonToPay.clipsToBounds = YES;
        [_buttonToPay.layer setCornerRadius:10.0];
        [_buttonToPay.layer setBorderColor:[UIColor redColor].CGColor];
        [_buttonToPay.layer setBorderWidth:1];
        //        [_buttonToPay rounded:10 width:5 color:[UIColor redColor]];
        [_buttonToPay addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        cellSetBackgroundColor(kColorCellBackground);
        
        [self.contentView addSubview:_imageViewLeft];
        [self.contentView addSubview:_labelTitle];
        [self.contentView addSubview:_labelCount];
        [self.contentView addSubview:_labelPrice];
        
//        [self.contentView addSubview:_buttonToPay];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_buttonToPay addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
    
    if (self.btnClick) {
        //        self.btnClick(btn);
    }
    if ([buttonName containsString:@"日常保洁"])
    {
        
    }
    else if([buttonName containsString:@"深度保洁"])
    {
        
    }
}

-(void)setDic:(NSDictionary *)dic
{
//    self.labelCount.text = [NSString stringWithFormat:@"数量:%@", goodsModel.goods_num];
//    [self.imageViewLeft sd_setImageWithURL:URL(goodsModel.goods_image_url) placeholderImage:defaultImage];
//    self.labelTitle.text = goodsModel.goods_name;
//    self.labelPrice.text = [NSString stringWithFormat:@"%@元", goodsModel.goods_price];
}

- (void)setGoodsModel:(GoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    self.labelCount.text = [NSString stringWithFormat:@"数量:%@", goodsModel.goods_num];
    [self.imageViewLeft sd_setImageWithURL:URL(goodsModel.goods_image_url) placeholderImage:defaultImage];
    self.labelTitle.text = goodsModel.goods_name;
    self.labelPrice.text = [NSString stringWithFormat:@"%@元", goodsModel.goods_price];
//    self.labelGoodsType.text = [NSString stringWithFormat:@"%@", goodsModel.goods_advword];
}

@end
