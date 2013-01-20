//
// Created by dkorneev on 1/3/13.
//



#import "VKPhotoAttachment.h"


@implementation VKPhotoAttachment

+ (VKPhotoAttachment *)createFromDictionary:(NSDictionary *)arg {
    VKPhotoAttachment *photoAttachment = [[VKPhotoAttachment alloc] init];
    photoAttachment.pId = [arg valueForKey:@"pid"];
    if (!photoAttachment.pId)
        return nil;
    photoAttachment.ownerId = [arg valueForKey:@"owner_id"];
    photoAttachment.source = [arg valueForKey:@"src"];
    photoAttachment.sourceBig = [arg valueForKey:@"src_big"];
    return photoAttachment;
}

@end