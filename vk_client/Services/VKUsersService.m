//
// Created by dkorneev on 12/4/12.
//



#import "VKUsersService.h"
#import "VKFriendInfo.h"
#import "VKConstants.h"

@interface VKUsersService()
@property(nonatomic, copy) void (^completionBlock)(NSDictionary  *);
@end

@implementation VKUsersService

// принимает параметр usersIds - строку с id пользователей
// (перечислены через через запятую), для которых нужна информация
// пример: "123,234,456,654"
- (void)getUsersInfo:(NSString *)usersIds completionBlock: (void(^)(NSDictionary *))arg {
    self.completionBlock = arg;
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[
            usersIds,
            @"uid,first_name,last_name,photo,online",
            [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]
    ] forKeys:@[@"uids", @"fields", @"access_token"] ];

    RKObjectLoader *loader = nil;
    loader = [[RKObjectManager sharedManager] loaderWithURL:
            [RKURL URLWithBaseURL:[NSURL URLWithString:kBaseUrlString]
                     resourcePath:@"/users.get?"
                  queryParameters:params]];

    [loader.mappingProvider setMapping:[VKFriendInfo mapping]forKeyPath:@"response"];

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
        [ret setObject:curUser forKey:curUser.userId.stringValue];

    if (_completionBlock)
        _completionBlock(ret);
}

@end