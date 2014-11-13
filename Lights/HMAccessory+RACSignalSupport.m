//
//  HMAccessory+RACSignalSupport.m
//  Lights
//
//  Created by Evan Coleman on 11/12/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HMAccessory+RACSignalSupport.h"

@implementation HMAccessory (RACSignalSupport)

- (RACSignal *)rac_powerCharacteristic {
    return [[[[[self.services.rac_sequence
                    filter:^BOOL(HMService *service) {
                        return [service.serviceType isEqualToString:HMServiceTypeLightbulb];
                    }]
                    take:1]
                    map:^NSArray *(HMService *service) {
                        return [[service.characteristics.rac_sequence
                                    filter:^BOOL(HMCharacteristic *characteristic) {
                                        return [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState];
                                    }]
                                    array];
                    }]
                    signal]
                    flattenMap:^RACSignal *(NSArray *characteristics) {
                        if ([characteristics count] == 0) {
                            return [RACSignal error:nil];
                        } else {
                            HMCharacteristic *characteristic = [characteristics firstObject];
                            return [RACSignal return:characteristic];
                        }
                    }];
}

@end
