//
//  HomesViewModel.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HomesViewModel.h"

#import "HomeViewModel.h"
#import "RoomsViewModel.h"
#import "EmptyViewModel.h"

#import "HomeController.h"
#import "HomesController.h"

@interface HomesViewModel ()

@property (nonatomic) NSArray *viewModels;

@end

@implementation HomesViewModel

- (instancetype)initWithHomesController:(HomesController *)homesController {
    self = [super init];
    if (self != nil) {
        _homesController = homesController;
        
        @weakify(self);
        _addHomeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *name) {
            @strongify(self);
            return [self.homesController addHome:name];
        }];
        
        _removeHomeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(HomeViewModel *viewModel) {
            @strongify(self);
            return [self.homesController removeHome:viewModel.home];
        }];
        
        _tapHomeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(HomeViewModel *viewModel) {
            return [RACSignal return:[[RoomsViewModel alloc] initWithHomeController:viewModel.homeController]];
        }];
        
        RACSignal *viewModelsSignal =
            [RACObserve(self.homesController, homes)
                map:^NSArray *(NSArray *homes) {
                    return [[homes.rac_sequence
                                map:^HomeViewModel *(HMHome *home) {
                                    HomeController *homeController = [[HomeController alloc] initWithHome:home];
                                    return [[HomeViewModel alloc] initWithHome:home homeController:homeController];
                                }]
                                array];
                }];
        
        RACSignal *emptyViewModelSignal =
            [[RACObserve(self.homesController, homes)
                filter:^BOOL(NSArray *homes) {
                    return [homes count] == 0;
                }]
                map:^NSArray *(id _) {
                    @strongify(self);
                    EmptyViewModel *viewModel =  [[EmptyViewModel alloc] initWithTitle:NSLocalizedString(@"No Homes", nil)
                                                                               message:NSLocalizedString(@"Tap to add a home.", nil)
                                                                         actionCommand:self.addHomeCommand];
                    return @[viewModel];
                }];
        
        RAC(self, viewModels) =
            [RACSignal merge:@[viewModelsSignal, emptyViewModelSignal]];
    }
    return self;
}

@end
