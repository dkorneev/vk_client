//
// Created by admin on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <QuartzCore/QuartzCore.h>
#import "VKDialogsListCell.h"
#import "VKDialogInfo.h"
#import "VKUtils.h"
#import "NINetworkImageView.h"
#import "VKFriendInfo.h"
#import "UIViewAdditions.h"

static NSString *cellIdentifier = @"VKDialogsListCellIdentifier";

@interface VKDialogsListCell ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *messageLabel;
@property(nonatomic, strong) NINetworkImageView *userAvatar;
@property(nonatomic, strong) UIImageView *onlineMark;


@end

@implementation VKDialogsListCell

+ (NSString *)cellIdentifier {
    return cellIdentifier;
}

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[VKDialogsListCell cellIdentifier]];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIImage *tempImage = [[UIImage alloc] init];
        CGRect avatarFrame = CGRectMake(8, 8, 40, 40);
        self.userAvatar = [[NINetworkImageView alloc] initWithImage:tempImage];
        self.userAvatar.frame = avatarFrame;

        self.userAvatar.layer.masksToBounds = YES;
        [self.userAvatar.layer setCornerRadius:5.0];
        [self addSubview:self.userAvatar];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 12, 208, 16)];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeueCyr-Bold" size:15.0];

        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 32, 255, 16)];
        self.messageLabel.font = [UIFont fontWithName:@"HelveticaNeueCyr-Roman" size:13.0];
        self.messageLabel.textColor = UIColorMakeRGB(85, 85, 85);

        [self addSubview:_nameLabel];
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (_onlineMark) {
        [_onlineMark removeFromSuperview];
        _onlineMark = nil;
    }
}

- (void)fillByDialogsInfo:(VKDialogInfo *)info userInfo:(VKFriendInfo *)userInfo {
    [self.userAvatar setPathToNetworkImage:userInfo.photo];
    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", userInfo.firstName, userInfo.lastName]];
    [self.nameLabel sizeToFit];

    if (userInfo.online.boolValue) {
        _onlineMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Online.png"]];
        _onlineMark.center = (struct CGPoint) {self.nameLabel.right + 10, 18};
        [_onlineMark sizeToFit];
        [self addSubview:_onlineMark];
    }

    [self.messageLabel setText:info.body];
}

@end