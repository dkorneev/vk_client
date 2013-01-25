//
// Created by dkorneev on 12/26/12.
//


#import <QuartzCore/QuartzCore.h>
#import "VKConversationController.h"
#import "VKFriendInfo.h"
#import "VKDialogsService.h"
#import "VKDialogInfo.h"
#import "UIBubbleTableView.h"
#import "VKUtils.h"
#import "UITableViewAdditions.h"
#import "VKPhotoAttachment.h"
#import "VKAudioAttachment.h"
#import "VKDocumentAttachment.h"
#import "NINetworkImageView.h"
#import "VKSendMessageService.h"

#define kDefaultToolbarHeight 40
#define kDefaultNavigationBarHeight 44

@interface VKConversationController ()
@property(nonatomic, strong) VKFriendInfo *friend;
@property(nonatomic, strong) NSArray *bubblesData;
@property(nonatomic, strong) UIBubbleTableView *bubbleView;
@property(nonatomic, strong) UIInputToolbar *inputToolbar;

@property(nonatomic, strong) VKDialogsService *service;
@property(nonatomic, strong) VKSendMessageService *messageService;

@end

@implementation VKConversationController

@synthesize bubbleView = _bubbleView;
@synthesize inputToolbar = _inputToolbar;

- (id)init:(VKFriendInfo *)friend {
    self = [super init];
    if (self) {
        self.friend = friend;
        self.navigationItem.titleView = [VKUtils createNavigationItemTitle:friend.firstName];
        self.navigationController.navigationBar.backItem.title = @"Custom text";
        [self refresh];
    }
    return self;
}

- (void)refresh {
    __weak VKConversationController *weakSelf = self;

    void (^block)(NSArray *) = ^(NSArray *array) {
        NSMutableArray *bubblesData = [NSMutableArray new];
        for (VKDialogInfo *curInfo in array) {
            NSMutableArray *newBubbles = [NSMutableArray new];
            NSString *text = curInfo.body ? curInfo.body : @"";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:curInfo.date.unsignedIntValue];
            NSString *myId = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
            NSBubbleType bubbleType = [myId isEqualToString:curInfo.userId.stringValue] ?
                    BubbleTypeMine : BubbleTypeSomeoneElse;

            if (curInfo.attachments) {
                for (NSObject *curAttachment in curInfo.attachments) {
                    if ([curAttachment isKindOfClass:[VKPhotoAttachment class]]) {
                        NSBubbleData *bubble = [weakSelf createPhotoBubble:(VKPhotoAttachment *) curAttachment
                                                                      date:date
                                                                bubbleType:bubbleType];
                        [newBubbles addObject:bubble];

                    } else if ([curAttachment isKindOfClass:[VKAudioAttachment class]]) {
                        VKAudioAttachment *attachment = (VKAudioAttachment *) curAttachment;
                        NSString *audioInfo = [NSString stringWithFormat:@"<аудиозапись: %@ - %@>", attachment.performer, attachment.title];
                        [newBubbles addObject:[NSBubbleData dataWithText:audioInfo date:date type:bubbleType]];

                    } else if ([curAttachment isKindOfClass:[VKDocumentAttachment class]]) {
                        VKDocumentAttachment *attachment = (VKDocumentAttachment *) curAttachment;
                        NSString *docInfo = [NSString stringWithFormat:@"<документ: %@.%@>", attachment.title, attachment.ext];
                        [newBubbles addObject:[NSBubbleData dataWithText:docInfo date:date type:bubbleType]];
                    }

                }
            }

            if (text.length)
                [newBubbles addObject:[NSBubbleData dataWithText:text date:date type:bubbleType]];
            [bubblesData addObjectsFromArray:newBubbles];
        }
        weakSelf.bubblesData = bubblesData;

        [weakSelf.bubbleView reloadData];
        [weakSelf.bubbleView scrollToLastRow:YES];
    };

    self.service = [[VKDialogsService alloc] initWithCompletionBlock:block];
    [self.service getDialogHistory:_friend.userId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (NSBubbleData *)createPhotoBubble:(VKPhotoAttachment *)attachment date:(NSDate *)date bubbleType:(NSBubbleType)bubbleType {
    CGRect pictureFrame = CGRectMake(0, 0, 150, 150);
    NINetworkImageView *pictureView = [[NINetworkImageView alloc] initWithImage:[[UIImage alloc] init]];
    pictureView.contentMode = UIViewContentModeCenter;
    pictureView.frame = pictureFrame;
    [pictureView setPathToNetworkImage:attachment.source contentMode:UIViewContentModeScaleAspectFill];
    pictureView.layer.masksToBounds = YES;
    [pictureView.layer setCornerRadius:5.0];
    pictureView.sizeForDisplay = NO;
    return [NSBubbleData dataWithView:pictureView date:date type:bubbleType insets:(UIEdgeInsets) {15, 21, 15, 15}];
}

- (void)loadView {
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height - kDefaultToolbarHeight)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];

    _bubbleView = [[UIBubbleTableView alloc] initWithFrame:
            CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height - kDefaultToolbarHeight - kDefaultNavigationBarHeight)];
    _bubbleView.bubbleDataSource = self;

    _inputToolbar = [[UIInputToolbar alloc] initWithFrame:
            CGRectMake(0, screenFrame.size.height - kDefaultToolbarHeight - kDefaultNavigationBarHeight, screenFrame.size.width, kDefaultToolbarHeight)];
    _inputToolbar.textView.placeholder = @"Написать сообщение";
    _inputToolbar.delegate = self;

    [self.view addSubview:_bubbleView];
    [self.view addSubview:_inputToolbar];
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= kbSize.height;
        self.view.frame = frame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
}

- (void)inputButtonPressed:(NSString *)inputText {
    /* Called when toolbar button is pressed */
    NSLog(@"Pressed button with text: '%@'", inputText);
    if (!self.messageService) {
        void (^completionBLock)() = ^{};
        void (^errorBlock)() = ^{};
        self.messageService = [[VKSendMessageService alloc] initWithCompletionBlock:completionBLock errorBlock:errorBlock];
    }
//    [self.messageService se]

}

- (void)heightChanged:(float)diff {
    NSLog(@"heightChanged: %f", diff);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _bubbleView.frame;
        frame.origin.y += diff;
        _bubbleView.frame = frame;
    }];
}

#pragma mark -
#pragma mark UIBubbleTableViewDataSource

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView {
    return self.bubblesData.count;
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row {
    return [_bubblesData objectAtIndex:(NSUInteger) row];
}

@end