//
//  HomeViewModel.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HomeViewModel.h"

#import "RoomViewModel.h"
#import "AccessoryViewModel.h"

#import "HomeController.h"

@interface HomeViewModel ()

@property (nonatomic) NSArray *accessories;
@property (nonatomic) NSArray *rooms;

@end

@implementation HomeViewModel

- (instancetype)initWithHome:(HMHome *)home homeController:(HomeController *)homeController {
    self = [super init];
    if (self != nil) {
        _home = home;
        _homeController = homeController;
        
        _name = home.name;
        
        RAC(self, accessories) =
            [RACObserve(home, accessories)
                map:^NSArray *(NSArray *accessories) {
                    return [[accessories.rac_sequence
                                map:^AccessoryViewModel *(HMAccessory *accessory) {
                                    return [[AccessoryViewModel alloc] initWithAccessory:accessory allowEditing:YES homeController:homeController];
                                }]
                                array];
                }];
        
        RAC(self, rooms) =
            [RACObserve(home, rooms)
                map:^NSArray *(NSArray *rooms) {
                    return [[rooms.rac_sequence
                                map:^RoomViewModel *(HMRoom *room) {
                                    return [[RoomViewModel alloc] initWithRoom:room homeController:homeController];
                                }]
                                array];
                }];
    }
    return self;
}

@end
