//
//  AccessoriesViewController.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "AccessoriesViewController.h"

#import "AccessoriesViewModel.h"
#import "AccessoryViewModel.h"
#import "HomeViewModel.h"
#import "RoomViewModel.h"

@interface AccessoriesViewController ()

@property (nonatomic, readonly) AccessoriesViewModel *viewModel;

@end

@implementation AccessoriesViewController

- (instancetype)initWithViewModel:(AccessoriesViewModel *)viewModel {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self != nil) {
        _viewModel = viewModel;
        
        self.title = NSLocalizedString(@"Accessories", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AccessoryCell"];
    
    @weakify(self);
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    doneItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    [[RACObserve(self.viewModel, viewModels)
        mapReplace:self.tableView]
        subscribeNext:^(UITableView *tableView) {
            [tableView reloadData];
        }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccessoryViewModel *viewModel = self.viewModel.viewModels[indexPath.row];

    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Choose a room to add \"%@\" to.", nil), viewModel.name];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Add Accessory", nil) message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.viewModel.roomViewModels enumerateObjectsUsingBlock:^(RoomViewModel *roomViewModel, NSUInteger idx, BOOL *stop) {
        UIAlertAction *roomAction = [UIAlertAction actionWithTitle:roomViewModel.name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [viewModel.pairAccessoryCommand execute:roomViewModel];
        }];
        [alertController addAction:roomAction];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccessoryCell" forIndexPath:indexPath];
    
    AccessoryViewModel *viewModel = self.viewModel.viewModels[indexPath.row];
    cell.textLabel.text = viewModel.name;
    
    return cell;
}

@end
