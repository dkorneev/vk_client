//
// Created by admin on 12/3/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RestKit.h"
#import "VKDialogsService.h"
#import "SBJson.h"
#import "VKDialogInfo.h"


@interface VKDialogsService ()
@property(nonatomic, copy) void (^completionBlock)(NSArray *);

@end

@implementation VKDialogsService

- (id)initWithCompletionBlock: (void(^)(NSArray *))arg {
    self = [super init];
    if (self) {
        self.completionBlock = arg;
    }
    return self;
}

- (void)getDialogs {
    NSString *tokenParam = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    NSString *path = [@"/messages.getDialogs?count=100&access_token=" stringByAppendingString:tokenParam];
    [[RKClient sharedClient] get:path delegate:self];
}

- (void)getDialogHistory:(NSString *)userId {
    NSString *tokenParam = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    NSString *path = [NSString stringWithFormat:@"/messages.getHistory?uid=%@&count=20&access_token=%@",
                    userId, tokenParam];
    [[RKClient sharedClient] get:path delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSString* newStr = [[NSString alloc] initWithData:response.body
                                             encoding:NSUTF8StringEncoding];

    NSMutableArray *dialogsArray = [[NSMutableArray alloc] init];
    NSArray *array = [[newStr JSONValue] valueForKey:@"response"];
    for (NSUInteger i = 1; i < array.count; ++i) {
        NSDictionary *currentValue = [array objectAtIndex:i];
        VKDialogInfo *curDialog = [[VKDialogInfo alloc] init];

        curDialog.deleted = [currentValue valueForKey:@"deleted"];
        if (curDialog.deleted)
            continue;

        curDialog.body = [currentValue valueForKey:@"body"];
        curDialog.title = [currentValue valueForKey:@"title"];
        curDialog.userId = [currentValue valueForKey:@"uid"];
        curDialog.date = [currentValue valueForKey:@"date"];
        curDialog.readState = [currentValue valueForKey:@"read_state"];

        curDialog.chatId = [currentValue valueForKey:@"chat_id"];
        curDialog.chatActive = [currentValue valueForKey:@"chat_active"];
        curDialog.usersCount = [currentValue valueForKey:@"users_count"];
        curDialog.adminId = [currentValue valueForKey:@"admin_id"];

        [dialogsArray addObject:curDialog];
    }

    if (_completionBlock)
        _completionBlock(dialogsArray);
}

@end