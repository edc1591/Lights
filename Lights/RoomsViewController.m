//
//  RoomsViewController.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RoomsViewController.h"

#import "AccessoriesViewController.h"

#import "HomeViewModel.h"
#import "RoomsViewModel.h"
#import "RoomViewModel.h"
#import "AccessoryViewModel.h"
#import "AccessoriesViewModel.h"

@interface RoomsViewController ()

@end

@implementation RoomsViewController

- (instancetype)initWithViewModel:(RoomsViewModel *)viewModel {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self != nil) {
        _viewModel = viewModel;
        
        self.title = viewModel.homeName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DeviceCell"];
    
    @weakify(self);
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add Room", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    addBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
        @strongify(self);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Add Room", nil)
                                                                                 message:NSLocalizedString(@"Enter a name for the room.", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.viewModel.addRoomCommand execute:[[alertController.textFields firstObject] text]];
        }];
        [alertController addAction:addAction];
        [alertController addTextFieldWithConfigurationHandler:nil];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    
    UIBarButtonItem *devicesItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add Accessory", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    devicesItem.rac_command = self.viewModel.scanAccessoriesCommand;
    
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:@[ flexibleSpaceItem, addBarButtonItem, flexibleSpaceItem, devicesItem, flexibleSpaceItem ]];
    [self.navigationController setToolbarHidden:NO];
    
    [[[self.viewModel.scanAccessoriesCommand executionSignals]
        switchToLatest]
        subscribeNext:^(AccessoriesViewModel *viewModel) {
            AccessoriesViewController *viewController = [[AccessoriesViewController alloc] initWithViewModel:viewModel];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [self presentViewController:navigationController animated:YES completion:nil];
        }];
    
    [[RACObserve(self.viewModel, viewModels)
        mapReplace:self.tableView]
        subscribeNext:^(UITableView *tableView) {
            [tableView reloadData];
        }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel.viewModels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RoomViewModel *roomViewModel = self.viewModel.viewModels[section];
    return [roomViewModel.viewModels count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    RoomViewModel *roomViewModel = self.viewModel.viewModels[section];
    return roomViewModel.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell" forIndexPath:indexPath];
    
    RoomViewModel *roomViewModel = self.viewModel.viewModels[indexPath.section];
    AccessoryViewModel *accessoryViewModel = roomViewModel.viewModels[indexPath.row];
    cell.textLabel.text = accessoryViewModel.name;
    
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}

@end
