//
// Created by admin on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "UIBubbleTableViewDataSource.h"

@class VKFriendInfo;
@class VKDialogsService;


@interface VKConversationController : UIViewController <UIBubbleTableViewDataSource>

- (id)init:(VKFriendInfo *)friend;

@end