//
//  HMHomeManager+RACSignalSupport.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HMHomeManager+RACSignalSupport.h"

@implementation HMHomeManager (RACSignalSupport)

- (RACSignal *)rac_addHomeWithName:(NSString *)name {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self addHomeWithName:name completionHandler:^(HMHome *home, NSError *error) {
            if (error == nil) {
                [subscriber sendNext:home];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_removeHome:(HMHome *)home {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self removeHome:home completionHandler:^(NSError *error) {
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
