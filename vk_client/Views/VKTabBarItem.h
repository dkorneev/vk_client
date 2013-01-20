//
// Created by dkorneev on 11/28/12.
//



#import <Foundation/Foundation.h>
#import "VKUtils.h"


@interface VKTabBarItem : UITabBarItem

- (id)initWithTitle:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName tag:(NSInteger)tag;

@end