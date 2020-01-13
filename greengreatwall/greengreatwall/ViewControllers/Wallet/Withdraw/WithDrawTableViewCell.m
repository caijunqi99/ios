//
//  WithDrawTableViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/5.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "WithDrawTableViewCell.h"

@implementation WithDrawTableViewCell

-(void)layoutSubviews
{
    [_labelTitle setText:[NSString stringWithFormat:@"提现金额:%@",_dic[@"pdc_amount"]]];
    [_labelContent setText:[NSString stringWithFormat:@"状态:%@",_dic[@"pdc_payment_state_text"]]];
    
    [_labelTime setText:[NSString stringWithFormat:@"申请时间:%@",_dic[@"pdc_add_time_text"]]];
    
    [_viewBack setFrame:CGRectMake(10, 5, self.contentView.width - 20, 70)];
    
    
    [_labelTime setFrame:CGRectMake(160, 10, _viewBack.width - 170, 20)];
    
    [_labelTitle setFrame:CGRectMake(10, 10, 150, 20)];
    
    [_labelContent setFrame:CGRectMake(10, 40, _viewBack.width - 20, 20)];
    
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
        
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.numberOfLines = 1;
        _labelTitle.lineBreakMode = LineBreakModeDefault;
        _labelTitle.textColor = kColorFontMedium;
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textAlignment = NSTextAlignmentLeft;
        [_labelTitle setFont:FontRegularWithSize(14)];
        
        
        _labelContent = [[UILabelAlignToTopLeft alloc] init];
        _labelContent.numberOfLines = 3;
        _labelContent.lineBreakMode = LineBreakModeDefault;
        _labelContent.textColor = kColorFontMedium;
        _labelContent.backgroundColor = [UIColor clearColor];
        _labelContent.textAlignment = NSTextAlignmentLeft;
        [_labelContent setFont:FontRegularWithSize(14)];
        
        _labelTime = [[UILabel alloc] init];
        _labelTime.numberOfLines = 1;
        _labelTime.lineBreakMode = LineBreakModeDefault;
        _labelTime.textColor = kColorFontMedium;
        _labelTime.backgroundColor = [UIColor clearColor];
        _labelTime.textAlignment = NSTextAlignmentRight;
        [_labelTime setFont:FontRegularWithSize(14)];
        
        cellSetBackgroundColor(kColorBasic);
        
        [self.contentView addSubview:_viewBack];
        
        [_viewBack addSubview:_labelTitle];
        [_viewBack addSubview:_labelContent];
        [_viewBack addSubview:_labelTime];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
