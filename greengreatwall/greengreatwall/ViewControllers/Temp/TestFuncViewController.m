//
//  TestFuncViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/11/28.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "TestFuncViewController.h"

@interface TestFuncViewController ()
@property(nonatomic,strong)UITextView   *textView;
@end

NSString *const stringForTest = @"开发者--Keep--1990";

CGFloat const sizeForFontTest = 15;

@implementation TestFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showStringWithAllFonts:[self AttributedStringInAllFontsInSystemWithString:stringForTest]];
}


-(UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
    }
    return _textView;
}

//打印系统自带字体
-(void)showStringWithAllFonts:(NSMutableAttributedString*)StringWithAllFonts
{
    NSString *string = StringWithAllFonts.string;
    CGFloat height = [string heightWithFontSize:sizeForFontTest width:self.textView.width-10];
    height = height>(GPScreenHeight - kNavBarAndStatusBarHeight - 50)?(GPScreenHeight - kNavBarAndStatusBarHeight - 50):height;
    
    [self.view addSubview:self.textView];
    _textView.frame = CGRectMake(10, 10, GPScreenWidth - 20, 200);
    _textView.textColor = [UIColor blackColor];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.editable = NO;
    [_textView setHeight:height];
    _textView.attributedText = StringWithAllFonts;
}

-(NSMutableAttributedString*)AttributedStringInAllFontsInSystemWithString:(NSString*)string
{

    NSMutableAttributedString *fontStr = [NSMutableAttributedString new];

    for(NSString * familyName in [UIFont familyNames]){
//        //GPDebugLog(@"字体族科名 = %@",familyName); // 输出字体族科名字
        NSAttributedString *aAttrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"字体族:%@\n", familyName] attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:sizeForFontTest], NSForegroundColorAttributeName: [UIColor redColor] }];
        
        [fontStr appendAttributedString:aAttrStr];
        
        
        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName]){
//            //GPDebugLog(@"\t%@",fontName); // 输出字体族科下字样名字
            
            NSAttributedString *bAttrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:\t", fontName] attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:sizeForFontTest] }];
            [fontStr appendAttributedString:bAttrStr];
            
            
            NSAttributedString *cAttrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", string] attributes:@{ NSFontAttributeName: [UIFont fontWithName:fontName size:sizeForFontTest] }];
            [fontStr appendAttributedString:cAttrStr];
        }
    }
    return fontStr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
