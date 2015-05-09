//
//  HomeController.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@interface HomeController : NSObject

@property (nonatomic, readonly) HMHome *home;

@property (nonatomic, readonly) NSArray *rooms;
@property (nonatomic, readonly) NSArray *accessories;

- (instancetype)initWithHome:(HMHome *)home;

- (RACSignal *)addRoom:(NSString *)name;
- (RACSignal *)removeRoom:(HMRoom *)room;
- (RACSignal *)renameRoom:(HMRoom *)room withName:(NSString *)name;

- (RACSignal *)addAccessory:(HMAccessory *)accessory;
- (RACSignal *)removeAccessory:(HMAccessory *)accessory;
- (RACSignal *)assignAccessory:(HMAccessory *)accessory toRoom:(HMRoom *)room;

@end
