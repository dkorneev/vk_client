//
// Created by dkorneev on 1/6/13.
//



#import <Foundation/Foundation.h>
#import "RestKit.h"

@class VKLongPollInfoService;
@class VKAbstractEvent;

@protocol VKLongPollDelegateProtocol <NSObject>
- (void)handleResponseWithUpdates:(NSArray *)updates;
@end;

@interface VKLongPollService : NSObject <RKObjectLoaderDelegate>

- (id)initWithDelegate:(id <VKLongPollDelegateProtocol>)delegate;

- (void)stop;

- (void)start;

@end