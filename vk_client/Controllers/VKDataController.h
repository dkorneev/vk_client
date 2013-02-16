//
// Created by dkorneev on 1/28/13.
//

#import <Foundation/Foundation.h>
#import "VKLongPollService.h"
#import "VKSendMessageService.h"

@class VKAbstractEvent;
@class VKLongPollService;
@class VKDialogsService;
@class VKFriendInfo;

@protocol VKDataObserverProtocol <NSObject>
- (void)handleEvent:(VKAbstractEvent *)event;
@end;

@interface VKDataController : NSObject <VKLongPollDelegateProtocol, VKSendMessageServiceProtocol>

+ (VKDataController *)instance;

- (void)reset;


- (void)updateFriendsList;

- (void)updateDialogsList;

- (void)updateDialogHistory:(NSNumber *)userID;

- (void)sendMessage:(NSString *)messageText to:(NSNumber *)userId;

- (NSArray *)getDialogs;

- (NSArray *)getFriends;

- (VKFriendInfo *)getFriendInfo:(NSNumber *)userID;

- (NSArray *)getDialogHistory:(NSNumber *)userID;

- (void)addObserver:(__weak id <VKDataObserverProtocol>)object;

@end