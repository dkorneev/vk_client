//
// Created by admin on 11/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "VKRegistrationButton.h"
#import "VKUtils.h"

@implementation VKRegistrationButton

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    self = [super initWithFrame: CGRectMake(0, 0, 300, 200)];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeueCyr-Medium" size:18];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:UIColorMakeRGB(33, 68, 37) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"RegButton.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"RegButton_pressed.png"] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        btn.frame = CGRectMake(9, 0, 300, 200);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

        // убираем границы ячейки:
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        self.backgroundView = backView;
    }
    return self;
}

@end