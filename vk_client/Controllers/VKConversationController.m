//
// Created by dkorneev on 12/26/12.
//


#import <QuartzCore/QuartzCore.h>
#import "VKConversationController.h"
#import "VKFriendInfo.h"
#import "VKDialogInfo.h"
#import "UIBubbleTableView.h"
#import "VKUtils.h"
#import "UITableViewAdditions.h"
#import "VKPhotoAttachment.h"
#import "VKAudioAttachment.h"
#import "VKDocumentAttachment.h"
#import "NINetworkImageView.h"
#import "VKAbstractEvent.h"
#import "VKMessageEvent.h"
#import "VKUserStatusEvent.h"

#define kDefaultToolbarHeight 40
#define kDefaultNavigationBarHeight 44

@interface VKConversationController ()
@property(nonatomic, strong) VKFriendInfo *friendInfo;
@property(nonatomic, strong) NSArray *bubblesData;
@property(nonatomic, strong) UIBubbleTableView *bubbleView;
@property(nonatomic, strong) UIInputToolbar *inputToolbar;

@property(nonatomic, strong) VKNavBarAvatarView *avatarView;
@end

@implementation VKConversationController

@synthesize bubbleView = _bubbleView;
@synthesize inputToolbar = _inputToolbar;

- (id)initWithFriendInfo:(VKFriendInfo *)friendsInfo {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.friendInfo = friendsInfo;
        self.navigationItem.titleView = [VKUtils createNavigationItemTitle:friendsInfo.firstName];
        self.navigationItem.leftBarButtonItem = [VKUtils createBarButton:@"Назад" target:self action:@selector(back)];

        self.avatarView = [[VKNavBarAvatarView alloc] initWithFriendsInfo:friendsInfo];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.avatarView];

        [[VKDataController instance] addObserver:self];
        [self refresh];
    }
    return self;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh {
    VKDataController *dataController = [VKDataController instance];
    [dataController updateDialogHistory:self.friendInfo.userId];
}

- (NSArray *)createBubblesWithData:(NSArray *)data {
    NSMutableArray *bubblesData = [NSMutableArray new];
    for (VKDialogInfo *curInfo in data) {
        NSMutableArray *newBubbles = [NSMutableArray new];
        NSString *text = curInfo.body ? curInfo.body : @"";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:curInfo.date.unsignedIntValue];
        NSString *myId = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
        NSBubbleType bubbleType = [myId isEqualToString:curInfo.userId.stringValue] ?
                BubbleTypeMine : BubbleTypeSomeoneElse;

        if (curInfo.attachments) {
            for (NSObject *curAttachment in curInfo.attachments) {
                if ([curAttachment isKindOfClass:[VKPhotoAttachment class]]) {
                    NSBubbleData *bubble = [self createPhotoBubble:(VKPhotoAttachment *) curAttachment
                                                              date:date
                                                        bubbleType:bubbleType];
                    [newBubbles addObject:bubble];

                } else if ([curAttachment isKindOfClass:[VKAudioAttachment class]]) {
                    VKAudioAttachment *attachment = (VKAudioAttachment *) curAttachment;
                    NSString *audioInfo = [NSString stringWithFormat:@"[аудиозапись: %@ - %@]", attachment.performer, attachment.title];
                    [newBubbles addObject:[NSBubbleData dataWithText:audioInfo date:date type:bubbleType]];

                } else if ([curAttachment isKindOfClass:[VKDocumentAttachment class]]) {
                    VKDocumentAttachment *attachment = (VKDocumentAttachment *) curAttachment;
                    NSString *docInfo = [NSString stringWithFormat:@"[документ: %@.%@]", attachment.title, attachment.ext];
                    [newBubbles addObject:[NSBubbleData dataWithText:docInfo date:date type:bubbleType]];
                }
            }
        }

        if (text.length)
            [newBubbles addObject:[NSBubbleData dataWithText:text date:date type:bubbleType]];
        [bubblesData addObjectsFromArray:newBubbles];
    }
    return bubblesData;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

- (void)readFromModel {
    VKDataController *dataController = [VKDataController instance];
    self.bubblesData = [self createBubblesWithData:[dataController getDialogHistory:self.friendInfo.userId]];
    [self.bubbleView reloadData];
    [self.bubbleView scrollToLastRow:YES];
}

#pragma mark -
#pragma mark VKDataObserverProtocol

- (void)handleEvent:(VKAbstractEvent *)event {
    if ([event class] == [VKMessageEvent class]) {
        [self readFromModel];

    } else if ([event class] == [VKUserStatusEvent class]) {
        VKDataController *dataController = [VKDataController instance];
        VKFriendInfo *friendInfo = [dataController getFriendInfo:self.friendInfo.userId];
        [self.avatarView setOnline:friendInfo.online.boolValue];
    }
}

#pragma mark -
#pragma mark keyboard Notifications

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

- (void)attachButtonPressed {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Отправить фото"
                                delegate:self
                       cancelButtonTitle:@"Отмена"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"Сделать снимок", @"Выбрать из галереи", nil];

    [actionSheet showInView:self.view];
}

- (void)inputButtonPressed:(NSString *)inputText {
    [[VKDataController instance] sendMessage:inputText to:_friendInfo.userId];
}

// обработка изменения высоты поля ввода
- (void)heightChanged:(float)diff {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _bubbleView.frame;
        frame.origin.y += diff;
        _bubbleView.frame = frame;
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    switch (buttonIndex) {
//        case 0:
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//                if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
//
//                }
//            }
//            break;
//        case 1:
//            break;
//        default:
//            break;
//    }
}

#pragma mark -
#pragma mark UIBubbleTableViewDataSource

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView {
    if (!self.bubblesData.count)
        [self performSelector:@selector(readFromModel) withObject:nil afterDelay:1];

    return self.bubblesData.count;
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row {
    return [_bubblesData objectAtIndex:(NSUInteger) row];
}

@end