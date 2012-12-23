//
// Created by admin on 11/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "VKLoginButton.h"

@implementation VKLoginButton

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    self = [super initWithFrame: CGRectMake(0, 0, 300, 43)];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 43)];
        button.titleLabel.text = title;
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeueCyr-Medium" size:18];
        button.titleLabel.textColor = [UIColor whiteColor];
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"LoginButton.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"LoginButton_pressed.png"] forState:UIControlStateHighlighted];
        [self addSubview:button];
        button.center = self.center;
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

        // убираем границы ячейки:
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        self.backgroundView = backView;
    }
    return self;
}

@end