//
// Created by admin on 11/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VKUtils.h"

UIColor * UIColorMakeRGB(CGFloat red, CGFloat green, CGFloat blue) {
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
}

@implementation VKUtils

+ (UILabel *)createNavigationItemTitle:(NSString *)text {
    UILabel *titleView = [[UILabel alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    titleView.font = [UIFont fontWithName:@"HelveticaNeueCyr-Medium" size:19];
    titleView.text = text;
    [titleView sizeToFit];
    return titleView;
}

@end