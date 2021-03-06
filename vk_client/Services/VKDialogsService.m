//
// Created by dkorneev on 12/3/12.
//



#import "RestKit.h"
#import "VKDialogsService.h"
#import "SBJson.h"
#import "VKDialogInfo.h"
#import "VKConstants.h"


@interface VKDialogsService ()
@property(nonatomic, copy) void (^completionBlock)(NSArray *);
@property(nonatomic, strong) RKClient *rkClient;

@end

@implementation VKDialogsService

- (id)initWithCompletionBlock:(void (^)(NSArray *))arg {
    self = [super init];
    if (self) {
        self.completionBlock = arg;
    }
    return self;
}

- (void)getDialogs {
    NSString *tokenParam = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    NSString *path = [@"/messages.getDialogs?count=200&access_token=" stringByAppendingString:tokenParam];
    [[RKClient sharedClient] get:path delegate:self];
}

- (void)getDialogHistory:(NSNumber *)userId {
    NSString *tokenParam = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    NSString *path = [NSString stringWithFormat:@"/messages.getHistory?uid=%@&count=200&access_token=%@",
                                                userId.stringValue, tokenParam];
    self.rkClient = [RKClient clientWithBaseURLString:kBaseUrlString];
    [self.rkClient get:path delegate:self];
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    NSString *newStr = [[NSString alloc] initWithData:response.body
                                             encoding:NSUTF8StringEncoding];

    NSMutableArray *dialogsArray = [[NSMutableArray alloc] init];
    NSArray *array = [[newStr JSONValue] valueForKey:@"response"];
    for (NSUInteger i = 1; i < array.count; ++i) {
        NSDictionary *currentValue = [array objectAtIndex:i];
        VKDialogInfo *curDialog = [VKDialogInfo createFromDictionary:currentValue];
        if (curDialog)
            [dialogsArray addObject:curDialog];
    }

    if (_completionBlock)
        _completionBlock(dialogsArray);
}

- (BOOL)isLoading {
    return ([self.rkClient requestQueue].count != 0);
}

@end