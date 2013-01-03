//
// Created by admin on 1/3/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface VKDocumentAttachment : NSObject

@property (nonatomic, strong) NSNumber *dId;
@property (nonatomic, strong) NSNumber *ownerId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSString *ext;
@property (nonatomic, strong) NSString *url;

+ (VKDocumentAttachment *)createFromDictionary:(NSDictionary *)arg;

@end