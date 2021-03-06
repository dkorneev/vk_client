//
// Created by dkorneev on 11/25/12.
//

#import <QuartzCore/QuartzCore.h>
#import "VKSettingsController.h"
#import "VKUtils.h"
#import "NINetworkImageView.h"
#import "VKUsersService.h"
#import "VKFriendInfo.h"
#import "UIViewAdditions.h"
#import "VKWebViewController.h"
#import "VKDialogsController.h"
#import "VKAppDelegate.h"

@interface VKSettingsController ()
@property(nonatomic, strong) NINetworkImageView *avatar;
@property(nonatomic, strong) UILabel *titleView;
@property(nonatomic, strong) VKUsersService *userService;
@property(nonatomic, strong) VKFriendInfo *info;
@end

@implementation VKSettingsController

- (id)init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:3];
        self.navigationItem.titleView = [VKUtils createNavigationItemTitle:@"Профиль"];
        self.userService = [[VKUsersService alloc] init];
        __weak VKSettingsController *weakSelf = self;
        NSString *selfId = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
        [self.userService getUsersInfo:selfId
                       completionBlock:^(NSDictionary *dictionary) {
                           weakSelf.info = [dictionary objectForKey:selfId];
                       }];
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];

    _avatar = [[NINetworkImageView alloc] initWithFrame:CGRectMake(10, 12, 50, 50)];
    _avatar.layer.masksToBounds = YES;
    [_avatar.layer setCornerRadius:5.0];
    [_avatar setPathToNetworkImage:self.info.photo];
    [self.view addSubview:_avatar];

    if (self.info && self.info.firstName) {
        _titleView = [[UILabel alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.textColor = UIColorMakeRGB(52, 60, 75);
        _titleView.font = [UIFont fontWithName:@"HelveticaNeueCyr-Medium" size:19];
        _titleView.text = [NSString stringWithFormat:@"%@ %@", self.info.firstName, self.info.lastName];
        [_titleView sizeToFit];
        _titleView.centerY = _avatar.centerY;
        _titleView.left = _avatar.right + 20;
        [self.view addSubview:_titleView];
    }

    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutButton.backgroundColor = [UIColor whiteColor];
    [logoutButton setTitle:@"Выйти" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.top = _avatar.bottom + 20;
    logoutButton.left = _avatar.left;
    logoutButton.width = 300;
    logoutButton.height = 45;
    logoutButton.titleLabel.text = @"Выйти";
    logoutButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:logoutButton];
}

- (void)logout {
    [VKWebViewController clearCookies];
    [[VKDataController instance] reset];
    VKWebViewController *webViewController = [[VKWebViewController alloc] initWithCompletionBlock:^{
        [VKAppDelegate showTabBar:self.tabBarController.navigationController];
    }];

    // Старые контроллеры остаются! TODO: переделать
    [self.tabBarController.navigationController pushViewController:webViewController animated:YES];
    [webViewController loadRequest];
}

@end