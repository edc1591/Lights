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
        
        @weakify(self);
        _onCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [[[[self.viewModels.rac_sequence
                map:^RACCommand *(AccessoryViewModel *viewModel) {
                    return viewModel.onCommand;
                }]
                signal]
                flattenMap:^RACSignal *(RACCommand *command) {
                    return [command execute:nil];
                }]
                flatten];
        }];
        
        _offCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [[[[self.viewModels.rac_sequence
                map:^RACCommand *(AccessoryViewModel *viewModel) {
                    return viewModel.offCommand;
                }]
                signal]
                flattenMap:^RACSignal *(RACCommand *command) {
                    return [command execute:nil];
                }]
                flatten];
        }];
        
        [[[RACObserve(self, viewModels)
            flattenMap:^RACSignal *(NSArray *viewModels) {
                return [[viewModels.rac_sequence
                    map:^RACSignal *(AccessoryViewModel *viewModel) {
                        return viewModel.errors;
                    }]
                    signalWithScheduler:[RACScheduler mainThreadScheduler]];
            }]
            flatten]
            subscribe:self.errors];
    }
    return self;
}

@end
