//
// Created by admin on 11/29/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class VKFriendInfo;
@class NINetworkImageView;

@interface VKFriendsListCell : UITableViewCell

+ (NSString *)cellIdentifier;

- (void)fillByFriendsInfo:(VKFriendInfo *)info;

@end