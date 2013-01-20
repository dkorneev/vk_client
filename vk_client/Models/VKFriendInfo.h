//
// Created by dkorneev on 11/25/12.
//



#import <Foundation/Foundation.h>
#import "ObjectMapping.h"


@interface VKFriendInfo : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSNumber *online;

@end