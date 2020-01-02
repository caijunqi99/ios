//
//  StoreListTableViewCell.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/21.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreListTableViewCell : UITableViewCell

@property (nonatomic, strong) void ((^btnClick)(UIButton*));

@property (nonatomic,copy)      NSDictionary    *dic;
@property (nonatomic,strong)    UIView          *viewBack;
@property (nonatomic,strong)    UIView          *viewLogo;
@property (nonatomic,strong)    UIImageView     *imageViewLogo;

//@property (nonatomic,strong)    UIImageView     *imageViewLevel;
//@property (nonatomic,strong)    UIImageView     *imageViewLevelExternal;

@property (nonatomic,strong)    UIImageView     *imageViewLeft;
@property (nonatomic,strong)    UIImageView     *imageViewCenter;
@property (nonatomic,strong)    UIImageView     *imageViewRight;

@property (nonatomic,strong)    UIButton        *buttonLeft;
@property (nonatomic,strong)    UIButton        *buttonCenter;
@property (nonatomic,strong)    UIButton        *buttonRight;



@property (nonatomic,strong)    UILabel         *labelTitle;

@property (nonatomic,strong)    UILabel         *labelSales;
@property (nonatomic,strong)    UILabel         *labelStoreType;
@property (nonatomic,strong)    UIButton        *buttonEnterStore;
@property (nonatomic,strong)    CALayer         *shadowLayer;

@end

NS_ASSUME_NONNULL_END
