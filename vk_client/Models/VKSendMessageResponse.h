//
// Created by dkorneev on 1/26/13.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;


@interface VKSendMessageResponse : NSObject

@property (nonatomic, strong) NSNumber *retCode;

+ (RKObjectMapping *)mapping;

@end