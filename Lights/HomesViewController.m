//
//  HomesViewController.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HomesViewController.h"

#import "RoomsViewController.h"

#import "HomesViewModel.h"
#import "HomeViewModel.h"
#import "RoomsViewModel.h"
#import "EmptyViewModel.h"

@interface HomesViewController ()

@end

@implementation HomesViewController

- (instancetype)initWithViewModel:(HomesViewModel *)viewModel {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self != nil) {
        _viewModel = viewModel;
        
        self.title = NSLocalizedString(@"Homes", nil);
        self.navigationBarColor = [UIColor flatBlueColorDark];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeCell"];
    
    @weakify(self);
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    addBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
        @strongify(self);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Add Home", nil)
                                                                                 message:NSLocalizedString(@"Enter a name for the home.", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.viewModel.addHomeCommand execute:[[alertController.textFields firstObject] text]];
        }];
        [alertController addAction:addAction];
        [alertController addTextFieldWithConfigurationHandler:nil];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    
    [[[RACObserve(self.viewModel, viewModels)
        take:2]
        mapReplace:self.tableView]
        subscribeNext:^(UITableView *tableView) {
            [tableView reloadData];
        }];
    
    [[[self.viewModel.tapHomeCommand executionSignals]
        switchToLatest]
        subscribeNext:^(RoomsViewModel *roomsViewModel) {
            @strongify(self);
            RoomsViewController *roomsViewController = [[RoomsViewController alloc] initWithViewModel:roomsViewModel];
            [self.navigationController pushViewController:roomsViewController animated:YES];
        }];
    
    [[[[[[self.viewModel.addHomeCommand executionSignals]
        switchToLatest]
        flattenMap:^RACSignal *(HMHome *home) {
            @strongify(self);
            return [[[self.viewModel.viewModels.rac_sequence
                        filter:^BOOL(HomeViewModel *viewModel) {
                            return viewModel.home == home;
                        }]
                        take:1]
                        signal];
        }]
        tryMap:^NSIndexPath *(HomeViewModel *viewModel, NSError *__autoreleasing *errorPtr) {
            @strongify(self);
            NSUInteger idx = [self.viewModel.viewModels indexOfObject:viewModel];
            if (idx == NSNotFound) {
                return nil;
            } else {
                return [NSIndexPath indexPathForRow:idx inSection:0];
            }
        }]
        deliverOn:RACScheduler.mainThreadScheduler]
        subscribeNext:^(NSIndexPath *indexPath) {
            @strongify(self);
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewModel *homeViewModel = self.viewModel.viewModels[indexPath.row];
    [self.viewModel.tapHomeCommand execute:homeViewModel];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.viewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    NSObject *viewModel = self.viewModel.viewModels[indexPath.row];
    if ([viewModel isKindOfClass:[HomeViewModel class]]) {
        HomeViewModel *homeViewModel = (HomeViewModel *)viewModel;
        cell.textLabel.font = [UIFont lights_boldFontWithSize:16];
        cell.textLabel.text = homeViewModel.name;
    } else {
        EmptyViewModel *emptyViewModel = (EmptyViewModel *)viewModel;
        cell.textLabel.text = emptyViewModel.title;
        cell.detailTextLabel.text = emptyViewModel.message;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[self.viewModel.removeHomeCommand execute:self.viewModel.viewModels[indexPath.row]]
            subscribeError:^(NSError *error) {
                NSLog(@"Error removing home: %@", [error localizedDescription]);
            } completed:^{
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

@end
