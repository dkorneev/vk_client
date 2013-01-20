//
// Created by dkorneev on 1/3/13.
//



#import <Foundation/Foundation.h>


@interface VKPhotoAttachment : NSObject

@property (nonatomic, strong) NSNumber *pId;
@property (nonatomic, strong) NSNumber *ownerId;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *sourceBig;

+ (VKPhotoAttachment *)createFromDictionary:(NSDictionary *)arg;

@end