//
// Created by dkorneev on 11/4/12.
//



#import "VKEditableCell.h"
#import "VKUtils.h"


@interface VKEditableCell ()
@property(nonatomic, copy) NSString *defaultText;
@end

@implementation VKEditableCell

- (id)initWithDefaultText: (NSString *)defaultText {
    self = [super initWithFrame:CGRectMake(0, 0, 300, 43)];
    if (self) {
        self.defaultText = defaultText;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, 300 - 14 * 2, 14)];
        textField.clearsOnInsertion = YES;
        textField.placeholder = defaultText;
        textField.font = [UIFont fontWithName:@"HelveticaNeueCyr-Medium" size:15];
        textField.textColor = UIColorMakeRGB(128, 128, 128);
        textField.delegate = self;
        self.backgroundColor = textField.backgroundColor = UIColorMakeRGB(247, 247, 247);
        [self addSubview:textField];
        textField.center = self.center;

    }
    return self;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (!textField.text.length)
        textField.text = self.defaultText;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
}

@end