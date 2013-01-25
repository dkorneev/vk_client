//
// Created by dkorneev on 1/5/13.
//



#import "VKLongPollInfo.h"
#import "RestKit.h"


@implementation VKLongPollInfo

+ (RKObjectMapping *)mapping {
    RKObjectMapping *longPollMapping = [RKObjectMapping mappingForClass:[self class]];
    [longPollMapping mapKeyPath:@"key" toAttribute:@"key"];
    [longPollMapping mapKeyPath:@"server" toAttribute:@"server"];
    [longPollMapping mapKeyPath:@"ts" toAttribute:@"ts"];
    return longPollMapping;
}

@end