//
// Created by dkorneev on 11/4/12.
//


#import <Foundation/Foundation.h>


UIColor *UIColorMakeRGB(CGFloat red, CGFloat green, CGFloat blue);


@interface VKUtils : NSObject

+ (UILabel *)createNavigationItemTitle: (NSString *)text;

+ (void)configNavigationBar:(UINavigationBar *)navBar;


@end