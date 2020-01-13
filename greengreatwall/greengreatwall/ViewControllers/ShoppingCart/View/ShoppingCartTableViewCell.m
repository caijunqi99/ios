//
//  ShoppingCartTableViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/3.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"

@implementation ShoppingCartTableViewCell

-(void)layoutSubviews
{
    [_buttonSelect setFrame:RectWithScale(CGRectMake(40, 110, 40, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_imageViewLeft setFrame:RectWithScale(CGRectMake(120, 10, 240, 210), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelTitle setFrame:RectWithScale(CGRectMake(380, 20, 590, 90), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelGoodsType setFrame:RectWithScale(CGRectMake(380, 120, 590, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelPrice setFrame:RectWithScale(CGRectMake(380, 180, 330, 40), GPCommonLayoutScaleSizeWidthIndex)];
    
    
    
    [_buttonCut setFrame:RectWithScale(CGRectMake(730, 180, 40, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelCount setFrame:RectWithScale(CGRectMake(770, 180, 100, 40), GPCommonLayoutScaleSizeWidthIndex)];
    [_buttonAdd setFrame:RectWithScale(CGRectMake(870, 180, 40, 40), GPCommonLayoutScaleSizeWidthIndex)];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        _imageViewLeft = [[UIImageView alloc]init];
        [_imageViewLeft setImage:GetImage(@"商城购物车")];
        [_imageViewLeft setContentMode:contentModeDefault];
        [_imageViewLeft setClipsToBounds:YES];
        
        _labelTitle = [[UILabelAlignToTopLeft alloc] init];
        _labelTitle.numberOfLines = 3;
        _labelTitle.lineBreakMode = LineBreakModeDefault;
        _labelTitle.textColor = kColorFontMedium;
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textAlignment = NSTextAlignmentLeft;
        [_labelTitle setFont:FontMediumWithSize(12)];
        
        _labelCount = [[UILabel alloc] init];
        _labelCount.numberOfLines = 1;
        _labelCount.lineBreakMode = LineBreakModeDefault;
        _labelCount.textColor = kColorFontMedium;
        _labelCount.backgroundColor = [UIColor clearColor];
        _labelCount.textAlignment = NSTextAlignmentCenter;
        [_labelCount setFont:FontMediumWithSize(12)];
        
        _labelPrice = [[UILabel alloc] init];
        _labelPrice.numberOfLines = 1;
        _labelPrice.lineBreakMode = LineBreakModeDefault;
        _labelPrice.textColor = rgb(255, 140, 0);
        _labelPrice.backgroundColor = [UIColor clearColor];
        _labelPrice.textAlignment = NSTextAlignmentLeft;
        [_labelPrice setFont:FontMediumWithSize(12)];
        
        
        _labelGoodsType = [[UILabelAlignToTopLeft alloc] init];
        _labelGoodsType.numberOfLines = 1;
        _labelGoodsType.lineBreakMode = LineBreakModeDefault;
        _labelGoodsType.textColor = [UIColor blackColor];
        _labelGoodsType.backgroundColor = rgb(239, 240, 241);
        _labelGoodsType.textAlignment = NSTextAlignmentLeft;
        [_labelGoodsType setFont:FontRegularWithSize(12)];
        
        _buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonSelect setImage:GetImage(@"椭圆") forState:UIControlStateNormal];
        [_buttonSelect setTitle:@"选择" forState:UIControlStateNormal];
        [_buttonSelect.titleLabel setFont:FontRegularWithSize(16)];
        [_buttonSelect setTitleColor:GPHexColor(0xFFFFFF) forState:UIControlStateNormal];
        [_buttonSelect setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        
        
        _buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonAdd setImage:GetImage(@"加") forState:UIControlStateNormal];
        [_buttonAdd setTitle:@"+" forState:UIControlStateNormal];
        [_buttonAdd.titleLabel setFont:FontRegularWithSize(16)];
        [_buttonAdd setTitleColor:GPHexColor(0xFFFFFF) forState:UIControlStateNormal];
        [_buttonAdd setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        
        _buttonCut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonCut setImage:GetImage(@"减") forState:UIControlStateNormal];
        [_buttonCut setTitle:@"-" forState:UIControlStateNormal];
        [_buttonCut.titleLabel setFont:FontRegularWithSize(16)];
        [_buttonCut setTitleColor:GPHexColor(0xFFFFFF) forState:UIControlStateNormal];
        [_buttonCut setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        
        [_buttonSelect addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonAdd addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonCut addTarget:self action:@selector(cut:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cellSetBackgroundColor(kColorCellBackground);
                
        [self.contentView addSubview:_imageViewLeft];
        [self.contentView addSubview:_labelTitle];
        [self.contentView addSubview:_labelCount];
        [self.contentView addSubview:_labelPrice];
//        [self.contentView addSubview:_labelGoodsType];
        [self.contentView addSubview:_buttonSelect];
        [self.contentView addSubview:_buttonAdd];
        [self.contentView addSubview:_buttonCut];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_buttonSelect addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonAdd addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonCut addTarget:self action:@selector(cut:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//减
- (void)cut:(UIButton *)sender {
    NSInteger count = [self.labelCount.text integerValue];
    count--;
    if (count <= 0) {
        return;
    }
    self.labelCount.text = [NSString stringWithFormat:@"%ld", (long)count];
    if (self.CutBlock) {
        self.CutBlock(self.labelCount);
    }
}

//加
- (void)add:(UIButton *)sender {
    NSInteger count = [self.labelCount.text integerValue];
    count++;
    self.labelCount.text = [NSString stringWithFormat:@"%ld", (long)count];
    if (self.AddBlock) {
        self.AddBlock(self.labelCount);
    }
}

//选中
- (void)click:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:GetImage(@"选中") forState:(UIControlStateNormal)];
    } else {
        [sender setImage:GetImage(@"椭圆") forState:(UIControlStateNormal)];
    }
    if (self.ClickRowBlock) {
        self.ClickRowBlock(sender.selected);
    }
}

- (void)setGoodsModel:(GoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    self.buttonSelect.selected = goodsModel.isSelect;
    if (goodsModel.isSelect) {
        [self.buttonSelect setImage:GetImage(@"选中") forState:(UIControlStateNormal)];
    } else {
        [self.buttonSelect setImage:GetImage(@"椭圆") forState:(UIControlStateNormal)];
    }
    
    self.labelCount.text = [NSString stringWithFormat:@"%@", goodsModel.goods_num];
    [self.imageViewLeft sd_setImageWithURL:URL(goodsModel.goods_image_url) placeholderImage:defaultImage];
    self.labelTitle.text = goodsModel.goods_name;
    self.labelPrice.text = [NSString stringWithFormat:@"%.2f元", [goodsModel.goods_price floatValue]];
    self.labelGoodsType.text = [NSString stringWithFormat:@"%@", goodsModel.goods_advword];
}


@end
