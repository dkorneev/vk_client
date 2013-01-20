//
// Created by dkorneev on 12/3/12.
//



#import <Foundation/Foundation.h>

@interface VKDialogsService : NSObject <RKRequestDelegate>
- (id)initWithCompletionBlock:(void (^)(NSArray *))arg;

- (void)getDialogs;

- (void)getDialogHistory:(NSString *)userId;

@end