//
// Created by admin on 12/3/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface VKDialogsService : NSObject <RKRequestDelegate>
- (id)initWithCompletionBlock:(void (^)(NSArray *))arg;

- (void)getDialogs;

- (void)getDialogHistory:(NSString *)userId;

@end