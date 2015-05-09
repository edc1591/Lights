//
//  HomeController.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HomeController.h"

#import "HMHome+RACSignalSupport.h"

@interface HomeController () <HMHomeDelegate>

@property (nonatomic) NSArray *rooms;
@property (nonatomic) NSArray *accessories;

@end

@implementation HomeController

- (instancetype)initWithHome:(HMHome *)home {
    self = [super init];
    if (self != nil) {
        _home = home;
        _home.delegate = self;
        
        _rooms = _home.rooms;
        _accessories = _home.accessories;
    }
    return self;
}

- (void)dealloc {
    self.home.delegate = nil;
}

- (RACSignal *)addRoom:(NSString *)name {
    @weakify(self);
    return [[self.home rac_addRoomWithName:name]
                doCompleted:^{
                    @strongify(self);
                    self.rooms = self.home.rooms;
                }];
}

- (RACSignal *)removeRoom:(HMRoom *)room {
    @weakify(self);
    return [[self.home rac_removeRoom:room]
                doCompleted:^{
                    @strongify(self);
                    self.rooms = self.home.rooms;
                }];
}

- (RACSignal *)renameRoom:(HMRoom *)room withName:(NSString *)name {
    @weakify(self);
    return [[self.home rac_renameRoom:room withName:name]
        doCompleted:^{
            @strongify(self);
            self.rooms = self.home.rooms;
        }];
}

- (RACSignal *)addAccessory:(HMAccessory *)accessory {
    @weakify(self);
    return [[self.home rac_addAccessory:accessory]
                doCompleted:^{
                    @strongify(self);
                    self.accessories = self.home.accessories;
                }];
}

- (RACSignal *)removeAccessory:(HMAccessory *)accessory {
    @weakify(self);
    HMRoom *room = accessory.room;
    [room willChangeValueForKey:@keypath(room, accessories)];
    return [[self.home rac_removeAccessory:accessory]
                doCompleted:^{
                    @strongify(self);
                    self.accessories = self.home.accessories;
                    self.rooms = self.home.rooms;
                    [room didChangeValueForKey:@keypath(room, accessories)];
                }];
}

- (RACSignal *)assignAccessory:(HMAccessory *)accessory toRoom:(HMRoom *)room {
    [room willChangeValueForKey:@keypath(room, accessories)];
    return [[self.home rac_assignAccessory:accessory toRoom:room]
                doCompleted:^{
                    [room didChangeValueForKey:@keypath(room, accessories)];
                }];
}

#pragma mark HMHomeDelegate

- (void)home:(HMHome *)home didAddRoom:(HMRoom *)room toZone:(HMZone *)zone { }
- (void)home:(HMHome *)home didRemoveRoom:(HMRoom *)room { }
- (void)home:(HMHome *)home didAddAccessory:(HMAccessory *)accessory { }
- (void)home:(HMHome *)home didRemoveAccessory:(HMAccessory *)accessory { }
- (void)home:(HMHome *)home didUpdateRoom:(HMRoom *)room forAccessory:(HMAccessory *)accessory { }

@end
