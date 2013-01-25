//
// Created by dkorneev on 12/26/12.
//



#import <Foundation/Foundation.h>
#import "UIBubbleTableViewDataSource.h"
#import "UIInputToolbar.h"

@class VKFriendInfo;
@class VKDialogsService;
@class UIInputToolbar;
@class VKSendMessageService;


@interface VKConversationController : UIViewController <UIBubbleTableViewDataSource, UIInputToolbarDelegate>

- (id)init:(VKFriendInfo *)friend;

@end