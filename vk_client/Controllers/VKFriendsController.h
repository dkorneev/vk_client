//
// Created by dkorneev on 11/25/12.
//



#import <Foundation/Foundation.h>
#import "VKPullRefreshTableViewController.h"
#import "VKLongPollService.h"

@class VKFriendsService;


@interface VKFriendsController : VKPullRefreshTableViewController <VKLongPollListenerProtocol>
@end