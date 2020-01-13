//
//  AddressListTableViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/16.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "AddressListTableViewCell.h"

@implementation AddressListTableViewCell

-(void)layoutSubviews
{
    
    [_labelName setText:[NSString stringWithFormat:@"%@",_addressModel.address_realname]];
    
    [_labelMobilePhone setText:[NSString stringWithFormat:@"%@",_addressModel.address_mob_phone]];
    
    [_labelAddressDetail setText:[NSString stringWithFormat:@"%@ %@",_addressModel.area_info,_addressModel.address_detail]];
    
    
    
    
    
    [_labelName setFrame:CGRectMake(10, 20, 80, 30)];
    
    [_labelMobilePhone setFrame:CGRectMake(100, 20, self.contentView.width - 170, 30)];
    [_labelAddressDetail setFrame:CGRectMake(10, 50, self.contentView.width - 80, 40)];
    
    [_labelIsDefault setFrame:CGRectMake(self.contentView.width - 70, 20, 60, 30)];
    [_labelIsDefault rounded:5];
    
    [_buttonEdit setFrame:CGRectMake(self.contentView.width - 50, 50, 40, 40)];
    
    if ([_addressModel.address_is_default isEqualToString:@"1"]) {
        //GPDebugLog(@"1");
        [_labelIsDefault setHidden:NO];
    }
    else
    {
        //GPDebugLog(@"0");
        [_labelIsDefault setHidden:YES];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        
        _labelName = [[UILabel alloc] init];
        _labelName.numberOfLines = 1;
        _labelName.lineBreakMode = LineBreakModeDefault;
        _labelName.textColor = kColorFontMedium;
        _labelName.backgroundColor = [UIColor clearColor];
        _labelName.textAlignment = NSTextAlignmentLeft;
        [_labelName setFont:FontMediumWithSize(16)];
        
        _labelMobilePhone = [[UILabel alloc] init];
        _labelMobilePhone.numberOfLines = 1;
        _labelMobilePhone.lineBreakMode = LineBreakModeDefault;
        _labelMobilePhone.textColor = kColorFontMedium;
        _labelMobilePhone.backgroundColor = [UIColor clearColor];
        _labelMobilePhone.textAlignment = NSTextAlignmentLeft;
        [_labelMobilePhone setFont:FontMediumWithSize(16)];
        
        _labelAddressDetail = [[UILabelAlignToTopLeft alloc] init];
        _labelAddressDetail.numberOfLines = 2;
        _labelAddressDetail.lineBreakMode = LineBreakModeDefault;
        _labelAddressDetail.textColor = [UIColor grayColor];
        _labelAddressDetail.backgroundColor = [UIColor clearColor];
        _labelAddressDetail.textAlignment = NSTextAlignmentLeft;
        [_labelAddressDetail setFont:FontMediumWithSize(16)];
        
        
        _labelIsDefault = [[UILabel alloc] init];
        _labelIsDefault.numberOfLines = 1;
        _labelIsDefault.lineBreakMode = LineBreakModeDefault;
        _labelIsDefault.textColor = [UIColor whiteColor];
        _labelIsDefault.backgroundColor = kColorTheme;
        _labelIsDefault.textAlignment = NSTextAlignmentCenter;
        [_labelIsDefault setFont:FontRegularWithSize(16)];
        [_labelIsDefault setText:@"默认"];
        
        
        
        _buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonEdit setImage:GetImage(@"编辑拷贝") forState:UIControlStateNormal];
        [_buttonEdit setTag:3];
        [_buttonEdit addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        cellSetBackgroundColor(kColorCellBackground);
                
        [self.contentView addSubview:_labelName];
        [self.contentView addSubview:_labelMobilePhone];
        [self.contentView addSubview:_labelAddressDetail];
        [self.contentView addSubview:_labelIsDefault];
        [self.contentView addSubview:_buttonEdit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_buttonEdit addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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

