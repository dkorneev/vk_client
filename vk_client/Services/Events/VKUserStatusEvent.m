//
// Created by dkorneev on 1/28/13.
//

#import "VKUserStatusEvent.h"


@implementation VKUserStatusEvent

+(VKUserStatusEvent *)createUserStatusEvent:(NSNumber *)id online:(BOOL)online {
    return [[VKUserStatusEvent alloc] initWithUserId:id online:online];
}

- (id)initWithUserId:(NSNumber *)id online:(BOOL)online {
    self = [super init];
    if (self) {
        self.userId = id;
        self.online = online;
    }
    return self;
}

@end