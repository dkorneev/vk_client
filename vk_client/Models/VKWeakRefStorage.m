//
// Created by dkorneev on 2/13/13.
//

#import "VKWeakRefStorage.h"


@interface VKWeakRefStorage ()
@property(nonatomic, weak) id ref;

@end

@implementation VKWeakRefStorage

+ (VKWeakRefStorage *)create:(__weak id)ref {
    return [[VKWeakRefStorage alloc] initWithRef:ref];
}

- (id)initWithRef:(__weak id)ref {
    self = [super init];
    if (self) {
        self.ref = ref;
    }
    return self;
}

- (__weak id)reference {
    return self.ref;
}

@end