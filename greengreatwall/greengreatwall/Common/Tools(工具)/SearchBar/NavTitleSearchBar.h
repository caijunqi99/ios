//
//  NavTitleSearchBar.h
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XDSearchBarViewDelegate <NSObject>
- (void)XDSearchBarViewShouldReturn:(NSString *)keyword;
- (BOOL)XDSearchBarViewShouldBeginEditing:(UITextField *)textField;
@end


@interface NavTitleSearchBar : UISearchBar
-(instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, weak) id <XDSearchBarViewDelegate>searchDelegate;

@end

NS_ASSUME_NONNULL_END
