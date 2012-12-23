//
// Created by admin on 11/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VKSettingsController.h"


@implementation VKSettingsController

- (id)init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:3];
    }

    return self;
}


@end