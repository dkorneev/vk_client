//
// Created by dkorneev on 12/4/12.
//



#import <Foundation/Foundation.h>
#import "RestKit.h"


@interface VKUsersService : NSObject <RKObjectLoaderDelegate>

- (id)initWithCompletionBlock:(void (^)(NSDictionary *))arg;

- (void)getUsersInfo:(NSString *)usersIds;

@end