//
// Created by dkorneev on 12/4/12.
//



#import <Foundation/Foundation.h>

@class NINetworkImageView;
@class NIAttributedLabel;
@class VKDialogInfo;
@class VKFriendInfo;


@interface VKDialogsListCell : UITableViewCell

+ (NSString *)cellIdentifier;

- (void)fillByDialogsInfo:(VKDialogInfo *)info userInfo:(VKFriendInfo *)userInfo;

@end