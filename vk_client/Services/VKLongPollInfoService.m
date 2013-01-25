//
// Created by dkorneev on 1/5/13.
//



#import "VKLongPollInfoService.h"
#import "VKLongPollInfo.h"


@interface VKLongPollInfoService ()
@property(nonatomic, copy) void (^completionBlock)(NSObject *);
@end

@implementation VKLongPollInfoService

- (id)initWithCompletionBlock: (void(^)(NSObject *))arg {
    self = [super init];
    if (self) {
        self.completionBlock = arg;
    }
    return self;
}

- (void)getLongPoolServerSettings {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    NSString *resourcePath = [NSString stringWithFormat:@"/messages.getLongPollServer?access_token=%@", token];
    RKObjectLoader *loader = [[RKObjectManager sharedManager] loaderWithURL:
            [RKURL URLWithBaseURL:[NSURL URLWithString:@"https://api.vk.com/method"] resourcePath:resourcePath]];

    [loader.mappingProvider setMapping:[VKLongPollInfo mapping] forKeyPath:@"response"];
    loader.delegate = self;
    [loader send];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"long poll info - fail");
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    if (_completionBlock)
        _completionBlock(object);
}

@end