//
// Created by dkorneev on 1/28/13.
//

#import <Foundation/Foundation.h>

@class VKFriendInfo;

@interface VKNavBarAvatarView : UIView

- (id)initWithFriendsInfo:(VKFriendInfo *)friendInfo;

- (void)setOnline:(BOOL)status;

@end