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

@interface HomesViewController ()

@end

@implementation HomesViewController

- (instancetype)initWithViewModel:(HomesViewModel *)viewModel {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self != nil) {
        _viewModel = viewModel;
        
        self.title = NSLocalizedString(@"Homes", nil);
        
        [[RACObserve(self.viewModel, viewModels)
            mapReplace:self.tableView]
            subscribeNext:^(UITableView *tableView) {
                [tableView reloadData];
            }];
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
    
    [[[self.viewModel.tapHomeCommand executionSignals]
        switchToLatest]
        subscribeNext:^(RoomsViewModel *roomsViewModel) {
            @strongify(self);
            RoomsViewController *roomsViewController = [[RoomsViewController alloc] initWithViewModel:roomsViewModel];
            [self.navigationController pushViewController:roomsViewController animated:YES];
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    HomeViewModel *homeViewModel = self.viewModel.viewModels[indexPath.row];
    cell.textLabel.text = homeViewModel.name;
    
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
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

@end
