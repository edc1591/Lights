//
//  HMCharacteristic+RACSignalSupport.m
//  Lights
//
//  Created by Evan Coleman on 11/12/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HMCharacteristic+RACSignalSupport.h"

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

@end
