//
// Created by dkorneev on 1/26/13.
//

#import "VKSendMessageResponse.h"
#import "RestKit.h"


@implementation VKSendMessageResponse

+ (RKObjectMapping *)mapping {
    RKObjectMapping *longPollMapping = [RKObjectMapping mappingForClass:[self class]];
    [longPollMapping mapKeyPath:@"response" toAttribute:@"retCode"];
    return longPollMapping;
}

@end