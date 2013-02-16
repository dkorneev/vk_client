//
// Created by dkorneev on 2/13/13.
//

#import <Foundation/Foundation.h>


@interface VKWeakRefStorage : NSObject

+ (VKWeakRefStorage *)create:(__weak id)ref;

- (__weak id)reference;

@end