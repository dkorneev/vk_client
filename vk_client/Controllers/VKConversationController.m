//
// Created by admin on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import <sys/ucred.h>
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
#import "UIViewAdditions.h"


@interface VKConversationController ()
@property(nonatomic, strong) VKFriendInfo *friend;
@property(nonatomic, strong) VKDialogsService *service;
@property(nonatomic, strong) NSArray *bubblesData;
@end

@implementation VKConversationController

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
    self.service = [[VKDialogsService alloc] initWithCompletionBlock:^(NSArray *array) {
        NSMutableArray *bubblesData = [NSMutableArray new];
        for (VKDialogInfo *curInfo in array) {
            NSMutableArray *newBubbles = [NSMutableArray new];

            NSString *text = curInfo.body ? curInfo.body : @"<empty>";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:curInfo.date.unsignedIntValue];
            NSString *myId = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
            NSBubbleType bubbleType = [myId isEqualToString:curInfo.userId.stringValue] ?
                    BubbleTypeMine : BubbleTypeSomeoneElse;

            if (curInfo.attachments) {
                for (NSObject *curAttachment in curInfo.attachments) {
                    if ([curAttachment isKindOfClass:[VKPhotoAttachment class]]) {
                        VKPhotoAttachment *attachment = (VKPhotoAttachment *) curAttachment;

                        CGRect pictureFrame = CGRectMake(0, 0, 150, 150);
                        NINetworkImageView *pictureView = [[NINetworkImageView alloc] initWithImage:[[UIImage alloc] init]];
                        pictureView.frame = pictureFrame;
                        [pictureView setPathToNetworkImage:attachment.source];
                        pictureView.layer.masksToBounds = YES;
                        [pictureView.layer setCornerRadius:5.0];
                        pictureView.sizeForDisplay = NO;

                        [newBubbles addObject:[NSBubbleData dataWithView:pictureView
                                                                    date:date
                                                                    type:bubbleType
                                                                  insets:(UIEdgeInsets){15, 21, 15, 15}]];

                    } else if ([curAttachment isKindOfClass:[VKAudioAttachment class]]) {
                        VKAudioAttachment *attachment = (VKAudioAttachment *) curAttachment;
                        [newBubbles addObject:[NSBubbleData dataWithText:[NSString stringWithFormat:@"<аудиозапись: %@ - %@>", attachment.performer, attachment.title]
                                                                    date:date
                                                                    type:bubbleType]];

                    } else if ([curAttachment isKindOfClass:[VKDocumentAttachment class]]) {
                        VKDocumentAttachment *attachment = (VKDocumentAttachment *) curAttachment;
                        [newBubbles addObject:[NSBubbleData dataWithText:[NSString stringWithFormat:@"<документ: %@.%@>", attachment.title, attachment.ext]
                                                                    date:date
                                                                    type:bubbleType]];
                    }

                }
            }

            if (text.length)
                [newBubbles addObject:[NSBubbleData dataWithText:text date:date type:bubbleType]];
            [bubblesData addObjectsFromArray:newBubbles];
        }
        weakSelf.bubblesData = bubblesData;

        [((UIBubbleTableView *) weakSelf.view) reloadData];
        [((UIBubbleTableView *) weakSelf.view) scrollToLastRow:YES];
    }];
    [self.service getDialogHistory:_friend.userId];
}

- (void)loadView {
    UIBubbleTableView *view = [[UIBubbleTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    view.bubbleDataSource = self;
    self.view = view;
}

#pragma mark -
#pragma mark UIBubbleTableViewDataSource

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView {
    NSLog(@"rowsForBubbleTable: %d", self.bubblesData.count);
    return self.bubblesData.count;
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row {
    return [_bubblesData objectAtIndex:(NSUInteger) row];
}

@end