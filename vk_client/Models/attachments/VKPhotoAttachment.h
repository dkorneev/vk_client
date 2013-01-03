//
// Created by admin on 1/3/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface VKPhotoAttachment : NSObject

@property (nonatomic, strong) NSNumber *pId;
@property (nonatomic, strong) NSNumber *ownerId;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *sourceBig;

+ (VKPhotoAttachment *)createFromDictionary:(NSDictionary *)arg;

@end