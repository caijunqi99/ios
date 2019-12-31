//
//  AreaView.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/16.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol AreaSelectDelegate <NSObject>

- (void)selectIndex:(NSInteger)index atIndex:(NSInteger)atIndex;

- (void)getSelectAddressInfor:(NSString *)addressInfor;
@end
@interface AreaView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIScrollView *areaScrollView;
@property(nonatomic,strong)UIView *areaWhiteBaseView;
@property(nonatomic,strong)NSMutableArray<ProvinceModel*> *provinceArray;
@property(nonatomic,strong)NSMutableArray<CityModel*> *cityArray;
@property(nonatomic,strong)NSMutableArray<RegionModel*> *regionsArray;
@property(nonatomic,strong)id <AreaSelectDelegate> address_delegate;

- (void)showAreaView;
- (void)hidenAreaView;

@end

NS_ASSUME_NONNULL_END
