//
// Created by admin on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
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