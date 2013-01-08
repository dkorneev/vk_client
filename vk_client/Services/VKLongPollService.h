//
// Created by admin on 1/6/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RestKit.h"


@interface VKLongPollService : NSObject <RKObjectLoaderDelegate>

- (id)initWithKey:(NSString *)key server:(NSString *)server ts:(NSString *)ts completionBlock:(void (^)(NSObject *))block;

- (void)start;

@end