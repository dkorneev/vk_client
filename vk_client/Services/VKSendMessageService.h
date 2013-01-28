//
// Created by dkorneev on 1/25/13.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"


@interface VKSendMessageService : NSObject <RKObjectLoaderDelegate>

- (id)initWithCompletionBlock:(void (^)())completionBlock errorBlock:(void (^)())errorBlock;

- (void)sendMessage:(NSNumber *)uid messageText:(NSString *)message;

@end