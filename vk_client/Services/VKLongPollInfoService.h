//
// Created by admin on 1/5/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RestKit.h"


@interface VKLongPollInfoService : NSObject <RKObjectLoaderDelegate>

- (id)initWithCompletionBlock:(void (^)(NSObject *))arg;

- (void)getLongPoolServerSettings;

@end