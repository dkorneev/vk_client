//
// Created by dkorneev on 1/6/13.
//



#import <Foundation/Foundation.h>
#import "RestKit.h"

@protocol VKLongPollListenerProtocol <NSObject>
- (void)handleEvent;
@end;

@interface VKLongPollService : NSObject <RKObjectLoaderDelegate>

+ (VKLongPollService *)getSharedInstance;

- (id)initWithKey:(NSString *)key server:(NSString *)server ts:(NSString *)ts;

- (void)stop;

- (void)start;

- (void)addMessagesEventObserver:(id <VKLongPollListenerProtocol>)object;

- (void)removeMessagesEventObserver:(id <VKLongPollListenerProtocol>)object;

- (void)addUserStatusEventObserver:(id <VKLongPollListenerProtocol>)object;

- (void)removeUserStatusEventObserver:(id <VKLongPollListenerProtocol>)object;

@end