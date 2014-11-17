//
//  HMHome+RACSignalSupport.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HMHome+RACSignalSupport.h"

@implementation HMHome (RACSignalSupport)

- (RACSignal *)rac_addRoomWithName:(NSString *)name {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self addRoomWithName:name completionHandler:^(HMRoom *room, NSError *error) {
            if (error == nil) {
                [subscriber sendNext:room];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_removeRoom:(HMRoom *)room {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self removeRoom:room completionHandler:^(NSError *error) {
            if (error != nil) {
                [subscriber sendError:error];
            } else {
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_addAccessory:(HMAccessory *)accessory {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self addAccessory:accessory completionHandler:^(NSError *error) {
            if (error != nil) {
                [subscriber sendError:error];
            } else {
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_removeAccessory:(HMAccessory *)accessory {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self removeAccessory:accessory completionHandler:^(NSError *error) {
            if (error != nil) {
                [subscriber sendError:error];
            } else {
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_assignAccessory:(HMAccessory *)accessory toRoom:(HMRoom *)room {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self assignAccessory:accessory toRoom:room completionHandler:^(NSError *error) {
            if (error != nil) {
                [subscriber sendError:error];
            } else {
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

@end
