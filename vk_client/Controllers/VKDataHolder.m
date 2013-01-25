//
// Created by dkorneev on 1/25/13.
//

#import "VKDataHolder.h"
#import "VKFriendsService.h"


@interface VKDataHolder ()

// Services:
@property(nonatomic, strong) VKFriendsService *friendsService;


// DATA:
@property(nonatomic, strong) NSArray *usersInfo;
@property(nonatomic, strong) NSArray *friendsIds;
@property(nonatomic, strong) NSArray *dialogsInfo;

@end

@implementation VKDataHolder

+ (VKDataHolder *)sharedInstance {
    static VKDataHolder *_instance = nil;
    if (!_instance) {
        _instance = [[VKDataHolder alloc] init];
    }
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.usersInfo = [NSArray new];
        self.dialogsInfo = [NSArray new];
        self.friendsIds = [NSArray new];
    }
    return self;
}


- (void)loadFriendsInfo:(void (^)(NSArray *))argCompletionBlock {

    void (^completionBlock)(NSArray *) = ^(NSArray *array) {

    };

    void (^errorBlock)() = ^() {

    };

    if (self.friendsService)
        self.friendsService = [[VKFriendsService alloc] initWithCompletionBlock:completionBlock errorBlock:errorBlock];
    [self.friendsService getFriends];
}

@end