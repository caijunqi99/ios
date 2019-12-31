//
//  TeamTableViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/30.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "TeamTableViewCell.h"

@implementation TeamTableViewCell

-(void)layoutSubviews
{
    [_labelMobile setText:[NSString stringWithFormat:@"%@",_dic[@"member_mobile"]]];
    [_labelexppoints setText:[NSString stringWithFormat:@"%@",_dic[@"member_exppoints"]]];
    [_labellevel setText:[NSString stringWithFormat:@"%@",_dic[@"level"]]];
    [_labeladdtime setText:[NSString stringWithFormat:@"%@",_dic[@"member_addtime"]]];
    
    
    [_labelMobile setFrame:RectWithScale(CGRectMake(40, 10, 240, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelMobile setFont:FontMediumWithSize(16)];
    
    [_labelexppoints setFrame:RectWithScale(CGRectMake(320, 10, 150, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelexppoints setFont:FontRegularWithSize(16)];
    
    [_labellevel setFrame:RectWithScale(CGRectMake(500, 10, 100, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_labellevel setFont:FontRegularWithSize(16)];
    
    [_labeladdtime setFrame:RectWithScale(CGRectMake(650, 10, 350, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_labeladdtime setFont:FontRegularWithSize(16)];
    
//    FuwenbenLabelWithFontAndColorInRange(_labelexppoints, FontMediumWithSize(16), GPHexColor(0xEA5951), NSMakeRange(0, 2));
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        _labelMobile = [[UILabel alloc] init];
        _labelMobile.numberOfLines = 1;
        _labelMobile.lineBreakMode = NSLineBreakByCharWrapping;
        _labelMobile.textColor = kColorFontMedium;
        _labelMobile.backgroundColor = [UIColor clearColor];
        _labelMobile.textAlignment = NSTextAlignmentCenter;
        
        _labelexppoints = [[UILabel alloc] init];
        _labelexppoints.numberOfLines = 1;
        _labelexppoints.lineBreakMode = NSLineBreakByCharWrapping;
        _labelexppoints.textColor = [UIColor blackColor];
        _labelexppoints.backgroundColor = [UIColor clearColor];
        _labelexppoints.textAlignment = NSTextAlignmentCenter;
        
        _labellevel = [[UILabel alloc] init];
        _labellevel.numberOfLines = 1;
        _labellevel.lineBreakMode = NSLineBreakByCharWrapping;
        _labellevel.textColor = [UIColor blackColor];
        _labellevel.backgroundColor = [UIColor clearColor];
        _labellevel.textAlignment = NSTextAlignmentCenter;
        
        _labeladdtime = [[UILabel alloc] init];
        _labeladdtime.numberOfLines = 1;
        _labeladdtime.lineBreakMode = NSLineBreakByCharWrapping;
        _labeladdtime.textColor = [UIColor blackColor];
        _labeladdtime.backgroundColor = [UIColor clearColor];
        _labeladdtime.textAlignment = NSTextAlignmentCenter;
        
        
        cellSetBackgroundColor(kColorCellBackground);
        
        [self.contentView addSubview:_labelMobile];
        [self.contentView addSubview:_labelexppoints];
        [self.contentView addSubview:_labellevel];
        [self.contentView addSubview:_labeladdtime];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
