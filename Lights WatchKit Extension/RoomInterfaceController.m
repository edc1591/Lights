//
//  InterfaceController.m
//  Lights WatchKit Extension
//
//  Created by Evan Coleman on 5/9/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

#import "RoomInterfaceController.h"

#import "AccessoryTableRowController.h"

#import "RoomViewModel.h"
#import "AccessoryViewModel.h"

@interface RoomInterfaceController ()

@property (nonatomic) RoomViewModel *viewModel;

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *nameLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceTable *tableView;

@end

@implementation RoomInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.viewModel = (RoomViewModel *)context;
    
    [self.nameLabel setText:self.viewModel.name];
    
    @weakify(self);
    
    [RACObserve(self.viewModel, viewModels)
        subscribeNext:^(NSArray *viewModels) {
            @strongify(self);
            [self.tableView setNumberOfRows:[viewModels count] withRowType:NSStringFromClass([AccessoryTableRowController class])];
            
            [viewModels enumerateObjectsUsingBlock:^(AccessoryViewModel *viewModel, NSUInteger idx, BOOL *stop) {
                AccessoryTableRowController *rowController = [self.tableView rowControllerAtIndex:idx];
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
        AccessoryViewModel *accessoryViewModel = self.viewModel.viewModels[rowIndex];
        return accessoryViewModel;
    } else {
        return nil;
    }
}

#pragma mark Interface Actions

- (IBAction)handleOn {
    [self.viewModel.onCommand execute:nil];
}

- (IBAction)handleOff {
    [self.viewModel.offCommand execute:nil];
}

@end



