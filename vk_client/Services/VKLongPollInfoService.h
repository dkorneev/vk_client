//
// Created by dkorneev on 1/5/13.
//



#import <Foundation/Foundation.h>
#import "RestKit.h"


@interface VKLongPollInfoService : NSObject <RKObjectLoaderDelegate>

- (id)initWithCompletionBlock:(void (^)(NSObject *))arg;

- (void)getLongPoolServerSettings;

@end