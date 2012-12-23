//
// Created by admin on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RestKit.h"


@interface VKUsersService : NSObject <RKObjectLoaderDelegate>

- (id)initWithCompletionBlock:(void (^)(NSDictionary *))arg;

- (void)getUsersInfo:(NSString *)usersIds;

@end