//
// Created by dkorneev on 1/6/13.
//



#import <Foundation/Foundation.h>
#import <RKObjectMapping.h>


@interface VKLongPollResponse : NSObject

@property (nonatomic, strong) NSString *ts;
@property (nonatomic, strong) NSArray *updates;
@property (nonatomic, strong) NSString *failed;

+ (RKObjectMapping *)mapping;

@end