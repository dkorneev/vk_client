//
// Created by dkorneev on 1/6/13.
//



#import <Foundation/Foundation.h>
#import "RestKit.h"

@class VKLongPollInfoService;

@protocol VKLongPollListenerProtocol <NSObject>
- (void)handleEvent;
@end;

@interface VKLongPollService : NSObject <RKObjectLoaderDelegate>

+ (VKLongPollService *)getSharedInstance;

- (id)init;

- (void)stop;

// completionBlock - вызывается после получения информации, необходимой для работы longPoll-механизма,
// непосредственно перед запуском первого запроса
- (void)start:(void (^)())completionBlock;

- (void)addMessagesEventObserver:(id <VKLongPollListenerProtocol>)object;

- (void)removeMessagesEventObserver:(id <VKLongPollListenerProtocol>)object;

- (void)addUserStatusEventObserver:(id <VKLongPollListenerProtocol>)object;

- (void)removeUserStatusEventObserver:(id <VKLongPollListenerProtocol>)object;

@end