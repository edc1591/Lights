//
//  RoomsViewController.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RoomsViewController.h"

#import "TableView.h"
#import "AccessoriesViewController.h"
#import "AccessoryCell.h"
#import "RoomHeaderView.h"
#import "BrightnessViewController.h"

#import "HomeViewModel.h"
#import "RoomsViewModel.h"
#import "RoomViewModel.h"
#import "AccessoryViewModel.h"
#import "AccessoriesViewModel.h"

@interface RoomsViewController ()

@property (nonatomic, readonly) BrightnessViewController *brightnessView;

@property (nonatomic, readonly) RoomHeaderView *mockHeaderView;

@end

@implementation RoomsViewController

- (instancetype)initWithViewModel:(RoomsViewModel *)viewModel {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self != nil) {
        _viewModel = viewModel;
        
        self.title = viewModel.homeName;
        self.navigationBarColor = [UIColor flatRedColorDark];
        
        _mockHeaderView = [[RoomHeaderView alloc] init];
    }
    return self;
}

- (void)loadView {
    TableView *tableView = [[TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    self.view = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.tableView registerClass:[AccessoryCell class] forCellReuseIdentifier:NSStringFromClass([AccessoryCell class])];
    [self.tableView registerClass:[RoomHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([RoomHeaderView class])];
    
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
    
    TableView *tableView = (TableView *)self.tableView;
    RACSignal *brightnessSignal =
        [RACObserve(tableView, translation)
            scanWithStart:nil
            reduce:^NSNumber *(NSNumber *brightness, NSNumber *translation) {
                CGFloat num = [brightness doubleValue] - [translation doubleValue];
                if (num > 100) {
                    return @100;
                } else if (num < 0) {
                    return @0;
                } else {
                    return @(num);
                }
            }];
    
    [[[[RACObserve(tableView, holdIndexPath)
        doNext:^(NSIndexPath *indexPath) {
            @strongify(self);
            if (indexPath == nil) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }]
        filter:^BOOL(NSIndexPath *indexPath) {
            return (indexPath != nil);
        }]
        map:^BrightnessViewController *(NSIndexPath *indexPath) {
            RoomViewModel *roomViewModel = self.viewModel.viewModels[indexPath.section];
            AccessoryViewModel *accessoryViewModel = roomViewModel.viewModels[indexPath.row];
            BrightnessViewController *vc = [[BrightnessViewController alloc] initWithViewModel:accessoryViewModel brightnessSignal:brightnessSignal];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            return vc;
        }]
        subscribeNext:^(UIViewController *viewController) {
            @strongify(self);
            [self presentViewController:viewController animated:YES completion:nil];
        }];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RoomHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([RoomHeaderView class])];
    
    headerView.viewModel = self.viewModel.viewModels[section];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.mockHeaderView sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.bounds), CGFLOAT_MAX)].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel.viewModels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RoomViewModel *roomViewModel = self.viewModel.viewModels[section];
    return [roomViewModel.viewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccessoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccessoryCell class]) forIndexPath:indexPath];
    
    RoomViewModel *roomViewModel = self.viewModel.viewModels[indexPath.section];
    AccessoryViewModel *accessoryViewModel = roomViewModel.viewModels[indexPath.row];
    cell.viewModel = accessoryViewModel;
    
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
