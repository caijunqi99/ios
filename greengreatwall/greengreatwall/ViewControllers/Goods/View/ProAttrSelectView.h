//
//  ProAttrSelectView.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/9.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProAttrSelectView;
@protocol ProAttrSelectViewDelegate <NSObject>
@optional
- (void)proAttrSelectView:(ProAttrSelectView *)view didClickSureWithAttrs:(NSMutableArray *)attrs count:(NSInteger)count;
@end
@interface ProAttrSelectView : UIView
- (instancetype)initWithData:(NSArray *)data;
- (instancetype)initWithImageUrlString:(NSString *)imageUrlString andGoodsName:(NSString *)goodsName;
/**当前选择的属性集合*/
@property (nonatomic, strong)NSMutableArray *selectedAttrs;
/**当前选择的商品数量*/
@property (nonatomic, assign)NSInteger *selectedCount;
@property (nonatomic, weak)id<ProAttrSelectViewDelegate>delegate;
- (void)show;
- (void)dismiss;
@end
//属性单元视图
@class AttrSectionView;
@protocol AttrSectionViewDelegate <NSObject>
@optional
- (void)attrSectionView:(AttrSectionView *)view didSelectedAttr:(NSString *)attr atSection:(NSInteger )section;
@end
@interface AttrSectionView : UIView
/**初始化 传入当前属性数据以及分区的号*/
- (instancetype)initWithFrame:(CGRect)frame andData:(NSDictionary *)data andSection:(NSInteger )section;
/**设置属性中的某一个属性按钮是否可用*/
- (void)setAttrEnable:(BOOL)enable withTitle:(NSString *)title;
@property (nonatomic, weak)id<AttrSectionViewDelegate>delegate;
@end
//属性按钮
@interface AttrBtn : UIButton
+ (AttrBtn *)attrBtnWithTitle:(NSString *)title;
@end
//计数视图
@interface CountView : UIView
/**当前的数量 默认为1*/
@property (nonatomic, assign)NSUInteger count;
@end
//————————————————
//版权声明：本文为CSDN博主「知己子」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
//原文链接：https://blog.csdn.net/qq_20933903/article/details/84587121
