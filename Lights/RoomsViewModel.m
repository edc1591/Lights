//
//  RoomViewModel.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RoomsViewModel.h"

#import "RoomViewModel.h"
#import "AccessoriesViewModel.h"

#import "HomeController.h"
#import "AccessoriesController.h"

@interface RoomsViewModel ()

@property (nonatomic, readonly) HomeController *homeController;

@end

@implementation RoomsViewModel

- (instancetype)initWithHomeController:(HomeController *)homeController {
    self = [super init];
    if (self != nil) {
        _homeController = homeController;
        
        _homeName = _homeController.home.name;
        
        @weakify(self);
        RAC(self, viewModels) =
            [RACObserve(self.homeController, rooms)
                map:^NSArray *(NSArray *rooms) {
                    return [[rooms.rac_sequence
                        map:^RoomViewModel *(HMRoom *room) {
                            @strongify(self);
                            return [[RoomViewModel alloc] initWithRoom:room homeController:self.homeController];
                        }]
                        array];
                }];
        
        _addRoomCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *name) {
            @strongify(self);
            return [self.homeController addRoom:name];
        }];
        
        _removeRoomCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RoomViewModel *viewModel) {
            @strongify(self);
            return [self.homeController removeRoom:viewModel.room];
        }];
        
        _renameRoomCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *t) {
            @strongify(self);
            RACTupleUnpack(RoomViewModel *roomViewModel, NSString *name) = t;
            return [self.homeController renameRoom:roomViewModel.room withName:name];
        }];
        
        _scanAccessoriesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            AccessoriesController *accessoriesController = [[AccessoriesController alloc] init];
            AccessoriesViewModel *viewModel = [[AccessoriesViewModel alloc] initWithAccessoriesController:accessoriesController homeController:homeController];
            return [RACSignal return:viewModel];
        }];
        
        [[[[RACObserve(self, viewModels)
            flattenMap:^RACSignal *(NSArray *viewModels) {
                return [[viewModels.rac_sequence
                    map:^RACSignal *(RoomViewModel *viewModel) {
                        return viewModel.errors;
                    }]
                    signalWithScheduler:[RACScheduler mainThreadScheduler]];
            }]
            flatten]
            merge:[RACSignal merge:@[self.addRoomCommand.errors, self.removeRoomCommand.errors, self.renameRoomCommand.errors]]]
            subscribe:self.errors];
    }
    return self;
}

@end
