//
//  AppDelegate.h
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/18.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

API_AVAILABLE(ios(10.0))
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic,strong) UIWindow *window;
- (void)saveContext;

+ (NSString*)deviceVersion;


@end

