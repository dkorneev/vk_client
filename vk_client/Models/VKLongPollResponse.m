//
// Created by dkorneev on 1/6/13.
//



#import "VKLongPollResponse.h"
#import "RestKit.h"


@implementation VKLongPollResponse

+ (RKObjectMapping *)mapping {
    RKObjectMapping *longPollMapping = [RKObjectMapping mappingForClass:[self class]];
    [longPollMapping mapKeyPath:@"ts" toAttribute:@"ts"];
    [longPollMapping mapKeyPath:@"updates" toAttribute:@"updates"];
    [longPollMapping mapKeyPath:@"failed" toAttribute:@"failed"];
    return longPollMapping;
}

@end