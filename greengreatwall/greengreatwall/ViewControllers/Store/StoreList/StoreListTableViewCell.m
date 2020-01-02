//
//  StoreListTableViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/21.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "StoreListTableViewCell.h"

@implementation StoreListTableViewCell

-(void)layoutSubviews
{
    //坐标系 540*275
    CGFloat LayoutScaleSizeWidth = self.contentView.width/540.0;
    
    
    [_imageViewLogo sd_setImageWithURL:[NSURL URLWithString:_dic[@"store_avatar"]] placeholderImage:defaultImage];
    
    if ([[NSArray arrayWithArray:_dic[@"search_list_goods"]] count]>0) {
        //        [_imageViewLeft sd_setImageWithURL:[NSURL URLWithString:_dic[@"search_list_goods"][0][@"goods_image"]] placeholderImage:defaultImage];
        
        [_buttonLeft sd_setImageWithURL:[NSURL URLWithString:_dic[@"search_list_goods"][0][@"goods_image"]] forState:UIControlStateNormal];
        [_buttonLeft setHidden: NO];
    }else{
        [_buttonLeft setHidden: YES];
    }
    if ([[NSArray arrayWithArray:_dic[@"search_list_goods"]] count]>1) {
        //        [_imageViewCenter sd_setImageWithURL:[NSURL URLWithString:_dic[@"search_list_goods"][1][@"goods_image"]] placeholderImage:defaultImage];
        [_buttonCenter sd_setImageWithURL:[NSURL URLWithString:_dic[@"search_list_goods"][1][@"goods_image"]] forState:UIControlStateNormal];
        [_buttonCenter setHidden: NO];
    }else{
        [_buttonCenter setHidden: YES];
    }
    if ([[NSArray arrayWithArray:_dic[@"search_list_goods"]] count]>2) {
        //        [_imageViewRight sd_setImageWithURL:[NSURL URLWithString:_dic[@"search_list_goods"][2][@"goods_image"]] placeholderImage:defaultImage];
        [_buttonRight sd_setImageWithURL:[NSURL URLWithString:_dic[@"search_list_goods"][2][@"goods_image"]] forState:UIControlStateNormal];
        [_buttonRight setHidden: NO];
    }else{
        [_buttonRight setHidden: YES];
    }
    
    [_imageViewLogo setFrame:RectWithScale(CGRectMake(40, 20, 65, 65), LayoutScaleSizeWidth)];
    _imageViewLogo.layer.cornerRadius = ((65.0/2.0)*(LayoutScaleSizeWidth));
    
    
    _viewLogo.frame         = RectWithScale(CGRectMake(35, 15, 75, 75), LayoutScaleSizeWidth);
    _viewLogo.layer.cornerRadius = ((75.0/2.0)*(LayoutScaleSizeWidth));
    
    [_labelTitle setText:[NSString stringWithFormat:@"%@",_dic[@"store_name"]]];
    [_labelSales setText:[NSString stringWithFormat:@"成交订单量:%@",_dic[@"num_sales_jq"]]];
    NSString *storeType = [_dic[@"is_platform_store"] integerValue]?@"自营店":@"签约店";
    [_labelStoreType setText:storeType];
    
    [_viewBack setFrame:RectWithScale(CGRectMake(15, 30, 510, 233), LayoutScaleSizeWidth)];
    
    //    [_imageViewLevel setFrame:RectWithScale(CGRectMake(35, 20, 65, 65), LayoutScaleSizeWidth)];
    //    [_imageViewLevelExternal setFrame:RectWithScale(CGRectMake(35, 20, 65, 65), LayoutScaleSizeWidth)];
    
    //    [_imageViewLeft setFrame:RectWithScale(CGRectMake(40, 110, 145, 140), LayoutScaleSizeWidth)];
    //    [_imageViewCenter setFrame:RectWithScale(CGRectMake(200, 110, 145, 140), LayoutScaleSizeWidth)];
    //    [_imageViewRight setFrame:RectWithScale(CGRectMake(360, 110, 145, 140), LayoutScaleSizeWidth)];
    
    [_buttonLeft setFrame:RectWithScale(CGRectMake(40, 110, 145, 140), LayoutScaleSizeWidth)];
    [_buttonCenter setFrame:RectWithScale(CGRectMake(200, 110, 145, 140), LayoutScaleSizeWidth)];
    [_buttonRight setFrame:RectWithScale(CGRectMake(360, 110, 145, 140), LayoutScaleSizeWidth)];
    
    [_labelTitle setFrame:RectWithScale(CGRectMake(125, 40, 175, 20), LayoutScaleSizeWidth)];
    
    [_labelSales setFrame:RectWithScale(CGRectMake(125, 70, 175, 20), LayoutScaleSizeWidth)];
    [_labelStoreType setFrame:RectWithScale(CGRectMake(300, 40, 50, 20), LayoutScaleSizeWidth)];
    [_buttonEnterStore setFrame:RectWithScale(CGRectMake(400, 50, 100, 30), LayoutScaleSizeWidth)];
    
    
    
    //    FuwenbenLabelWithFontAndColorInRange(_labelSales, FontRegularWithSize(10), GPHexColor(0x333333), NSMakeRange(0, 3));
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        _viewBack = [[UIView alloc]init];
        [_viewBack setBackgroundColor:kColorCellBackground];
        _viewBack.layer.masksToBounds = YES;
        _viewBack.clipsToBounds = YES;
        [_viewBack.layer setCornerRadius:5.0];
        
        
        _imageViewLogo = [[UIImageView alloc]init];
        [_imageViewLogo setBackgroundColor:[UIColor whiteColor]];
        [_imageViewLogo setContentMode:contentModeDefault];
        _imageViewLogo.layer.masksToBounds = YES;
        //        _imageViewLogo.layer.borderWidth = 5;
        //        _imageViewLogo.layer.borderColor = [[UIColor blueColor] CGColor];
        //        [_imageViewLogo setClipsToBounds:YES];
        
        _viewLogo = [[UIView alloc]init];
        [_viewLogo setBackgroundColor:[UIColor whiteColor]];
        // 阴影颜色
        _viewLogo.layer.shadowColor = [UIColor grayColor].CGColor;
        // 阴影偏移，默认(0, -3)
        _viewLogo.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        _viewLogo.layer.shadowOpacity = 1;
        // 阴影半径，默认3
        _viewLogo.layer.shadowRadius = 2;
        
        
        
        //        _imageViewLevel = [[UIImageView alloc]init];
        //        [_imageViewLevel setContentMode:UIViewContentModeScaleAspectFit];
        //        [_imageViewLevel setClipsToBounds:YES];
        //
        //        _imageViewLevelExternal = [[UIImageView alloc]init];
        //        [_imageViewLevelExternal setContentMode:UIViewContentModeScaleAspectFit];
        //        [_imageViewLevelExternal setClipsToBounds:YES];
        
        //        _imageViewLeft = [[UIImageView alloc]init];
        //        [_imageViewLeft setContentMode:contentModeDefault];
        //        [_imageViewLeft setClipsToBounds:YES];
        //        _imageViewCenter = [[UIImageView alloc]init];
        //        [_imageViewCenter setContentMode:contentModeDefault];
        //        [_imageViewCenter setClipsToBounds:YES];
        //        _imageViewRight = [[UIImageView alloc]init];
        //        [_imageViewRight setContentMode:contentModeDefault];
        //        [_imageViewRight setClipsToBounds:YES];
        
        
        
        _buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_buttonLeft setTitle:@"进店" forState:UIControlStateNormal];
        [_buttonLeft.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonLeft setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_buttonLeft setTag:1];
        [_buttonLeft addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        _buttonCenter = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_buttonCenter setTitle:@"进店" forState:UIControlStateNormal];
        [_buttonCenter.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonCenter setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_buttonCenter setTag:2];
        [_buttonCenter addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        _buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_buttonRight setTitle:@"进店" forState:UIControlStateNormal];
        [_buttonRight.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonRight setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_buttonRight setTag:3];
        [_buttonRight addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.numberOfLines = 2;
        _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTitle.textColor = kColorFontMedium;
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textAlignment = NSTextAlignmentLeft;
        [_labelTitle setFont:FontMediumWithSize(16)];
        
        
        
        _labelSales = [[UILabel alloc] init];
        _labelSales.numberOfLines = 1;
        _labelSales.lineBreakMode = NSLineBreakByCharWrapping;
        _labelSales.textColor = [UIColor lightGrayColor];
        _labelSales.backgroundColor = [UIColor clearColor];
        _labelSales.textAlignment = NSTextAlignmentLeft;
        [_labelSales setFont:FontMediumWithSize(12)];
        
        
        
        
        _labelStoreType = [[UILabel alloc] init];
        _labelStoreType.numberOfLines = 1;
        _labelStoreType.lineBreakMode = NSLineBreakByCharWrapping;
        _labelStoreType.textColor = [UIColor whiteColor];
        _labelStoreType.backgroundColor = [UIColor redColor];
        _labelStoreType.textAlignment = NSTextAlignmentCenter;
        [_labelStoreType setFont:FontRegularWithSize(12)];
        
        _buttonEnterStore = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_buttonEnterStore setTitle:@"进店" forState:UIControlStateNormal];
        [_buttonEnterStore.titleLabel setFont:FontRegularWithSize(12)];
        [_buttonEnterStore setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_buttonEnterStore setTag:1];
        _buttonEnterStore.layer.masksToBounds = YES;
        _buttonEnterStore.clipsToBounds = YES;
        [_buttonEnterStore.layer setCornerRadius:10.0];
        [_buttonEnterStore.layer setBorderColor:[UIColor redColor].CGColor];
        [_buttonEnterStore.layer setBorderWidth:1];
        //        [_buttonEnterStore rounded:10 width:5 color:[UIColor redColor]];
        //        [_buttonEnterStore addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonEnterStore setUserInteractionEnabled:NO];
        
        
        cellSetBackgroundColor(kColorBasic);
        
        [self.contentView addSubview:_viewBack];
        
//        [self.contentView addSubview:_imageViewLeft];
//        [self.contentView addSubview:_imageViewCenter];
//        [self.contentView addSubview:_imageViewRight];
        
        [self.contentView addSubview:_buttonLeft];
        [self.contentView addSubview:_buttonCenter];
        [self.contentView addSubview:_buttonRight];
        
        //        [self.contentView addSubview:_imageViewLevel];
        //        [self.contentView addSubview:_imageViewLevelExternal];
        [self.contentView addSubview:_viewLogo];
        
        
        [self.contentView addSubview:_imageViewLogo];
        [self.contentView addSubview:_labelTitle];
        [self.contentView addSubview:_labelSales];
        [self.contentView addSubview:_labelStoreType];
        [self.contentView addSubview:_buttonEnterStore];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_buttonLeft addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonCenter addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonRight addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonEnterStore addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
    
    if (self.btnClick) {
        self.btnClick(btn);
    }
    if ([buttonName containsString:@"日常保洁"])
    {
        
    }
    else if([buttonName containsString:@"深度保洁"])
    {
        
    }
}

@end
