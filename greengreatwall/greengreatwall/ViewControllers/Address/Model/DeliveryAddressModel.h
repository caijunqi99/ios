//
//  DeliveryAddressModel.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/16.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <YYModel.h>
//#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface DeliveryAddressModel : NSObject<NSCopying,NSMutableCopying>

@property(nonatomic,strong)NSString *address_id;
@property(nonatomic,strong)NSString *member_id;
@property(nonatomic,strong)NSString *address_realname;
@property(nonatomic,strong)NSString *city_id;
@property(nonatomic,strong)NSString *area_id;
@property(nonatomic,strong)NSString *area_info;
@property(nonatomic,strong)NSString *address_detail;
@property(nonatomic,strong)NSString *address_tel_phone;
@property(nonatomic,strong)NSString *address_mob_phone;
@property(nonatomic,strong)NSString *address_is_default;
@property(nonatomic,strong)NSString *address_longitude;
@property(nonatomic,strong)NSString *address_latitude;
@property(nonatomic,strong)NSString *dlyp_id;

@end

NS_ASSUME_NONNULL_END
