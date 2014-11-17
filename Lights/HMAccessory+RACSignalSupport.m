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
    return [[[[[self.services.rac_sequence
                    filter:^BOOL(HMService *service) {
                        return [service.serviceType isEqualToString:HMServiceTypeLightbulb];
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
                        if ([characteristics count] == 0) {
                            return nil;
                        } else {
                            HMCharacteristic *characteristic = [characteristics firstObject];
                            return characteristic;
                        }
                    }];
}

@end
