//
//  DeliveryAddressModel.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/16.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "DeliveryAddressModel.h"

@implementation DeliveryAddressModel

-(id)copyWithZone:(NSZone *)zone
{
    DeliveryAddressModel *model = [[DeliveryAddressModel alloc]init];
    model.address_id = self.address_id;
    model.member_id = self.member_id;
    model.address_realname = self.address_realname;
    model.city_id = self.city_id;
    model.area_id = self.area_id;
    model.area_info = self.area_info;
    model.address_detail = self.address_detail;
    model.address_tel_phone = self.address_tel_phone;
    model.address_mob_phone = self.address_mob_phone;
    model.address_is_default = self.address_is_default;
    model.address_longitude = self.address_longitude;
    model.address_latitude = self.address_latitude;
    model.dlyp_id = self.dlyp_id;
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    DeliveryAddressModel *model = [[DeliveryAddressModel alloc]init];
    model.address_id = self.address_id;
    model.member_id = self.member_id;
    model.address_realname = self.address_realname;
    model.city_id = self.city_id;
    model.area_id = self.area_id;
    model.area_info = self.area_info;
    model.address_detail = self.address_detail;
    model.address_tel_phone = self.address_tel_phone;
    model.address_mob_phone = self.address_mob_phone;
    model.address_is_default = self.address_is_default;
    model.address_longitude = self.address_longitude;
    model.address_latitude = self.address_latitude;
    model.dlyp_id = self.dlyp_id;
    return model;
}

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
