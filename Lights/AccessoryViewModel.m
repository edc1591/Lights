//
//  AccessoryViewModel.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "AccessoryViewModel.h"

#import "RoomViewModel.h"

#import "HomeController.h"

@implementation AccessoryViewModel

- (instancetype)initWithAccessory:(HMAccessory *)accessory homeController:(HomeController *)homeController {
    self = [super init];
    if (self != nil) {
        _accessory = accessory;
        
        _name = accessory.name;
        
        @weakify(self);
        _pairAccessoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RoomViewModel *roomViewModel) {
            @strongify(self);
            return [[homeController addAccessory:self.accessory]
                        flattenMap:^RACSignal *(id _) {
                            return [homeController assignAccessory:self.accessory toRoom:roomViewModel.room];
                        }];
        }];
    }
    return self;
}

@end
