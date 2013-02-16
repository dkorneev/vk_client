//
// Created by dkorneev on 11/22/12.
//


#import "VKFriendsService.h"
#import "VKFriendInfo.h"
#import "VKConstants.h"

@interface VKFriendsService ()
@property(nonatomic, copy) void (^completionBlock)(NSArray *);
@property(nonatomic, copy) void (^errorBlock)();
@property(nonatomic, strong) RKObjectLoader *loader;
@end

@implementation VKFriendsService

- (id)initWithCompletionBlock:(void (^)(NSArray *))completionBlock errorBlock:(void (^)())errorBlock {
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
        self.errorBlock = errorBlock;
    }
    return self;
}

- (void)getFriends {
    if (self.loader && [self.loader isLoading]) {
        NSLog(@"VKFriendsService - isLoading");
        return;
    }

    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    NSDictionary *params = @{
            @"uid" : userId,
            @"fields" : @"uid,first_name,last_name,nickname,photo",
            @"access_token" : accessToken};

    self.loader = [[RKObjectManager sharedManager] loaderWithURL:
            [RKURL URLWithBaseURL:[NSURL URLWithString:kBaseUrlString]
                     resourcePath:@"/friends.get?"
                  queryParameters:params]];

    [self.loader.mappingProvider setMapping:[VKFriendInfo mapping] forKeyPath:@"response"];
    self.loader.delegate = self;
    [self.loader send];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if (_completionBlock)
        _completionBlock(objects);
}

- (void)dealloc {
    [self.loader reset];
    self.loader.delegate = nil;
}

@end