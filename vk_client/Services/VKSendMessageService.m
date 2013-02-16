//
// Created by dkorneev on 1/25/13.
//

#import "VKSendMessageService.h"
#import "VKSendMessageResponse.h"
#import "VKConstants.h"


@interface VKSendMessageService ()
@property(nonatomic, strong) RKObjectLoader *loader;
@property(nonatomic, strong) id <VKSendMessageServiceProtocol> delegate;
@property(nonatomic, strong) NSNumber *userId;
@end

@implementation VKSendMessageService

- (id)initWithDelegate:(id <VKSendMessageServiceProtocol>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)sendMessage:(NSNumber *)uid messageText:(NSString *)message {
    self.userId = uid;
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
    NSLog(@"ERROR while sending message!");
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    NSLog(@"VKSendMessageService - didLoadObject");
    if (_delegate)
        [_delegate sendMessageSuccess:self.userId];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"VKSendMessageService - didLoadObjects");
    if (_delegate)
        [_delegate sendMessageSuccess:self.userId];
}

@end