//
// Created by dkorneev on 12/26/12.
//



#import <Foundation/Foundation.h>
#import "UIBubbleTableViewDataSource.h"
#import "UIInputToolbar.h"
#import "VKLongPollService.h"
#import "VKNavBarAvatarView.h"

@class VKFriendInfo;
@class VKDialogsService;
@class UIInputToolbar;
@class VKSendMessageService;
@class VKDialogInfo;


@interface VKConversationController : UIViewController <UIBubbleTableViewDataSource, UIInputToolbarDelegate>

- (id)initWithFriendInfo:(VKFriendInfo *)friendsInfo;

@end