//
// Created by dkorneev on 11/25/12.
//


#import "VKDialogsController.h"
#import "VKFriendsService.h"
#import "VKDialogsService.h"
#import "VKDialogsListCell.h"
#import "VKFriendInfo.h"
#import "VKDialogInfo.h"
#import "VKUsersService.h"
#import "VKConversationController.h"
#import "VKUtils.h"
#import "VKLongPollService.h"


@interface VKDialogsController ()
@property(nonatomic, strong) VKDialogsService *service;
@property(nonatomic, strong) NSArray *dialogsArray;
@property(nonatomic, strong) NSDictionary *users;
@property(nonatomic, strong) VKUsersService *usersService;
@end

@implementation VKDialogsController

- (id)init {
    self = [super init];
    if (self) {
        self.navigationItem.titleView = [VKUtils createNavigationItemTitle:@"Диалоги"];
        [[VKLongPollService getSharedInstance] addMessagesEventObserver:self];
        [[VKLongPollService getSharedInstance] addUserStatusEventObserver:self];
        [self refreshData];
    }
    return self;
}

- (void)handleEvent:(VKAbstractEvent *)event {
    NSLog(@"VKDialogsController - handle event");
    [self refreshData];
}

- (void)dealloc {
    [[VKLongPollService getSharedInstance] removeMessagesEventObserver:self];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData {
    if (!self.service) {
        __weak VKDialogsController *weakSelf = self;
        void (^completionBlock)(NSArray *) = ^(NSArray *array) {

            // групповые диалоги пока не поддерживаются, поэтому их исключаем
            NSMutableArray *notGroupDialogs = [NSMutableArray new];
            for (VKDialogInfo *curInfo in array) {
                if (![curInfo isGroupDialog])
                    [notGroupDialogs addObject:curInfo];
            }

            weakSelf.dialogsArray = notGroupDialogs;
            weakSelf.usersService = [[VKUsersService alloc] init];

            // для того чтобы отображать инфу о пользователях
            // которые не являются друзьями но учавствовали в диалоге
            // извлекаем их id из диалогов и запрашиваем инфу о них
            [weakSelf.usersService getUsersInfo:[weakSelf friendsIdsString:weakSelf.dialogsArray] completionBlock:^(NSDictionary *users) {
                weakSelf.users = users;
                weakSelf.reloading = NO;
                [weakSelf.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tableView];
                [weakSelf.tableView reloadData];
            }];
        };
        self.service = [[VKDialogsService alloc] initWithCompletionBlock:completionBlock];
    }

    if (![self.service isLoading]) {
        _reloading = YES;
        [self.service getDialogs];
    }
}

// достает id собеседников из массива дилогов
- (NSString *)friendsIdsString:(NSArray *)dialogsArray {
    if (!dialogsArray || !dialogsArray.count)
        return @"";

    NSMutableArray *usersArray = [[NSMutableArray alloc] init];
    for (VKDialogInfo *curDialog in dialogsArray) {
        if (curDialog.chatActive)
            [usersArray addObject:curDialog.chatActive];
        if (curDialog.adminId)
            [usersArray addObject:curDialog.adminId];
        else if (curDialog.userId)
            [usersArray addObject:curDialog.userId];
    }
    return [usersArray componentsJoinedByString:@","];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    [self refreshData];
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VKDialogsListCell *cell = [tableView dequeueReusableCellWithIdentifier:[VKDialogsListCell cellIdentifier]];
    if (!cell)
        cell = [[VKDialogsListCell alloc] init];
    VKDialogInfo *dialogInfo = [_dialogsArray objectAtIndex:(NSUInteger) indexPath.row];
    if (dialogInfo.adminId) { // групповая беседа
        VKFriendInfo *userInfo = [_users valueForKey:dialogInfo.adminId.stringValue];
        [cell fillByDialogsInfo:dialogInfo userInfo:userInfo];

    } else {
        [cell fillByDialogsInfo:dialogInfo userInfo:[_users valueForKey:dialogInfo.userId.stringValue]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VKDialogInfo *dialogInfo = [_dialogsArray objectAtIndex:(NSUInteger) indexPath.row];
    VKFriendInfo *friendInfo = [self.users valueForKey:dialogInfo.userId.stringValue];
    VKConversationController *conversation = [[VKConversationController alloc] initWithFriendInfo:friendInfo];
    [self.navigationController pushViewController:conversation animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dialogsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end