//
//  FundpredepositTableViewCell.m
//  greengreatwall
//
//  Created by 葛朋 on 2020/1/2.
//  Copyright © 2020 guocaiduigong. All rights reserved.
//

#import "FundpredepositTableViewCell.h"

@implementation FundpredepositTableViewCell

-(void)layoutSubviews
{
    [_labelTime setText:[NSString stringWithFormat:@"%@",_dic[@"lg_add_time_text"]]];
    [_labelDescribe setText:[NSString stringWithFormat:@"%@",_dic[@"lg_desc"]]];
//    [_labellevel setText:[NSString stringWithFormat:@"%@",_dic[@"level"]]];
//    [_labeladdtime setText:[NSString stringWithFormat:@"%@",_dic[@"member_addtime"]]];
    
    
    [_labelTime setFrame:RectWithScale(CGRectMake(40, 20, 240, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelTime setFont:FontMediumWithSize(16)];
    
    [_labelDescribe setFrame:RectWithScale(CGRectMake(320, 20, 700, 50), GPCommonLayoutScaleSizeWidthIndex)];
    [_labelDescribe setFont:FontRegularWithSize(16)];
    
//    [_labellevel setFrame:RectWithScale(CGRectMake(500, 10, 100, 50), GPCommonLayoutScaleSizeWidthIndex)];
//    [_labellevel setFont:FontRegularWithSize(16)];
//
//    [_labeladdtime setFrame:RectWithScale(CGRectMake(650, 10, 350, 50), GPCommonLayoutScaleSizeWidthIndex)];
//    [_labeladdtime setFont:FontRegularWithSize(16)];
    
//    FuwenbenLabelWithFontAndColorInRange(_labelDescribe, FontMediumWithSize(16), GPHexColor(0xEA5951), NSMakeRange(0, 2));
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        _labelTime = [[UILabel alloc] init];
        _labelTime.numberOfLines = 1;
        _labelTime.lineBreakMode = LineBreakModeDefault;
        _labelTime.textColor = [UIColor grayColor];
        _labelTime.backgroundColor = [UIColor clearColor];
        _labelTime.textAlignment = NSTextAlignmentLeft;
        
        _labelDescribe = [[UILabel alloc] init];
        _labelDescribe.numberOfLines = 1;
        _labelDescribe.lineBreakMode = LineBreakModeDefault;
        _labelDescribe.textColor = [UIColor grayColor];
        _labelDescribe.backgroundColor = [UIColor clearColor];
        _labelDescribe.textAlignment = NSTextAlignmentRight;
        
//        _labellevel = [[UILabel alloc] init];
//        _labellevel.numberOfLines = 1;
//        _labellevel.lineBreakMode = LineBreakModeDefault;
//        _labellevel.textColor = [UIColor blackColor];
//        _labellevel.backgroundColor = [UIColor clearColor];
//        _labellevel.textAlignment = NSTextAlignmentCenter;
//
//        _labeladdtime = [[UILabel alloc] init];
//        _labeladdtime.numberOfLines = 1;
//        _labeladdtime.lineBreakMode = LineBreakModeDefault;
//        _labeladdtime.textColor = [UIColor blackColor];
//        _labeladdtime.backgroundColor = [UIColor clearColor];
//        _labeladdtime.textAlignment = NSTextAlignmentCenter;
        
        
        cellSetBackgroundColor(kColorCellBackground);
        
        [self.contentView addSubview:_labelTime];
        [self.contentView addSubview:_labelDescribe];
//        [self.contentView addSubview:_labellevel];
//        [self.contentView addSubview:_labeladdtime];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
