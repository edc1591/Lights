//
//  HMCharacteristic+RACSignalSupport.h
//  Lights
//
//  Created by Evan Coleman on 11/12/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <HomeKit/HomeKit.h>

@interface HMCharacteristic (RACSignalSupport)

- (RACSignal *)rac_writeValue:(id)value;
- (RACSignal *)rac_readValue;

@end
