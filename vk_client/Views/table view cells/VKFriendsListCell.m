//
// Created by admin on 11/29/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <QuartzCore/QuartzCore.h>
#import "VKFriendsListCell.h"
#import "VKFriendInfo.h"
#import "NINetworkImageView.h"
#import "NIAttributedLabel.h"


static NSString *cellIdentifier = @"VKFriendsListCellIdentifier";

@interface VKFriendsListCell ()
@property(nonatomic, strong) UIImageView *onlineMark;
@property(nonatomic, strong) NINetworkImageView *userAvatar;
@property(nonatomic, strong) NIAttributedLabel *label;
@end

@implementation VKFriendsListCell

+ (NSString *)cellIdentifier {
    return cellIdentifier;
}

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[VKFriendsListCell cellIdentifier]];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIImage *tempImage = [[UIImage alloc] init];
        CGRect avatarFrame = CGRectMake(6, 6, 36, 36);
        self.userAvatar = [[NINetworkImageView alloc] initWithImage:tempImage];
        self.userAvatar.frame = avatarFrame;

        self.userAvatar.layer.masksToBounds = YES;
        [self.userAvatar.layer setCornerRadius:5.0];
        [self addSubview:self.userAvatar];

        self.label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(50, 17, 235, 18)];
        [self addSubview:self.label];

        self.onlineMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Online.png"]];
        self.onlineMark.center = (struct CGPoint) {280, 24};
        [self.onlineMark sizeToFit];
        [self addSubview:self.onlineMark];
        self.onlineMark.hidden = YES;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.onlineMark.hidden = YES;
}

- (void)fillByFriendsInfo:(VKFriendInfo *)info {
    // 1. Устанавливаем аватарку
    [self.userAvatar setPathToNetworkImage:info.photo];

    // 2. Формируем строку с именем и фамилией
    NSString *name = [NSString stringWithFormat:@"%@ %@", info.firstName, info.lastName];
    NSMutableAttributedString *preparedName = [[NSMutableAttributedString alloc] initWithString:name];
    UIFont *ordinaryFont = [UIFont fontWithName:@"HelveticaNeueCyr-Medium" size:16.0];
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeueCyr-Bold" size:16.0];
    [preparedName addAttribute:NSFontAttributeName
                         value:ordinaryFont range:NSMakeRange(0, info.firstName.length)];
    [preparedName addAttribute:NSFontAttributeName value:boldFont
                         range:NSMakeRange(info.firstName.length + 1, info.lastName.length)];
    self.label.attributedString = preparedName;

    // 3. Если пользователь в сети  - показываем метку
    if (info.online.boolValue)
        self.onlineMark.hidden = NO;
}

@end