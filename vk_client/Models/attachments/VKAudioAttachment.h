//
// Created by admin on 1/3/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface VKAudioAttachment : NSObject

@property (nonatomic, strong) NSNumber *aId;
@property (nonatomic, strong) NSNumber *ownerId;
@property (nonatomic, strong) NSString *performer;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSString *url;

+ (VKAudioAttachment *)createFromDictionary:(NSDictionary *)arg;

@end