//
// Created by dkorneev on 11/4/12.
//



#import <Foundation/Foundation.h>


@interface VKEditableCell : UITableViewCell <UITextFieldDelegate>
- (id)initWithDefaultText:(NSString *)defaultText;

@end