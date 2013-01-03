//
// Created by admin on 12/3/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VKDialogInfo.h"
#import "VKPhotoAttachment.h"
#import "VKAudioAttachment.h"
#import "VKDocumentAttachment.h"


@implementation VKDialogInfo

+ (VKDialogInfo *)createFromDictionary:(NSDictionary *)arg {
    VKDialogInfo *curDialog = [[VKDialogInfo alloc] init];

    curDialog.deleted = [arg valueForKey:@"deleted"];
    if (curDialog.deleted)
        return nil;

    curDialog.body = [arg valueForKey:@"body"];
    curDialog.title = [arg valueForKey:@"title"];
    curDialog.userId = [arg valueForKey:@"uid"];
    curDialog.date = [arg valueForKey:@"date"];
    curDialog.readState = [arg valueForKey:@"read_state"];

    // для групповых диалогов
    curDialog.chatId = [arg valueForKey:@"chat_id"];
    curDialog.chatActive = [arg valueForKey:@"chat_active"];
    curDialog.usersCount = [arg valueForKey:@"users_count"];
    curDialog.adminId = [arg valueForKey:@"admin_id"];

    NSArray *attachments = [arg valueForKey:@"attachments"];
    if (attachments) {
        NSMutableArray *mappedAttachments = [NSMutableArray new];
        for (NSDictionary *curAttachment in attachments) {
            NSString *type = [curAttachment valueForKey:@"type"];
            if ([type isEqualToString:@"photo"]) {
                VKPhotoAttachment *photo = [VKPhotoAttachment createFromDictionary:[curAttachment valueForKey:@"photo"]];
                [mappedAttachments addObject:photo];

            } else if ([type isEqualToString:@"audio"]) {
                VKAudioAttachment *audio = [VKAudioAttachment createFromDictionary:[curAttachment valueForKey:@"audio"]];
                [mappedAttachments addObject:audio];

            } else if ([type isEqualToString:@"doc"]) {
                VKDocumentAttachment *doc = [VKDocumentAttachment createFromDictionary:[curAttachment valueForKey:@"doc"]];
                [mappedAttachments addObject:doc];

            } else continue;
        }
        if (mappedAttachments.count)
            curDialog.attachments = mappedAttachments;
    }

    return curDialog;
}

- (BOOL)isGroupDialog {
    return (self.chatId != nil);
}

- (BOOL)hasMediaAttachment {
    return (self.attachments != nil);
}

@end