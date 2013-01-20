//
// Created by dkorneev on 11/22/12.
//


#import "VKFriendsService.h"
#import "VKFriendInfo.h"

@interface VKFriendsService ()
@property(nonatomic, copy) void (^completionBlock)(NSArray *);
@end

@implementation VKFriendsService

- (id)initWithCompletionBlock: (void(^)(NSArray *))arg {
    self = [super init];
    if (self) {
        self.completionBlock = arg;
    }
    return self;
}

- (void)getFriends {
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[
            [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"],
            @"uid,first_name,last_name,nickname,photo",
            [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]
    ] forKeys:@[@"uid", @"fields", @"access_token"] ];

    RKObjectLoader *loader = nil;
    loader = [[RKObjectManager sharedManager] loaderWithURL:
            [RKURL URLWithBaseURL:[NSURL URLWithString:@"https://api.vk.com/method"]
                     resourcePath:@"/friends.get?"
                  queryParameters:params]];

    RKObjectMapping *friendsMapping = [RKObjectMapping mappingForClass:[VKFriendInfo class]];
    [friendsMapping mapKeyPath:@"uid" toAttribute:@"userId"];
    [friendsMapping mapKeyPath:@"first_name" toAttribute:@"firstName"];
    [friendsMapping mapKeyPath:@"last_name" toAttribute:@"lastName"];
    [friendsMapping mapKeyPath:@"photo" toAttribute:@"photo"];
    [friendsMapping mapKeyPath:@"online" toAttribute:@"online"];

    [loader.mappingProvider setMapping:friendsMapping forKeyPath:@"response"];

    loader.delegate = self;
    [loader send];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if (_completionBlock)
        _completionBlock(objects);
}

@end