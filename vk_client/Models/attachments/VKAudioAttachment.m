//
// Created by dkorneev on 1/3/13.
//



#import "VKAudioAttachment.h"


@implementation VKAudioAttachment

+ (VKAudioAttachment *)createFromDictionary:(NSDictionary *)arg {
    VKAudioAttachment *attachment = [[VKAudioAttachment alloc] init];
    attachment.aId = [arg valueForKey:@"aid"];
    if (!attachment.aId)
        return nil;
    attachment.ownerId = [arg valueForKey:@"owner_id"];
    attachment.performer = [arg valueForKey:@"performer"];
    attachment.title = [arg valueForKey:@"title"];
    attachment.duration = [arg valueForKey:@"duration"];
    attachment.url = [arg valueForKey:@"url"];
    return attachment;
}

@end