//
// Created by dkorneev on 1/25/13.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"


@protocol VKSendMessageServiceProtocol
    -(void)sendMessageSuccess:(NSNumber*)userId;
@end;

@interface VKSendMessageService : NSObject <RKObjectLoaderDelegate>

- (id)initWithDelegate:(id <VKSendMessageServiceProtocol>)delegate;

- (void)sendMessage:(NSNumber *)uid messageText:(NSString *)message;

@end