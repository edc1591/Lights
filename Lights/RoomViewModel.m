//
//  RoomViewModel.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RoomViewModel.h"

#import "AccessoryViewModel.h"

#import "HomeController.h"

@interface RoomViewModel ()

@property (nonatomic) NSArray *viewModels;

@end

@implementation RoomViewModel

- (instancetype)initWithRoom:(HMRoom *)room homeController:(HomeController *)homeController {
    self = [super init];
    if (self != nil) {
        _room = room;
        
        _name = room.name;
        
        RAC(self, viewModels) =
            [RACObserve(room, accessories)
                map:^NSArray *(NSArray *accessories) {
                    return [[accessories.rac_sequence
                                map:^AccessoryViewModel *(HMAccessory *accessory) {
                                    return [[AccessoryViewModel alloc] initWithAccessory:accessory homeController:homeController];
                                }]
                                array];
                }];
    }
    return self;
}

@end
