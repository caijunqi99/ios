//
//  XDAutoresizeLabelFlowConfig.m
//  XDAutoresizeLabelFlow
//
//  Created by Celia on 2018/4/11.
//  Copyright © 2018年 HP. All rights reserved.
//

#import "XDAutoresizeLabelFlowConfig.h"

@implementation XDAutoresizeLabelFlowConfig

+ (XDAutoresizeLabelFlowConfig *)shareConfig {
    static XDAutoresizeLabelFlowConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc]init];
    });
    return config;
}

// default

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentInsets = UIEdgeInsetsMake(GPSpacing, GPSpacing, GPSpacing, GPSpacing);
        self.lineSpace = 10;
        self.itemHeight = 25;
        self.itemSpace = 10;
        self.itemCornerRaius = 3;
        self.itemColor = GPHexColor(0xFFF7EE);
        self.itemSelectedColor = [UIColor colorWithRed:231/255.0 green:33/255.0 blue:25/255.0 alpha:1.0];
        self.textMargin = 20;
        self.textColor = kColorFontRegular;
        self.textSelectedColor = [UIColor whiteColor];
        self.textFont = FontRegularWithSize(16);
        self.backgroundColor = kColorSearchBackGround;
        self.sectionHeight = 40;
    }
    return self;
}

@end
