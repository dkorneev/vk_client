//
// Created by dkorneev on 1/6/13.
//


#import "VKLongPollService.h"
#import "VKLongPollResponse.h"

@interface VKLongPollService ()
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *server;
@property(nonatomic, copy) NSString *ts;
@property(nonatomic) BOOL breakFlag;
@property(nonatomic, strong) NSMutableArray *messagesObservers;
@property(nonatomic, strong) NSMutableArray *userStatusObservers;
@end

@implementation VKLongPollService

static VKLongPollService *_sharedInstance = nil;

// возвращает актуальный объект
+ (VKLongPollService *)getSharedInstance {
    if (!_sharedInstance)
        NSLog(@"Something is gone wrong! Asking for nil VKLongPollService-object.");
    return _sharedInstance;
}

- (id)initWithKey:(NSString *)key server:(NSString *)server ts:(NSString *)ts {
    self = [super init];
    if (self) {
        NSLog(@"LONG_POLL_KEY: %@", key);
        NSLog(@"LONG_POLL_SERVER: %@", server);
        NSLog(@"LONG_POLL_TS: %@", ts);

        self.key = key;
        self.server = server;
        self.ts = ts;
        self.breakFlag = NO;

        self.messagesObservers = [NSMutableArray new];
        self.userStatusObservers = [NSMutableArray new];
    }
    if (_sharedInstance)
        [_sharedInstance stop];
    _sharedInstance = self;
    return self;
}

- (void)stop {
    self.breakFlag = YES;
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
    [longPollMapping mapKeyPath:@"failed" toAttribute:@"failed"];

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

    if (responseObject.failed) {
        NSLog(@"long poll failed!");
        [self stop];
    }

    if (responseObject.updates.count) {
        NSLog(@"ts: %@, updates count: %d", responseObject.ts, responseObject.updates.count);
        [self notifyListeners:responseObject.updates];
    }

    if (!self.breakFlag)
        [self sendLongPollRequest];
}

- (void)notifyListeners:(NSArray *)updates {

    NSLog(@"notifyListeners");

//    for (NSArray *curUpdate in updates) {
//        unsigned eventType = ((NSNumber *)[curUpdate objectAtIndex:0]).unsignedIntValue;
//        NSInteger userId = -1 * ((NSNumber *)[curUpdate objectAtIndex:1]).integerValue;
//        short flags = ((NSNumber *)[curUpdate objectAtIndex:2]).shortValue;
//        switch (eventType) {
//            case 1:
//            case 2:
//            case 3:
//                break;
//            case 4: {
//
//                // расшифровка установленных флагов
//                BOOL unread = (BOOL)(flags & 1);
//                BOOL outbox = (BOOL)(flags & 2);
//                BOOL replied = (BOOL)(flags & 4);
//                BOOL important = (BOOL)(flags & 8);
//                BOOL chat = (BOOL)(flags & 16);
//                BOOL friends = (BOOL)(flags & 32);
//                BOOL spam = (BOOL)(flags & 64);
//                BOOL deleted = (BOOL)(flags & 128);
//                BOOL fixed = (BOOL)(flags & 256);
//                BOOL media = (BOOL)(flags & 512);
//
//                for (id<VKLongPollListenerProtocol>observer in self.messagesObservers)
//                    [observer handleEvent];
//                NSLog(@"\tmessage event [code: %d]", eventType);
//                break;
//            }
//            case 8:
//                for (id<VKLongPollListenerProtocol>observer in self.userStatusObservers)
//                    [observer handleEvent];
//                NSLog(@"\t[%d] - came online", userId);
//                break;
//            case 9:
//                for (id<VKLongPollListenerProtocol>observer in self.userStatusObservers)
//                    [observer handleEvent];
//                NSLog(@"\t[%d] - went offline", userId);
//                break;
//            default:
//                NSLog(@"\tunhandled event [code: %d]", eventType);
//        }
//    }
}

- (void)addMessagesEventObserver:(id<VKLongPollListenerProtocol>)object {
    [self.messagesObservers addObject:object];
}

- (void)removeMessagesEventObserver:(id<VKLongPollListenerProtocol>)object {
    [self.messagesObservers removeObject:object];
}

- (void)addUserStatusEventObserver:(id<VKLongPollListenerProtocol>)object {
    [self.userStatusObservers addObject:object];
}

- (void)removeUserStatusEventObserver:(id<VKLongPollListenerProtocol>)object {
    [self.userStatusObservers removeObject:object];
}

@end