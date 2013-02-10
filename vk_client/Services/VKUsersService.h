//
// Created by dkorneev on 12/4/12.
//



#import <Foundation/Foundation.h>
#import "RestKit.h"


@interface VKUsersService : NSObject <RKObjectLoaderDelegate>

- (void)getUsersInfo:(NSString *)usersIds completionBlock:(void (^)(NSDictionary *))arg;

@end