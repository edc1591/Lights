//
//  HMCharacteristic+RACSignalSupport.m
//  Lights
//
//  Created by Evan Coleman on 11/12/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HMCharacteristic+RACSignalSupport.h"

#import "NSError+HomeKitExtensions.h"

@implementation HMCharacteristic (RACSignalSupport)

- (RACSignal *)rac_writeValue:(id)value {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self writeValue:value completionHandler:^(NSError *error) {
            if (error != nil) {
                [subscriber sendError:error];
            } else {
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_observeValue {
    return [[self rac_readValue]
                concat:RACObserve(self, value)];
}

- (RACSignal *)rac_readValue {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self readValueWithCompletionHandler:^(NSError *error) {
            if (error != nil && [error hk_isFatal]) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:self.value];
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

@end
