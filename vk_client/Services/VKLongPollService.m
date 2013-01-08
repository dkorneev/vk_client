//
// Created by admin on 1/6/13.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "VKLongPollService.h"
#import "VKLongPollResponse.h"

@interface VKLongPollService ()
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *server;
@property(nonatomic, copy) NSString *ts;
@property(nonatomic, copy) void (^completionBlock)(NSObject *);
@end

@implementation VKLongPollService

- (id)initWithKey:(NSString *)key server:(NSString *)server ts:(NSString *)ts completionBlock:(void (^)(NSObject *))block {
    self = [super init];
    if (self) {
        NSLog(@"LONG_POLL_KEY: %@", key);
        NSLog(@"LONG_POLL_SERVER: %@", server);
        NSLog(@"LONG_POLL_TS: %@", ts);

        self.key = key;
        self.server = server;
        self.ts = ts;
        self.completionBlock = block;
    }
    return self;
}

- (void)start {
    [self sendLongPollRequest];
}

- (void)sendLongPollRequest {
    NSString *resourcePath = [NSString stringWithFormat:@"?act=a_check&key=%@&ts=%@&wait=25&mode=2", self.key, self.ts];
    NSString *baseUrl = [NSString stringWithFormat:@"http://%@", self.server];

    RKObjectLoader *loader = [[RKObjectManager sharedManager] loaderWithURL:
            [RKURL URLWithBaseURL:[NSURL URLWithString:baseUrl] resourcePath:resourcePath]];

    RKObjectMapping *longPollMapping = [RKObjectMapping mappingForClass:[VKLongPollResponse class]];
    [longPollMapping mapKeyPath:@"ts" toAttribute:@"ts"];
    [longPollMapping mapKeyPath:@"updates" toAttribute:@"updates"];

    [loader setObjectMapping:longPollMapping];
    loader.delegate = self;
    [loader send];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"VKLongPollService - didFailWithError");
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    VKLongPollResponse *responseObject = (VKLongPollResponse *) object;
    self.ts = responseObject.ts;
    NSLog(@"ts: %@, updates count: %d", responseObject.ts, responseObject.updates.count);
    [self sendLongPollRequest];

    if (_completionBlock)
        _completionBlock(object);
}

@end