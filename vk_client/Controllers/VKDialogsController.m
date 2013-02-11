//
// Created by dkorneev on 11/25/12.
//


#import "VKDialogsController.h"
#import "VKDialogsListCell.h"
#import "VKFriendInfo.h"
#import "VKDialogInfo.h"
#import "VKConversationController.h"
#import "VKUtils.h"

@interface VKDialogsController ()
@property(nonatomic, strong) NSArray *dialogsArray;
@property(nonatomic, strong) NSDictionary *users;
@end

@implementation VKDialogsController

- (id)init {
    self = [super init];
    if (self) {
        self.navigationItem.titleView = [VKUtils createNavigationItemTitle:@"Диалоги"];
        [[VKDataController instance] addObserver:self];
        [self refreshData];
    }
    return self;
}

- (void)handleEvent:(VKAbstractEvent *)event {
    NSLog(@"VKDialogsController - handle event");
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

    self.dialogsArray = [[VKDataController instance] getDialogs];

    NSArray *friends = [[VKDataController instance] getFriends];
    NSMutableDictionary *friendsDict = [[NSMutableDictionary alloc] init];
    for (VKFriendInfo *curFriend in friends)
        [friendsDict setObject:curFriend forKey:curFriend.userId.stringValue];
    self.users = friendsDict;
    if ([self isViewLoaded])
        [self.tableView reloadData];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData {
    VKDataController *dataController = [VKDataController instance];
    [dataController updateFriendsList];
    [dataController updateDialogsList];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    NSLog(@"VKDialogsController - manual refresh");
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

    if (!self.dialogsArray.count)
        [self performSelector:@selector(refreshData) withObject:nil afterDelay:1];

    return self.dialogsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end