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

@property (nonatomic, readonly) HomesViewModel *viewModel;

@end

@implementation HomesViewController

@dynamic viewModel;

- (instancetype)initWithViewModel:(HomesViewModel *)viewModel {
    self = [super initWithViewModel:viewModel style:UITableViewStyleGrouped];
    if (self != nil) {
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
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        }];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    
    [[[[[[RACObserve(self.viewModel, viewModels)
        take:2]
        doNext:^(id _) {
            @strongify(self);
            [self.tableView reloadData];
        }]
        filter:^BOOL(NSArray *viewModels) {
            return [viewModels count] == 1;
        }]
        map:^HomeViewModel *(NSArray *viewModels) {
            return [viewModels firstObject];
        }]
        filter:^BOOL(NSObject *viewModel) {
            return [viewModel isKindOfClass:[HomeViewModel class]];
        }]
        subscribeNext:^(HomeViewModel *viewModel) {
            @strongify(self);
            [self.viewModel.tapHomeCommand execute:viewModel];
        }];
    
    [[[self.viewModel.tapHomeCommand executionSignals]
        switchToLatest]
        subscribeNext:^(RoomsViewModel *roomsViewModel) {
            @strongify(self);
            RoomsViewController *roomsViewController = [[RoomsViewController alloc] initWithViewModel:roomsViewModel];
            [self.navigationController pushViewController:roomsViewController animated:YES];
        }];
    
    [[[[[self.viewModel.addHomeCommand executionSignals]
        switchToLatest]
        mapReplace:self.tableView]
        deliverOnMainThread]
        subscribeNext:^(UITableView *tableView) {
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewModel *homeViewModel = self.viewModel.viewModels[indexPath.row];
    if ([homeViewModel isKindOfClass:[HomeViewModel class]]) {
        [self.viewModel.tapHomeCommand execute:homeViewModel];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
            }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

@end
