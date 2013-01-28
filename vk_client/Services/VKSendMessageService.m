//
// Created by dkorneev on 1/25/13.
//

#import "VKSendMessageService.h"
#import "VKSendMessageResponse.h"
#import "VKConstants.h"


@interface VKSendMessageService ()
@property(nonatomic, strong) RKObjectLoader *loader;
@property(nonatomic, copy) void (^completionBlock)();
@property(nonatomic, copy) void (^errorBlock)();
@end

@implementation VKSendMessageService

- (id)initWithCompletionBlock:(void(^)())completionBlock errorBlock:(void(^)())errorBlock {
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
        self.errorBlock = errorBlock;
    }
    return self;
}

- (void)sendMessage:(NSNumber *)uid messageText:(NSString *)message {
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    NSDictionary *params = @{
            @"uid" : uid.stringValue,
            @"message" : message,
            @"access_token" : accessToken};

    self.loader = [[RKObjectManager sharedManager] loaderWithURL:
            [RKURL URLWithBaseURL:[NSURL URLWithString:kBaseUrlString]
                     resourcePath:@"/messages.send?"
                  queryParameters:params]];

    [self.loader setObjectMapping:[VKSendMessageResponse mapping]];
    self.loader.delegate = self;
    [self.loader send];
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    if (self.errorBlock)
        self.errorBlock();
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    NSLog(@"VKSendMessageService - didLoadObject");
    if (self.completionBlock)
        self.completionBlock();
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"VKSendMessageService - didLoadObjects");
    if (self.completionBlock)
        self.completionBlock();
}

@end