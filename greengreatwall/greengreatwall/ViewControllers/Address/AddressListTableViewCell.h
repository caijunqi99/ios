//
//  AddressListTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/16.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddressListTableViewCell : UITableViewCell
@property (nonatomic, strong) void ((^btnClick)(UIButton*));

@property (nonatomic,copy)      DeliveryAddressModel    *addressModel;

@property (nonatomic,copy)      NSDictionary    *dic;
@property (nonatomic,strong)    UILabel         *labelName;
@property (nonatomic,strong)    UILabelAlignToTopLeft         *labelAddressDetail;
@property (nonatomic,strong)    UILabel         *labelMobilePhone;
@property (nonatomic,strong)    UILabel         *labelIsDefault;

@property (nonatomic,strong)    UIButton        *buttonEdit;
@end

NS_ASSUME_NONNULL_END
