//
//  VKAppDelegate.h
//  vk_client
//
//  Created by dkorneev on 10/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)showTabBar:(UINavigationController *)navController;


@end