//
//  AreaView.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/16.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "AreaView.h"

#define kDistanceBottomToTop        150

@implementation AreaView
{
    UIView *blackBaseView;
    CGFloat btn1Height;
    CGFloat btn2Height;
    CGFloat btn3Height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
        _provinceArray = [[NSMutableArray alloc]init];
        _cityArray = [[NSMutableArray alloc]init];
        _regionsArray = [[NSMutableArray alloc]init];
        
        [self creatBaseUI];
    }
    return self;
}


- (void)creatBaseUI
{
    blackBaseView = [[UIView alloc]initWithFrame:self.bounds];
    blackBaseView.backgroundColor = [UIColor blackColor];
    blackBaseView.alpha = 0;
    [self addSubview:blackBaseView];
    
    _areaWhiteBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, GPScreenHeight, GPScreenWidth, GPScreenHeight - kDistanceBottomToTop)];
    _areaWhiteBaseView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_areaWhiteBaseView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth, 50)];
    titleLabel.text = @"所在地";
    titleLabel.textColor = rgb(0, 0, 34);
    titleLabel.font = FontMediumWithSize(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_areaWhiteBaseView addSubview:titleLabel];
    
    for (int i = 0; i < 3; i++) {
        UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        areaBtn.frame = CGRectMake(80 * i, 50, 80, 28);
        [areaBtn setTitleColor:rgb(34, 34, 34) forState:UIControlStateNormal];
        areaBtn.tag = 100 + i;
        [areaBtn setTitle:@"" forState:UIControlStateNormal];
        [areaBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        areaBtn.userInteractionEnabled = NO;
        [_areaWhiteBaseView addSubview:areaBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(80 * i + 10, 78, 60, 2)];
        lineView.backgroundColor = rgb(204, 54, 60);
        [_areaWhiteBaseView addSubview:lineView];
        lineView.tag = 300 + i;
        lineView.hidden = YES;
        if (i == 0) {
            areaBtn.userInteractionEnabled = YES;
            [areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [areaBtn setTitleColor:rgb(204, 54, 60) forState:UIControlStateNormal];
            lineView.hidden = NO;
        }
    }
    
    _areaScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, GPScreenWidth, _areaWhiteBaseView.height - 80)];
    _areaScrollView.delegate = self;
    _areaScrollView.contentSize = CGSizeMake(GPScreenWidth, 0);
    _areaScrollView.pagingEnabled = YES;
    _areaScrollView.showsVerticalScrollIndicator = NO;
    _areaScrollView.showsHorizontalScrollIndicator = NO;
    
    [_areaWhiteBaseView addSubview:_areaScrollView];

    for (int i = 0; i < 3; i++) {
        UITableView *area_tableView = [[UITableView alloc]initWithFrame:CGRectMake(GPScreenWidth * i, 0, GPScreenWidth, _areaScrollView.height) style:UITableViewStylePlain];
        area_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        area_tableView.delegate = self;
        area_tableView.dataSource = self;
        area_tableView.tag = 200 + i;
        [_areaScrollView addSubview:area_tableView];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHidenGes)];
    [blackBaseView addGestureRecognizer:tap];
}
#pragma mark - tapHidenGes
- (void)tapHidenGes
{
    [self hidenAreaView];
}
#pragma mark - areaBtnAction
- (void)areaBtnAction:(UIButton *)btn
{
    for (UIView *view in _areaWhiteBaseView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    UIView *lineView = [_areaWhiteBaseView viewWithTag:300 + btn.tag - 100];
    lineView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self->_areaScrollView.contentOffset = CGPointMake(GPScreenWidth * (btn.tag - 100), 0);
    }];
}
- (void)setProvinceArray:(NSMutableArray<ProvinceModel*> *)provinceArray
{
    _provinceArray = provinceArray;
    UITableView *tableView = [_areaScrollView viewWithTag:200];
    tableView.contentSize =  CGSizeMake(provinceArray.count*44, 0);
    [tableView reloadData];
}
- (void)setCityArray:(NSMutableArray<CityModel*> *)cityArray
{
    _cityArray = cityArray;
    UITableView *tableView = [_areaScrollView viewWithTag:201];
    tableView.contentSize =  CGSizeMake(cityArray.count*44, 0);
    [tableView reloadData];
    _areaScrollView.contentSize = CGSizeMake(GPScreenWidth * 2, _areaScrollView.height);
    [UIView animateWithDuration:0.5 animations:^{
        self->_areaScrollView.contentOffset = CGPointMake(GPScreenWidth, 0);
    }];
}
- (void)setRegionsArray:(NSMutableArray<RegionModel*> *)regionsArray
{
    _regionsArray = regionsArray;
    UITableView *tableView = [_areaScrollView viewWithTag:202];
    tableView.contentSize =  CGSizeMake(regionsArray.count*44, 0);
    [tableView reloadData];
    _areaScrollView.contentSize = CGSizeMake(GPScreenWidth * 3, _areaScrollView.height);
    [UIView animateWithDuration:0.5 animations:^{
        self->_areaScrollView.contentOffset = CGPointMake(GPScreenWidth * 2 , 0);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag - 200) {
        case 0:
        {
            return _provinceArray.count;
        }
            break;
        case 1:
        {
            return _cityArray.count;
        }
            break;
        case 2:
        {
            return _regionsArray.count;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"area_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"area_cell"];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = rgb(255,238,238);
    cell.textLabel.highlightedTextColor = rgb(204, 54, 60);
    switch (tableView.tag - 200) {
        case 0:
        {
            ProvinceModel *addressAreaModel = _provinceArray[indexPath.row];
            cell.textLabel.text = addressAreaModel.area_name;
            cell.textLabel.font = FontMediumWithSize(14);
            cell.textLabel.textColor = rgb(102, 102, 102);
        }
            break;
        case 1:
        {
            CityModel *addressAreaModel = _cityArray[indexPath.row];
            cell.textLabel.text = addressAreaModel.area_name;
            cell.textLabel.font = FontMediumWithSize(14);
            cell.textLabel.textColor = rgb(102, 102, 102);
        }
            break;
        case 2:
        {
            RegionModel *addressAreaModel = _regionsArray[indexPath.row];
            cell.textLabel.text = addressAreaModel.area_name;
            cell.textLabel.font = FontMediumWithSize(14);
            cell.textLabel.textColor = rgb(102, 102, 102);
        }
            break;
        default:
            break;
    }

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *btn1 = [_areaWhiteBaseView viewWithTag:100];
    UIButton *btn2 = [_areaWhiteBaseView viewWithTag:101];
    UIButton *btn3 = [_areaWhiteBaseView viewWithTag:102];
    
    for (UIView *view in _areaWhiteBaseView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    
    UIView *lineView1 = [_areaWhiteBaseView viewWithTag:300];
    UIView *lineView2 = [_areaWhiteBaseView viewWithTag:301];
    UIView *lineView3 = [_areaWhiteBaseView viewWithTag:302];
    switch (tableView.tag - 200) {
        case 0:
        {
            ProvinceModel *addressAreaModel = _provinceArray[indexPath.row];
            btn1Height = [AreaView getLabelWidth:addressAreaModel.area_name font:14 height:28] + 20;
            [btn1 setTitle:addressAreaModel.area_name forState:UIControlStateNormal];
            [btn1 setTitleColor:rgb(34, 34, 34) forState:UIControlStateNormal];
            btn1.frame = CGRectMake(0, 50, btn1Height, 28);
            btn2.frame = CGRectMake(btn1Height, 50, 80, 28);
            btn1.userInteractionEnabled = YES;
            btn2.userInteractionEnabled = YES;
            btn3.userInteractionEnabled = NO;
            [btn2 setTitle:@"请选择" forState:UIControlStateNormal];
            [btn2 setTitleColor:rgb(204, 54, 60) forState:UIControlStateNormal];
            [btn3 setTitle:@"" forState:UIControlStateNormal];

            lineView2.hidden = NO;
            lineView1.frame = CGRectMake(10, 78, btn1Height - 20, 2);
            lineView2.frame = CGRectMake(btn1Height + 10, 78, 80 - 20, 2);
            if ([self.address_delegate respondsToSelector:@selector(selectIndex:atIndex:)]) {
                [self.address_delegate selectIndex:indexPath.row atIndex:1];
            }
        }
            break;
        case 1:
        {
            CityModel *addressAreaModel = _cityArray[indexPath.row];
            btn2Height = [AreaView getLabelWidth:addressAreaModel.area_name font:14 height:28] + 20;
            [btn2 setTitle:addressAreaModel.area_name forState:UIControlStateNormal];
            [btn2 setTitleColor:rgb(34, 34, 34) forState:UIControlStateNormal];
            [btn3 setTitle:@"请选择" forState:UIControlStateNormal];
            [btn3 setTitleColor:rgb(204, 54, 60) forState:UIControlStateNormal];
            lineView3.hidden = NO;
            lineView2.frame = CGRectMake(btn1Height + 10, 78, btn2Height - 20, 2);
            lineView3.frame = CGRectMake(btn1Height + btn2Height + 10, 78, 80 - 20, 2);
            btn3.userInteractionEnabled = YES;
            btn2.frame = CGRectMake(btn1Height, 50, btn2Height, 28);
            btn3.frame = CGRectMake(btn1Height + btn2Height, 50, 80, 28);
            

            if ([self.address_delegate respondsToSelector:@selector(selectIndex:atIndex:)]) {
                [self.address_delegate selectIndex:indexPath.row atIndex:2];
            }
        }
            break;
        case 2:
        {
            RegionModel *addressAreaModel = _regionsArray[indexPath.row];
            btn3Height = [AreaView getLabelWidth:addressAreaModel.area_name font:14 height:28] + 20;
            [btn3 setTitle:addressAreaModel.area_name forState:UIControlStateNormal];
            [btn3 setTitleColor:rgb(34, 34, 34) forState:UIControlStateNormal];
            lineView3.hidden = NO;
            if (btn1Height + btn2Height + btn3Height > 375) {
                btn3Height = 375 - (btn1Height + btn2Height);
            }
            lineView3.frame = CGRectMake(btn1Height + btn2Height + 10, 78, btn3Height - 20, 2);
            btn3.frame = CGRectMake(btn1Height + btn2Height, 50, btn3Height, 28);
            if ([self.address_delegate respondsToSelector:@selector(selectIndex:atIndex:)]) {
                [self.address_delegate selectIndex:indexPath.row atIndex:3];
            }
            [self hidenAreaView];
        }
            break;
        default:
            break;
    }

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _areaScrollView) {
        
        for (UIView *view in _areaWhiteBaseView.subviews) {
            if (view.tag >= 300) {
                view.hidden = YES;
            }
        }
        
        UIView *lineView = [_areaWhiteBaseView viewWithTag:(300 + (scrollView.contentOffset.x / GPScreenWidth))];
        lineView.hidden = NO;
    }
}
#pragma mark - showAreaView
- (void)showAreaView
{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self->blackBaseView.alpha = 0.6;
        self->_areaWhiteBaseView.frame = CGRectMake(0, kDistanceBottomToTop, GPScreenWidth, GPScreenHeight - kDistanceBottomToTop);
    }];
}

#pragma mark - hidenAreaView
- (void)hidenAreaView
{
    UIButton *btn1 = [_areaWhiteBaseView viewWithTag:100];
    UIButton *btn2 = [_areaWhiteBaseView viewWithTag:101];
    UIButton *btn3 = [_areaWhiteBaseView viewWithTag:102];

    [UIView animateWithDuration:0.25 animations:^{
        self->blackBaseView.alpha = 0;
        self->_areaWhiteBaseView.frame = CGRectMake(0, GPScreenHeight, GPScreenWidth, GPScreenHeight - kDistanceBottomToTop);
    }completion:^(BOOL finished) {
        self.hidden = YES;
        if ([self.address_delegate respondsToSelector:@selector(getSelectAddressInfor:)]) {
            [self.address_delegate getSelectAddressInfor:[NSString stringWithFormat:@"%@ %@ %@",btn1.titleLabel.text,StringNullOrNot(btn2.titleLabel.text),StringNullOrNot(btn3.titleLabel.text)]];
        }
    }];
}
+ (CGFloat)getLabelWidth:(NSString *)textStr font:(CGFloat)fontSize height:(CGFloat)labelHeight
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    paraStyle.lineBreakMode = LineBreakModeDefault;
    NSDictionary *attribute = @{NSFontAttributeName: FontMediumWithSize(fontSize),NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [textStr boundingRectWithSize:CGSizeMake(1000, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return size.width;
}


@end
