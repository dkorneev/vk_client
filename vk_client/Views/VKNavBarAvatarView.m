//
// Created by dkorneev on 1/28/13.
//

#import <QuartzCore/QuartzCore.h>
#import "VKNavBarAvatarView.h"
#import "NINetworkImageView.h"
#import "VKUtils.h"
#import "UIViewAdditions.h"
#import "VKFriendInfo.h"

@interface VKNavBarAvatarView ()
@property(nonatomic, strong) UILabel *titleView;

@end

@implementation VKNavBarAvatarView

- (id)initWithFriendsInfo:(VKFriendInfo *)friendInfo {
    self = [super init];
    if (self) {
        NINetworkImageView *userAvatar = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [userAvatar setPathToNetworkImage:friendInfo.photo];
        userAvatar.layer.masksToBounds = YES;
        [userAvatar.layer setCornerRadius:5.0];

        _titleView = [[UILabel alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.textColor = UIColorMakeRGB(226, 232, 240);
        _titleView.font = [UIFont fontWithName:@"HelveticaNeueCyr-Bold" size:11];
        _titleView.text = @"онлайн";
        [_titleView sizeToFit];
        if (!friendInfo.online.boolValue)
            _titleView.hidden = YES;
        
        self.frame = CGRectMake(0, 0, _titleView.width + userAvatar.width + 5, userAvatar.height);

        userAvatar.center = self.center;
        userAvatar.right = self.right;
        [self addSubview:userAvatar];

        _titleView.center = self.center;
        _titleView.left = self.left;
        [self addSubview:_titleView];
    }

    return self;
}

- (void)setOnline:(BOOL)status {
    _titleView.hidden = !status;
}


@end