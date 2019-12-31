//
//  AreaModel.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/17.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

@end

@implementation ProvinceModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.citysArray = [NSMutableArray new];
    }
    return self;
}

-(void)setArea_list:(NSMutableArray<CityModel *> *)area_list{
    _area_list = area_list;
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary *dic in area_list) {
        CityModel *model = [[CityModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [tempArray addObject:model];
    }
    self.citysArray = [NSMutableArray arrayWithArray: tempArray];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end

@implementation CityModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.regionsArray = [NSMutableArray new];
    }
    return self;
}

-(void)setArea_list:(NSMutableArray<RegionModel *> *)area_list{
    _area_list = area_list;
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary *dic in area_list) {
        RegionModel *model = [[RegionModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [tempArray addObject:model];
    }
    self.regionsArray = [NSMutableArray arrayWithArray: tempArray];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation RegionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
