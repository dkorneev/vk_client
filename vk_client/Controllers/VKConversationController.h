//
// Created by dkorneev on 12/26/12.
//



#import <Foundation/Foundation.h>
#import "UIBubbleTableViewDataSource.h"
#import "UIInputToolbar.h"
#import "VKLongPollService.h"
#import "VKNavBarAvatarView.h"
#import "VKDataController.h"

@class VKFriendInfo;

@interface VKConversationController : UIViewController <UIBubbleTableViewDataSource, UIInputToolbarDelegate, VKDataObserverProtocol, UIActionSheetDelegate>

- (id)initWithFriendInfo:(VKFriendInfo *)friendsInfo;

@end