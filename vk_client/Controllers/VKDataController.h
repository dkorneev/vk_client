//
// Created by dkorneev on 1/28/13.
//

#import <Foundation/Foundation.h>
#import "VKLongPollService.h"

@class VKAbstractEvent;
@class VKLongPollService;
@class VKDialogsService;

@protocol VKDataObserverProtocol <NSObject>
- (void)handleEvent:(VKAbstractEvent *)event;
@end;

@interface VKDataController : NSObject <VKLongPollDelegateProtocol>

+ (VKDataController *)instance;

- (void)updateFriendsList;

- (void)updateDialogsList;

- (NSArray *)getDialogs;

- (NSArray *)getFriends;

- (void)addObserver:(__weak id <VKDataObserverProtocol>)object;

@end