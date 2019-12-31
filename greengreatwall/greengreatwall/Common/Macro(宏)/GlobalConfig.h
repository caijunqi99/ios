//
//  GlobalConfig.h
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#ifndef GlobalConfig_h
#define GlobalConfig_h


///** 主色 */
//#define kCOLOR_M                   [UIColor hex:@"1296db"]
//#define kCOLOR_Red_ScrollTitle     [UIColor hex:@"c9171e"]
//#define kCOLOR_Gray_ScrollTitle    [UIColor hex:@"424242"]
//
#define kCOLOR_Gray_TableBG        [UIColor hex:@"f2f2f2"]

#define kCOLOR_LINE        [UIColor hex:@"f0f0f0"]
//
//#define kCOLOR_imageBG        [UIColor hex:@"f2f2f2"]
//
//
///** 圆形占位图 */
//#define kPLACEHOLDER_IMAGE_ROUND @"wode"
//#define kIMAGE_PLACEHOLDER       @""
//
////比例 以iPhone6 为基准
//#define kRatio GPScreenWidth/375
//
////按比例适配
//#define kFit(num)                 kRatio * (num)
//
///** 图文图片比例 */
//#define kIMAGE_S1 1.33      //列表图宽高比
//#define kIMAGE_S2 1.78      //列表图宽高比
//
//
///** 文件路径 */
//#define SpecialFilePath  [HPPathDocument stringByAppendingString:@"/studyDownload/topic/"]
//
//
///** 发送通知 字段 */
//#define HomeCanLoadData      @"HomeCanLoadData"
//
//
//#define LeftNavigationItem  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];\
//    [backButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];\
//    [backButton addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];\
//    [backButton sizeToFit];\
//    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);\
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//
//
//#define kFONT_SCALE    ({ CGFloat fontS = 1.0;\
//                        if (IS_IPHONE_4 || IS_IPHONE_5) {\
//                            fontS = 0.92;\
//                        }else if (IS_IPHONE_6) {\
//                            fontS = 1.0;\
//                        }else if (IS_IPHONE_6_PLUS) {\
//                            fontS = 1.0;\
//                        }\
//                        (fontS);\
//                        })


#endif /* GlobalConfig_h */
