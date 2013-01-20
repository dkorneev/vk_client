//
// Created by dkorneev on 11/22/12.
//


#import <Foundation/Foundation.h>
#import "Network.h"
#import "RestKit.h"

@interface VKFriendsService : NSObject <RKObjectLoaderDelegate>

- (id)initWithCompletionBlock:(void (^)(NSArray *))arg;

- (void)getFriends;

@end