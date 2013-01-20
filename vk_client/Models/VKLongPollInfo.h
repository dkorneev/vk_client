//
// Created by dkorneev on 1/5/13.
//



#import <Foundation/Foundation.h>


@interface VKLongPollInfo : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *ts;
@end