//
// Created by dkorneev on 1/3/13.
//



#import "VKDocumentAttachment.h"


@implementation VKDocumentAttachment

+ (VKDocumentAttachment *)createFromDictionary:(NSDictionary *)arg {
    VKDocumentAttachment *attachment = [[VKDocumentAttachment alloc] init];
    attachment.dId = [arg valueForKey:@"did"];
    if (!attachment.dId)
        return nil;
    attachment.ownerId = [arg valueForKey:@"owner_id"];
    attachment.title = [arg valueForKey:@"title"];
    attachment.size = [arg valueForKey:@"size"];
    attachment.ext = [arg valueForKey:@"ext"];
    attachment.url = [arg valueForKey:@"url"];
    return attachment;
}

@end