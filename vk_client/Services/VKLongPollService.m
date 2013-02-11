//
// Created by dkorneev on 1/6/13.
//


#import "VKLongPollService.h"
#import "VKLongPollResponse.h"
#import "VKLongPollInfoService.h"
#import "VKLongPollInfo.h"
#import "RKManagedObjectLoader.h"
#import "VKAbstractEvent.h"
#import "VKMessageEvent.h"
#import "VKUserStatusEvent.h"

@interface VKLongPollService ()
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *server;
@property(nonatomic, copy) NSString *ts;
@property(nonatomic) BOOL breakFlag;
@property(nonatomic, strong) NSMutableArray *messagesObservers;
@property(nonatomic, strong) NSMutableArray *userStatusObservers;
@property(nonatomic, strong) VKLongPollInfoService *longPollInfoService;
@property(nonatomic, strong) RKObjectLoader *loader;
@property(nonatomic, strong) id <VKLongPollDelegateProtocol> delegate;

@end

@implementation VKLongPollService

- (id)initWithDelegate:(id <VKLongPollDelegateProtocol>)delegate; {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.breakFlag = NO;
        self.messagesObservers = [NSMutableArray new];
        self.userStatusObservers = [NSMutableArray new];
    }
    return self;
}

- (void)stop {
    self.breakFlag = YES;
}

- (void)start {
    NSLog(@"VKLongPollService was launched!");
    self.longPollInfoService = [[VKLongPollInfoService alloc] initWithCompletionBlock:^(NSObject *object) {
        VKLongPollInfo *info = (VKLongPollInfo *) object;
        self.key = info.key;
        self.server = info.server;
        self.ts = info.ts;

        NSLog(@"LONG_POLL_KEY: %@", info.key);
        NSLog(@"LONG_POLL_SERVER: %@", info.server);
        NSLog(@"LONG_POLL_TS: %@", info.ts);

        [self sendLongPollRequest];
    }];
    [self.longPollInfoService getLongPoolServerSettings];
}

- (void)restart {
    [self start];
}

- (void)sendLongPollRequest {
    NSString *resourcePath = [NSString stringWithFormat:@"?act=a_check&key=%@&ts=%@&wait=25&mode=0", self.key, self.ts];
    NSString *baseUrl = [NSString stringWithFormat:@"http://%@", self.server];

    if (!self.loader) {
        [self.loader reset];
    }

    self.loader = [[RKObjectManager sharedManager] loaderWithURL:
            [RKURL URLWithBaseURL:[NSURL URLWithString:baseUrl] resourcePath:resourcePath]];
    [self.loader setObjectMapping:[VKLongPollResponse mapping]];
    self.loader.delegate = self;
    [self.loader send];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"VKLongPollService - didFailWithError");
    [self restart];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    VKLongPollResponse *responseObject = (VKLongPollResponse *) object;
    self.ts = responseObject.ts;

    if (responseObject.failed) {
        NSLog(@"long poll failed!");
        [self restart];
        return;
    }

    if (responseObject.updates.count) {
        NSLog(@"ts: %@, updates count: %d", responseObject.ts, responseObject.updates.count);
        [self.delegate handleResponseWithUpdates:responseObject.updates];
    }

    if (!self.breakFlag)
        [self sendLongPollRequest];
}

@end