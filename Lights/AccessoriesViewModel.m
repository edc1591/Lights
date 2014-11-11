//
//  AccessoriesViewModel.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "AccessoriesViewModel.h"

#import "AccessoryViewModel.h"
#import "RoomViewModel.h"

#import "AccessoriesController.h"
#import "HomeController.h"

@interface AccessoriesViewModel ()

@property (nonatomic, readonly) AccessoriesController *accessoriesController;

@property (nonatomic) NSArray *viewModels;

@end

@implementation AccessoriesViewModel

- (instancetype)initWithAccessoriesController:(AccessoriesController *)accessoriesController homeController:(HomeController *)homeController {
    self = [super init];
    if (self != nil) {
        _accessoriesController = accessoriesController;
        
        RAC(self, viewModels) =
            [RACObserve(self.accessoriesController, accessories)
                map:^NSArray *(NSArray *accessories) {
                    return [[accessories.rac_sequence
                                map:^AccessoryViewModel *(HMAccessory *accessory) {
                                    return [[AccessoryViewModel alloc] initWithAccessory:accessory homeController:homeController];
                                }]
                                array];
                }];
        
        RAC(self, roomViewModels) =
            [RACObserve(homeController, rooms)
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
