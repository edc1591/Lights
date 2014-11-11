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
        
        RAC(self, rooms) =
            [[[RACSignal merge:@[[self rac_signalForSelector:@selector(home:didAddRoom:) fromProtocol:@protocol(HMHomeDelegate)],
                                [self rac_signalForSelector:@selector(home:didRemoveRoom:) fromProtocol:@protocol(HMHomeDelegate)]]]
                reduceEach:^NSArray *(HMHome *home, HMRoom *_){
                    return home.rooms;
                }]
                startWith:_home.rooms];
        
        RAC(self, accessories) =
            [[[RACSignal merge:@[[self rac_signalForSelector:@selector(home:didAddAccessory:) fromProtocol:@protocol(HMHomeDelegate)],
                                [self rac_signalForSelector:@selector(home:didRemoveAccessory:) fromProtocol:@protocol(HMHomeDelegate)]]]
                reduceEach:^NSArray *(HMHome *home, HMAccessory *_){
                    return home.accessories;
                }]
                startWith:_home.accessories];
        
//        [[[self rac_signalForSelector:@selector(home:didUpdateRoom:forAccessory:) fromProtocol:@protocol(HMHomeDelegate)]
//            reduceEach:^HMRoom *(HMHome *_, HMRoom *room, HMAccessory *__){
//                return room;
//            }]
//            subscribeNext:^(HMRoom *room) {
//                [room didChangeValueForKey:@"accessories"];
//            }];
    }
    return self;
}

- (void)dealloc {
    self.home.delegate = nil;
}

- (RACSignal *)addRoom:(NSString *)name {
    return [self.home rac_addRoomWithName:name];
}

- (RACSignal *)removeRoom:(HMRoom *)room {
    return [self.home rac_removeRoom:room];
}

- (RACSignal *)addAccessory:(HMAccessory *)accessory {
    return [self.home rac_addAccessory:accessory];
}

- (RACSignal *)assignAccessory:(HMAccessory *)accessory toRoom:(HMRoom *)room {
    return [self.home rac_assignAccessory:accessory toRoom:room];
}

#pragma mark HMHomeDelegate

- (void)home:(HMHome *)home didAddRoom:(HMRoom *)room toZone:(HMZone *)zone {
    
}
- (void)home:(HMHome *)home didRemoveRoom:(HMRoom *)room { }
- (void)home:(HMHome *)home didAddAccessory:(HMAccessory *)accessory { }
- (void)home:(HMHome *)home didRemoveAccessory:(HMAccessory *)accessory { }
- (void)home:(HMHome *)home didUpdateRoom:(HMRoom *)room forAccessory:(HMAccessory *)accessory { }

@end
