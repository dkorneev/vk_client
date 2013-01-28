//
// Created by dkorneev on 11/4/12.
//


#import <Foundation/Foundation.h>

@class VKFriendInfo;


UIColor *UIColorMakeRGB(CGFloat red, CGFloat green, CGFloat blue);


@interface VKUtils : NSObject

+ (UIBarButtonItem *)createBarButton:(NSString *)title target:(id)target1 action:(SEL)action;

+ (UIBarButtonItem *)createBarItem:(VKFriendInfo *)friendInfo;


+ (UILabel *)createNavigationItemTitle: (NSString *)text;

+ (void)configNavigationBar:(UINavigationBar *)navBar;


@end