//
//  AreaModel.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/17.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AreaModel : NSObject

@end

@class CityModel;
@interface ProvinceModel : NSObject

@property (nonatomic, strong) NSMutableArray<CityModel*> *area_list;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *area_id;

@property (nonatomic, strong) NSMutableArray *citysArray;

@end


@class RegionModel;
@interface CityModel : NSObject

@property (nonatomic, strong) NSMutableArray<RegionModel*> *area_list;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *area_id;

@property (nonatomic, strong) NSMutableArray *regionsArray;

@end

@interface RegionModel : NSObject

@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *area_id;

@end

NS_ASSUME_NONNULL_END
