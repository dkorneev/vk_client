//
// Created by dkorneev on 11/25/12.
//



#import "VKFriendInfo.h"
#import "Support.h"


@implementation VKFriendInfo

+ (RKObjectMapping *)mapping {
    RKObjectMapping *friendsMapping = [RKObjectMapping mappingForClass:[self class]];
    [friendsMapping mapKeyPath:@"uid" toAttribute:@"userId"];
    [friendsMapping mapKeyPath:@"first_name" toAttribute:@"firstName"];
    [friendsMapping mapKeyPath:@"last_name" toAttribute:@"lastName"];
    [friendsMapping mapKeyPath:@"photo" toAttribute:@"photo"];
    [friendsMapping mapKeyPath:@"online" toAttribute:@"online"];
    return friendsMapping;
}

@end