//
//  VKAppDelegate.m
//  vk_client
//
//  Created by dkorneev on 10/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VKAppDelegate.h"
#import "Network.h"
#import "VKWebViewController.h"
#import "RestKit.h"
#import "RKJSONParserJSONKit.h"
#import "VKConstants.h"
#import "VKSettingsController.h"
#import "VKUtils.h"
#import "VKDialogsController.h"
#import "VKFriendsController.h"

@implementation VKAppDelegate

- (void)configureRestKit {
    [RKObjectManager managerWithBaseURLString:kBaseUrlString];
    [RKObjectManager sharedManager].requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/javascript"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc]init]];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;

    VKWebViewController *webViewController = [[VKWebViewController alloc] initWithCompletionBlock:^{
        [VKAppDelegate showTabBar:nav];
    }];
    [nav pushViewController:webViewController animated:YES];

    [self configureRestKit];
    [self.window makeKeyAndVisible];
    return YES;
}

+ (void)showTabBar:(UINavigationController *)navController {
    // Контакты
    UINavigationController *friendsNav = [[UINavigationController alloc] init];
    [VKUtils configNavigationBar:friendsNav.navigationBar];
    [friendsNav pushViewController:[[VKFriendsController alloc] init] animated:NO];
    friendsNav.tabBarItem =
            [[UITabBarItem alloc] initWithTitle:@"Друзья" image:[UIImage imageNamed:@"tabbar-contacts-icon.png"] tag:0];

    // Диалоги
    UINavigationController *dialogsNav = [[UINavigationController alloc] init];
    [VKUtils configNavigationBar:dialogsNav.navigationBar];
    [dialogsNav pushViewController:[[VKDialogsController alloc] init] animated:NO];
    dialogsNav.tabBarItem =
            [[UITabBarItem alloc] initWithTitle:@"Диалоги" image:[UIImage imageNamed:@"tabbar-messages-icon.png"] tag:1];

    // Профиль
    UINavigationController *settingsNav = [[UINavigationController alloc] init];
    [VKUtils configNavigationBar:settingsNav.navigationBar];
    [settingsNav pushViewController:[[VKSettingsController alloc] init] animated:YES];
    settingsNav.tabBarItem =
            [[UITabBarItem alloc] initWithTitle:@"Профиль" image:[UIImage imageNamed:@"tabbar-settings-icon.png"] tag:2];

    // показываем слудеющий экран
    UITabBarController *mainTabBar = [[UITabBarController alloc] init];
    [mainTabBar setViewControllers:@[
            friendsNav, dialogsNav, settingsNav]];

    [navController pushViewController:mainTabBar animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

@end