//
//  UIImageView+extension.m
//  SLYP
//
//  Created by 秦正华 on 2016/11/18.
//  Copyright © 2016年 马晓明. All rights reserved.
//

#import "UIImageView+HPExtension.h"

@implementation UIImageView (HPExtension)

+ (instancetype)initImageView:(NSString *)imagename {
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imagename]];
    image.contentMode = contentModeDefault;
    image.layer.masksToBounds = YES;
    image.clipsToBounds = YES;
    return image;
}

- (void)setImageView:(NSString *)imagename {
    
    self.image = [UIImage imageNamed:imagename];
    self.contentMode = contentModeDefault;
    self.layer.masksToBounds = YES;
}

//- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
//{
//    self.highlighted = YES;
//    //GPDebugLog(@"touchesBegan");
//    
//}
//- (void)touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
//{
//    //GPDebugLog(@"touchesMoved");
//}
//
//- (void)touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
//{
//    //GPDebugLog(@"touchesEnded");
//}
//
//- (void)touchesCancelled:(NSSet *) touches withEvent:(UIEvent *) event
//{
//    self.highlighted = NO;
//    //GPDebugLog(@"touchesCancelled");
//}


@end
