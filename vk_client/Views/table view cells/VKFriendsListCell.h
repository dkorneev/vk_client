//
// Created by dkorneev on 11/29/12.
//



#import <Foundation/Foundation.h>

@class VKFriendInfo;
@class NINetworkImageView;

@interface VKFriendsListCell : UITableViewCell

+ (NSString *)cellIdentifier;

- (void)fillByFriendsInfo:(VKFriendInfo *)info shiftMark:(BOOL)shift;

@end