//
//  ShoppingCartModel.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/3.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsModel;
@interface StoreModel : NSObject

@property (nonatomic, strong) NSArray *goods;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, copy) NSString *store_id;



@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, assign) BOOL isSelect;

@end



@interface GoodsModel : NSObject

@property (nonatomic, copy) NSString *goods_num;
@property (nonatomic, copy) NSString *goods_image;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *goods_image_url;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_advword;

@property (nonatomic, copy) NSString *cart_id;


@property (nonatomic, assign) BOOL isSelect;

/*
@property (nonatomic, copy) NSString *goods_commonid;
@property (nonatomic, copy) NSString *gc_id;
@property (nonatomic, copy) NSString *gc_id_1;
@property (nonatomic, copy) NSString *gc_id_2;
@property (nonatomic, copy) NSString *gc_id_3;
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *goods_promotion_type;
@property (nonatomic, copy) NSString *goods_serial;
@property (nonatomic, copy) NSString *goods_storage_alarm;
@property (nonatomic, copy) NSString *goods_click;
@property (nonatomic, copy) NSString *goods_salenum;
@property (nonatomic, copy) NSString *goods_collect;
@property (nonatomic, copy) NSString *goods_spec;
@property (nonatomic, copy) NSString *goods_storage;
@property (nonatomic, copy) NSString *goods_state;
@property (nonatomic, copy) NSString *goods_verify;
@property (nonatomic, copy) NSString *goods_addtime;
@property (nonatomic, copy) NSString *goods_edittime;
@property (nonatomic, copy) NSString *areaid_1;
@property (nonatomic, copy) NSString *areaid_2;
@property (nonatomic, copy) NSString *region_id;
@property (nonatomic, copy) NSString *color_id;
@property (nonatomic, copy) NSString *transport_id;
@property (nonatomic, copy) NSString *goods_freight;
@property (nonatomic, copy) NSString *goods_vat;
@property (nonatomic, copy) NSString *goods_commend;
@property (nonatomic, copy) NSString *goods_stcids;
@property (nonatomic, copy) NSString *evaluation_good_star;
@property (nonatomic, copy) NSString *evaluation_count;
@property (nonatomic, copy) NSString *is_virtual;
@property (nonatomic, copy) NSString *virtual_indate;
@property (nonatomic, copy) NSString *virtual_limit;
@property (nonatomic, copy) NSString *virtual_invalid_refund;
@property (nonatomic, copy) NSString *is_goodsfcode;
@property (nonatomic, copy) NSString *is_appoint;
@property (nonatomic, copy) NSString *is_presell;
@property (nonatomic, copy) NSString *is_have_gift;
@property (nonatomic, copy) NSString *is_platform_store;
@property (nonatomic, copy) NSString *goods_mgdiscount;
@property (nonatomic, copy) NSString *groupbuy_info;
@property (nonatomic, copy) NSString *pintuan_info;
@property (nonatomic, copy) NSString *bargain_info;
@property (nonatomic, copy) NSString *xianshi_info;
@property (nonatomic, copy) NSString *mgdiscount_info;
@property (nonatomic, copy) NSString *gift_list;

@property (nonatomic, copy) NSString *goods_image;
@property (nonatomic, copy) NSString *goods_promotion_price;
@property (nonatomic, copy) NSString *goods_marketprice;
 @property (nonatomic, copy) NSString *store_id;
 @property (nonatomic, copy) NSString *store_name;
*/


@end

NS_ASSUME_NONNULL_END
