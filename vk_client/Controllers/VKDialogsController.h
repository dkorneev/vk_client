//
// Created by dkorneev on 11/25/12.
//


#import <Foundation/Foundation.h>
#import "VKPullRefreshTableViewController.h"
#import "VKLongPollService.h"
#import "VKDataController.h"

@class VKFriendsService;
@class VKUsersService;


@interface VKDialogsController : VKPullRefreshTableViewController <VKDataObserverProtocol>
@end