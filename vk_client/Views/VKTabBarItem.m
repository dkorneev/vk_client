//
// Created by dkorneev on 11/28/12.
//



#import "VKTabBarItem.h"


@implementation VKTabBarItem

- (id)initWithTitle:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName tag:(NSInteger)tag {
    self = [super initWithTitle:title image:[UIImage imageNamed:imageName] tag:tag];
    if (self) {
        if ([self respondsToSelector:@selector(setTitleTextAttributes:forState:)]) {
            NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[VKTabBarItem labelFont], UITextAttributeFont,
                                                                                      [VKTabBarItem textColor], UITextAttributeTextColor, nil];
            [self setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
            NSDictionary *highlightedTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[VKTabBarItem highlightedTextColor], UITextAttributeTextColor, nil];
            [self setTitleTextAttributes:highlightedTextAttributes forState:UIControlStateHighlighted];
        }
        if ([self respondsToSelector:@selector(setFinishedSelectedImage:withFinishedUnselectedImage:)]) {
            [self setFinishedSelectedImage:[UIImage imageNamed:selectedImageName] withFinishedUnselectedImage:nil];
        }
    }
    return self;
}

+ (UIFont *)labelFont {
    return [UIFont fontWithName:@"HelveticaNeueCyr-Medium" size:8];
}

+ (UIColor *)textColor {
    return UIColorMakeRGB(138, 141, 145);
}

+ (UIColor *)highlightedTextColor {
    return [UIColor whiteColor];
}

@end