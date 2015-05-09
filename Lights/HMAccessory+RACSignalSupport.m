//
//  HMAccessory+RACSignalSupport.m
//  Lights
//
//  Created by Evan Coleman on 11/12/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HMAccessory+RACSignalSupport.h"

@implementation HMAccessory (RACSignalSupport)

- (RACSignal *)rac_getCharacterisitic:(NSString *)characteristic {
    @weakify(self);
    return [[[[[self.services.rac_sequence
                    filter:^BOOL(HMService *service) {
                        return [service.serviceType isEqualToString:HMServiceTypeLightbulb] || [service.serviceType isEqualToString:HMServiceTypeSwitch];
                    }]
                    take:1]
                    map:^NSArray *(HMService *service) {
                        return [[service.characteristics.rac_sequence
                                    filter:^BOOL(HMCharacteristic *c) {
                                        return [c.characteristicType isEqualToString:characteristic];
                                    }]
                                    array];
                    }]
                    signal]
                    tryMap:^HMCharacteristic *(NSArray *characteristics, NSError *__autoreleasing *errorPtr) {
                        @strongify(self);
                        if ([characteristics count] == 0) {
                            NSLog(@"No %@ found for %@", characteristic, self.name);
                            return nil;
                        } else {
                            HMCharacteristic *characteristic = [characteristics firstObject];
                            return characteristic;
                        }
                    }];
}

- (RACSignal *)rac_rename:(NSString *)name {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self updateName:name completionHandler:^(NSError *error) {
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
