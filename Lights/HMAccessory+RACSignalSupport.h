//
//  HMAccessory+RACSignalSupport.h
//  Lights
//
//  Created by Evan Coleman on 11/12/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <HomeKit/HomeKit.h>

@interface HMAccessory (RACSignalSupport)

- (RACSignal *)rac_getCharacterisitic:(NSString *)characteristic;
- (RACSignal *)rac_rename:(NSString *)name;

@end
