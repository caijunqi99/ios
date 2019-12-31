//
//  NoticeTableViewCell.m
//  LeJuYouJia
//
//  Created by 葛朋 on 2019/11/12.
//  Copyright © 2019 葛朋. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

-(void)layoutSubviews
{
    [_labelTitle setText:[NSString stringWithFormat:@"%@",_dic[@"from_member_name"]]];
    [_labelContent setText:[NSString stringWithFormat:@"%@",_dic[@"message_body"]]];
    
    NSString *intervalString = _dic[@"message_time"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[intervalString doubleValue]+3600*0];// 加上八小时的时间差值
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [dateFormatter stringFromDate:date];
    //GPDebugLog(@"时间戳转换为时间是 %@",string);
    
    [_labelTime setText:[NSString stringWithFormat:@"%@",string]];
    
    [_viewBack setFrame:CGRectMake(10, 10, self.contentView.width - 20, 110)];
    
    
    [_labelTime setFrame:CGRectMake(_viewBack.width - 150, 10, 140, 20)];
    
    [_labelTitle setFrame:CGRectMake(10, 10, _viewBack.width - 160, 20)];
    
    [_labelContent setFrame:CGRectMake(10, 30, _viewBack.width - 20, 60)];
    
//    FuwenbenLabelWithFontAndColorInRange(_labelContent, FontRegularWithSize(14), kColorTheme, NSMakeRange(0, 8));
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
        _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTitle.textColor = kColorFontMedium;
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textAlignment = NSTextAlignmentLeft;
        [_labelTitle setFont:FontRegularWithSize(14)];
        
        
        _labelContent = [[UILabelAlignToTopLeft alloc] init];
        _labelContent.numberOfLines = 3;
        _labelContent.lineBreakMode = NSLineBreakByCharWrapping;
        _labelContent.textColor = kColorFontMedium;
        _labelContent.backgroundColor = [UIColor clearColor];
        _labelContent.textAlignment = NSTextAlignmentLeft;
        [_labelContent setFont:FontRegularWithSize(14)];
        
        _labelTime = [[UILabel alloc] init];
        _labelTime.numberOfLines = 1;
        _labelTime.lineBreakMode = NSLineBreakByCharWrapping;
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
