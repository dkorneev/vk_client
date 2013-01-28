//
// Created by dkorneev on 11/4/12.
//


#import <QuartzCore/QuartzCore.h>
#import "VKUtils.h"
#import "VKFriendInfo.h"
#import "NINetworkImageView.h"
#import "UIViewAdditions.h"

UIColor * UIColorMakeRGB(CGFloat red, CGFloat green, CGFloat blue) {
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
}

@implementation VKUtils

+ (UIBarButtonItem *)createBarButton:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 67, 32)];
    [button setBackgroundImage:[UIImage imageNamed:@"back-button.png"] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeueCyr-Bold" size:12];
    [button setTitleEdgeInsets:(UIEdgeInsets){2, 7, 0, 0}];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)createBarItem:(VKFriendInfo *)friendInfo {
    NINetworkImageView *userAvatar = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [userAvatar setPathToNetworkImage:friendInfo.photo];
    userAvatar.layer.masksToBounds = YES;
    [userAvatar.layer setCornerRadius:5.0];

    UILabel *titleView = [[UILabel alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = UIColorMakeRGB(226, 232, 240);
    titleView.font = [UIFont fontWithName:@"HelveticaNeueCyr-Bold" size:11];
    titleView.text = @"онлайн";
    [titleView sizeToFit];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleView.width + userAvatar.width + 5, userAvatar.height)];

    userAvatar.center = view.center;
    userAvatar.right = view.right;
    [view addSubview:userAvatar];

    titleView.center = view.center;
    titleView.left = view.left;
    [view addSubview:titleView];

    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

+ (UILabel *)createNavigationItemTitle:(NSString *)text {
    UILabel *titleView = [[UILabel alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    titleView.font = [UIFont fontWithName:@"HelveticaNeueCyr-Bold" size:19];
    titleView.text = text;
    [titleView sizeToFit];
    return titleView;
}

+ (void)configNavigationBar:(UINavigationBar *)navBar {
    [navBar setBackgroundImage:[UIImage imageNamed:@"Header.png"] forBarMetrics:UIBarMetricsDefault];
}

@end