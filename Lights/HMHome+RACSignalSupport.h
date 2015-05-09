//
//  HMHome+RACSignalSupport.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <HomeKit/HomeKit.h>

@interface HMHome (RACSignalSupport)

- (RACSignal *)rac_addRoomWithName:(NSString *)name;
- (RACSignal *)rac_removeRoom:(HMRoom *)room;
- (RACSignal *)rac_renameRoom:(HMRoom *)room withName:(NSString *)name;
- (RACSignal *)rac_addAccessory:(HMAccessory *)accessory;
- (RACSignal *)rac_removeAccessory:(HMAccessory *)accessory;
- (RACSignal *)rac_assignAccessory:(HMAccessory *)accessory toRoom:(HMRoom *)room;

@end
