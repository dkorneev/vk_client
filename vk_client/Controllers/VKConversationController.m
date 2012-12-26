//
// Created by admin on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VKConversationController.h"
#import "VKFriendInfo.h"
#import "VKDialogsService.h"
#import "VKDialogInfo.h"
#import "UIBubbleTableView.h"
#import "VKUtils.h"
#import "UITableViewAdditions.h"


@interface VKConversationController ()
@property(nonatomic, strong) VKFriendInfo *friend;
@property(nonatomic, strong) VKDialogsService *service;
@property(nonatomic, strong) NSArray *bubblesData;
@end

@implementation VKConversationController

- (id)init:(VKFriendInfo *)friend  {
    self = [super init];
    if (self) {
        self.friend = friend;
        self.navigationItem.titleView = [VKUtils createNavigationItemTitle:friend.firstName];
        [self refresh];
    }
    return self;
}

- (void)refresh {
    __weak  VKConversationController *weakSelf = self;
    self.service = [[VKDialogsService alloc] initWithCompletionBlock:^(NSArray *array) {
        NSMutableArray *bubblesData = [NSMutableArray new];
        for (VKDialogInfo *curInfo in array) {
            NSString *text = curInfo.body ? curInfo.body : @"<empty>";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:curInfo.date.unsignedIntValue];

            NSString *myId = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
            NSBubbleType bubbleType = [myId isEqualToString:curInfo.userId.stringValue] ?
                    BubbleTypeMine : BubbleTypeSomeoneElse;

            [bubblesData addObject:[NSBubbleData dataWithText:text date:date type:bubbleType]];
        }
        weakSelf.bubblesData = bubblesData;

        [((UIBubbleTableView *)weakSelf.view) reloadData];
        [((UIBubbleTableView *)weakSelf.view) scrollToLastRow:YES];
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
    return [_bubblesData objectAtIndex:(NSUInteger)row];
}

@end