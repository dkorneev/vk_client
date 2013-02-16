//
// Created by dkorneev on 1/28/13.
//

#import "VKDataController.h"
#import "VKFriendsService.h"
#import "VKDialogsService.h"
#import "VKDialogInfo.h"
#import "VKFriendInfo.h"
#import "VKAbstractEvent.h"
#import "VKUserStatusEvent.h"
#import "VKMessageEvent.h"
#import "VKWeakRefStorage.h"
#import "VKSendMessageService.h"


@interface VKDataController ()
@property(nonatomic, strong) NSMutableArray *observers;

@property(nonatomic, strong) VKLongPollService *longPollService;
@property(nonatomic, strong) VKFriendsService *friendsService;
@property(nonatomic, strong) VKDialogsService *dialogsService;
@property(nonatomic, strong) VKDialogsService *dialogHistoryService;
@property(nonatomic, strong) VKSendMessageService *messageService;

@property(nonatomic, strong) NSArray *friends;
@property(nonatomic, strong) NSArray *dialogs;
@property(nonatomic, strong) NSMutableDictionary *dialogHistory;

@end

@implementation VKDataController

static VKDataController *_dataController = nil;

+ (VKDataController *)instance {
    if (!_dataController) {
        _dataController = [[VKDataController alloc] init];
    }
    return _dataController;
}

- (void)reset {
    [self.longPollService stop];
}

- (id)init {
    self = [super init];
    if (self) {
        self.friends = [NSArray new];
        self.dialogs = [NSArray new];
        self.dialogHistory = [NSMutableDictionary new];
        self.observers = [NSMutableArray new];
        self.longPollService = [[VKLongPollService alloc] initWithDelegate:self];
        [self.longPollService start];
    }
    return self;
}

- (void)updateFriendsList {
    __weak VKDataController *weakSelf = self;
    void (^completionBlock)(NSArray *) = ^(NSArray *array) {
        NSLog(@"VKDataController friends completion block: %d", array.count);
        weakSelf.friends = array;
        [weakSelf notifyObservers:[[VKUserStatusEvent alloc] init]];
    };
    void (^errorBlock)() = ^{
        NSLog(@"VKDataController - updateFriendsList - error!");
    };

    if (!self.friendsService)
        self.friendsService = [[VKFriendsService alloc] initWithCompletionBlock:completionBlock errorBlock:errorBlock];
    [self.friendsService getFriends];
}

- (void)updateDialogsList {
    __weak VKDataController *weakSelf = self;
    void (^completionBlock)(NSArray *) = ^(NSArray *array) {
        NSLog(@"VKDataController dialogs completion block: %d", array.count);
        weakSelf.dialogs = array;
        [weakSelf notifyObservers:[[VKMessageEvent alloc] init]];
    };

    if (!self.dialogsService)
        self.dialogsService = [[VKDialogsService alloc] initWithCompletionBlock:completionBlock];
    [self.dialogsService getDialogs];
}

- (void)updateDialogHistory:(NSNumber *)userID {
    __weak VKDataController *weakSelf = self;
    NSString *string = [NSString stringWithString:userID.stringValue];
    void (^completionBlock)(NSArray *) = ^(NSArray *array) {
        NSLog(@"VKDataController dialogs history completion block: %d", array.count);

        NSString *myIdString = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
        for (VKDialogInfo *curInfo in array) {
            if (![curInfo.userId.stringValue isEqualToString:myIdString]) {
                [weakSelf.dialogHistory setObject:array forKey:curInfo.userId.stringValue];
                [weakSelf notifyObservers:[[VKMessageEvent alloc] init]];
                break;                            
            }
        }
    };

    if (!self.dialogHistoryService)
        self.dialogHistoryService = [[VKDialogsService alloc] initWithCompletionBlock:completionBlock];
    [self.dialogHistoryService getDialogHistory:userID];
}

- (void)sendMessage:(NSString *)messageText to:(NSNumber *)userId {
    if (!self.messageService) {
        self.messageService = [[VKSendMessageService alloc] initWithDelegate:self];
    }
    [self.messageService sendMessage:userId messageText:messageText];
}

- (NSArray *)getDialogs {
    NSMutableArray *dialogs = [NSMutableArray new];
    for (VKDialogInfo *curInfo in self.dialogs) {
        if ([curInfo isGroupDialog])  // отсекаем групповые диалоги
            continue;

        NSUInteger index = [self.friends indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            VKFriendInfo *tmp = (VKFriendInfo *)obj;
            return [tmp.userId isEqualToNumber:curInfo.userId];
        }];

        if (index != NSNotFound) // отсекаем диалоги с пользователями, которые не являются друзьями
            [dialogs addObject:curInfo];
    }
    return dialogs;
}

- (NSArray *)getFriends {
    return [NSArray arrayWithArray:self.friends];
}

- (VKFriendInfo *)getFriendInfo: (NSNumber *)userID {
    NSUInteger index = [self.friends indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        VKFriendInfo *curFriend = (VKFriendInfo *)obj;
        return [curFriend.userId isEqualToNumber:userID];
    }];
    return (index != NSNotFound) ? [self.friends objectAtIndex:index] : nil;
}

- (NSArray *)getDialogHistory:(NSNumber *)userID {
    NSArray *ret = [self.dialogHistory objectForKey:userID.stringValue];
    return (!ret) ? @[] : ret;
}

- (void)removeDeletedObservers {
    NSIndexSet *removedObjectsIndexes = [self.observers indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        VKWeakRefStorage *curStorage = (VKWeakRefStorage *)obj;
        return !curStorage.reference;
    }];
    [self.observers removeObjectsAtIndexes:removedObjectsIndexes];
}

- (void)notifyObservers:(VKAbstractEvent *)event {
    [self removeDeletedObservers];
    for (VKWeakRefStorage *curStorage in self.observers)
        [curStorage.reference handleEvent:event];
}

#pragma mark -
#pragma mark VKSendMessageServiceProtocol

-(void)sendMessageSuccess:(NSNumber*)userId {
    [self updateDialogHistory:userId];
}

#pragma mark -
#pragma mark VKLongPollDelegateProtocol

- (void)changeUserStatus:(NSInteger)userId online:(BOOL)status {
    NSUInteger index = [self.friends indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        VKFriendInfo *tmp = (VKFriendInfo *)obj;
        return [tmp.userId isEqualToNumber:[NSNumber numberWithInt:userId]];
    }];

    if (index != NSNotFound) {
        VKFriendInfo *friendInfo = (VKFriendInfo *) [self.friends objectAtIndex:index];
        friendInfo.online = [NSNumber numberWithBool:status];
        [self notifyObservers:[[VKUserStatusEvent alloc] init]];
        NSLog(@"\t[%d] - %@ %@ - %@", userId, friendInfo.firstName, friendInfo.lastName,
                status ? @"came online" : @"went offline");
    }
}

- (void)handleResponseWithUpdates:(NSArray *)updates {
    for (NSArray *curUpdate in updates) {
        unsigned eventType = ((NSNumber *) [curUpdate objectAtIndex:0]).unsignedIntValue;
        NSInteger userId = -1 * ((NSNumber *) [curUpdate objectAtIndex:1]).integerValue;
        switch (eventType) {
            case 1:
            case 2:
            case 3:
                break;
            case 4: {
                [self updateDialogsList];
                NSLog(@"\tmessage event [code: %d]", eventType);
                break;
            }
            case 8: {
                [self changeUserStatus:userId online:YES];
                break;
            }
            case 9: {
                [self changeUserStatus:userId online:NO];
                break;
            }
            default:
                NSLog(@"\tunhandled event [code: %d]", eventType);
        }
    }
}

#pragma mark -
#pragma mark Data Observing Mechanism

- (void)addObserver:(__weak id <VKDataObserverProtocol>)object {
    [self.observers addObject:[VKWeakRefStorage create:object]];
}

@end