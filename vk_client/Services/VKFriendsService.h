//
// Created by admin on 11/22/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import "Network.h"
#import "RestKit.h"

@interface VKFriendsService : NSObject <RKObjectLoaderDelegate>

- (id)initWithCompletionBlock:(void (^)(NSArray *))arg;

- (void)getFriends;

@end