//
//  RoomsInterfaceController.m
//  Lights
//
//  Created by Evan Coleman on 5/10/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

#import "RoomsInterfaceController.h"

#import "RoomTableRowController.h"

#import "HomesController.h"
#import "HomeController.h"

#import "RoomsViewModel.h"
#import "RoomViewModel.h"

@interface RoomsInterfaceController ()

@property (nonatomic) HomesController *homesController;
@property (nonatomic) HomeController *homeController;

@property (nonatomic) RoomsViewModel *viewModel;

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *homeLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceTable *tableView;

@end

@implementation RoomsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.homesController = [[HomesController alloc] init];
    
    @weakify(self);
    
    RAC(self, homeController) =
        [RACObserve(self.homesController, homes)
            map:^HomeController *(NSArray *homes) {
                HMHome *home = [homes firstObject];
                if (home != nil) {
                    return [[HomeController alloc] initWithHome:home];
                } else {
                    return nil;
                }
            }];
    
    RAC(self, viewModel) =
        [[RACObserve(self, homeController)
            map:^RoomsViewModel *(HomeController *homeController) {
                return [[RoomsViewModel alloc] initWithHomeController:homeController];
            }]
            doNext:^(RoomsViewModel *viewModel) {
                @strongify(self);
                [self.homeLabel setText:viewModel.homeName];
            }];
    
    [RACObserve(self, viewModel.viewModels)
        subscribeNext:^(NSArray *viewModels) {
            @strongify(self);
            [self.tableView setNumberOfRows:[viewModels count] withRowType:NSStringFromClass([RoomTableRowController class])];
            
            [viewModels enumerateObjectsUsingBlock:^(RoomViewModel *viewModel, NSUInteger idx, BOOL *stop) {
                RoomTableRowController *rowController = [self.tableView rowControllerAtIndex:idx];
                rowController.viewModel = viewModel;
            }];
        }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark Segues

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
    if (table == self.tableView) {
        RoomViewModel *roomViewModel = self.viewModel.viewModels[rowIndex];
        return roomViewModel;
    } else {
        return nil;
    }
}

@end



