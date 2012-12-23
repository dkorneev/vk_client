//
// Created by admin on 11/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VKDialogsController.h"
#import "VKFriendsService.h"
#import "VKDialogsService.h"
#import "VKDialogsListCell.h"
#import "VKFriendInfo.h"
#import "VKDialogInfo.h"
#import "VKUsersService.h"


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
        [self refreshData];
    }
    return self;
}

- (void)refreshData {
    // TODO: проверить что память освобождается корректно,
    // из-за использования не weakSelf, а обращения к полю напрямую
    __weak VKDialogsController *weakSelf = self;
    self.service = [[VKDialogsService alloc] initWithCompletionBlock:^(NSArray *array) {
        _dialogsArray = array;
        _usersService = [[VKUsersService alloc] initWithCompletionBlock:^(NSDictionary *users) {
            _users = users;
            _reloading = NO;
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tableView];
            [weakSelf.tableView reloadData];
        }];

        [_usersService getUsersInfo:[weakSelf friendsIdsString: _dialogsArray]];
    }];

    _reloading = YES;
    [self.service getDialogs];
}

// достает id собеседников
- (NSString *)friendsIdsString: (NSArray *)dialogsArray {
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

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    [self refreshData];
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > _dialogsArray.count - 1) {
        return [[UITableViewCell alloc] init];

    } else {
        VKDialogsListCell *cell = [tableView dequeueReusableCellWithIdentifier:[VKDialogsListCell cellIdentifier]];
        if (!cell)
            cell = [[VKDialogsListCell alloc] init];
        VKDialogInfo *dialogInfo = [_dialogsArray objectAtIndex:(NSUInteger)indexPath.row];
        if (dialogInfo.adminId) // групповая беседа
        {
            VKFriendInfo *userInfo = [_users valueForKey:dialogInfo.adminId.stringValue];
            [cell fillByDialogsInfo:dialogInfo userInfo:userInfo];
        }
        else
            [cell fillByDialogsInfo:dialogInfo userInfo:[_users valueForKey:dialogInfo.userId.stringValue]];
        return cell;
    }
}

// количество ячеек в секции
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dialogsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end