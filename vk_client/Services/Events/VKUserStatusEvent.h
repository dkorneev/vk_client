//
// Created by dkorneev on 1/28/13.
//

#import <Foundation/Foundation.h>
#import "VKAbstractEvent.h"


@interface VKUserStatusEvent : VKAbstractEvent

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic) BOOL online;

+ (VKUserStatusEvent *)createUserStatusEvent:(NSNumber *)id1 online:(BOOL)online;

- (id)initWithUserId:(NSNumber *)id1 online:(BOOL)online;

@end