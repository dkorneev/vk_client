//
// Created by admin on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "UIBubbleTableViewDataSource.h"
#import "UIInputToolbar.h"

@class VKFriendInfo;
@class VKDialogsService;
@class UIInputToolbar;


@interface VKConversationController : UIViewController <UIBubbleTableViewDataSource, UIInputToolbarDelegate>

- (id)init:(VKFriendInfo *)friend;

@end