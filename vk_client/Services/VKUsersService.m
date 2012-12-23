//
// Created by admin on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VKUsersService.h"
#import "VKFriendInfo.h"

@interface VKUsersService()
@property(nonatomic, copy) void (^completionBlock)(NSDictionary  *);
@end

@implementation VKUsersService

- (id)initWithCompletionBlock: (void(^)(NSDictionary *))arg {
    self = [super init];
    if (self) {
        self.completionBlock = arg;
    }
    return self;
}

// принимает параметр usersIds - строку с id пользователей
// (перечислены через через запятую), для которых нужна информация
// пример: "123,234,456,654"
- (void)getUsersInfo:(NSString *)usersIds {
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[
            usersIds,
            @"uid,first_name,last_name,photo,online",
            [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]
    ] forKeys:@[@"uids", @"fields", @"access_token"] ];

    RKObjectLoader *loader = nil;
    loader = [[RKObjectManager sharedManager] loaderWithURL:
            [RKURL URLWithBaseURL:[NSURL URLWithString:@"https://api.vk.com/method"]
                     resourcePath:@"/users.get?"
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
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];

    for (VKFriendInfo *curUser in objects)
        [ret setObject:curUser forKey:curUser.userId];

    if (_completionBlock)
        _completionBlock(ret);
}

@end