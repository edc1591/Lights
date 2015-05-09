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
#import "EmptyCell.h"

#import "HomeViewModel.h"
#import "RoomsViewModel.h"
#import "RoomViewModel.h"
#import "AccessoryViewModel.h"
#import "AccessoriesViewModel.h"
#import "EmptyViewModel.h"

@interface RoomsViewController ()

@property (nonatomic, readonly) RoomsViewModel *viewModel;

@property (nonatomic, readonly) BrightnessViewController *brightnessView;

@property (nonatomic) RoomHeaderView *mockHeaderView;

@end

@implementation RoomsViewController

@dynamic viewModel;

- (instancetype)initWithViewModel:(RoomsViewModel *)viewModel {
    self = [super initWithViewModel:viewModel style:UITableViewStyleGrouped];
    if (self != nil) {
        self.title = viewModel.homeName;
        self.navigationBarColor = [UIColor flatRedColorDark];
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
    [self.tableView registerClass:[EmptyCell class] forCellReuseIdentifier:NSStringFromClass([EmptyCell class])];
    
    self.mockHeaderView = [[RoomHeaderView alloc] init];
    
    @weakify(self);
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    addItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
        UIAlertController *addAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *roomAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add Room", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            }];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        [addAlertController addAction:roomAction];
        UIAlertAction *accessoryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add Accessory", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.viewModel.scanAccessoriesCommand execute:nil];
        }];
        [addAlertController addAction:accessoryAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil];
        [addAlertController addAction:cancelAction];
        
        [self presentViewController:addAlertController animated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    self.navigationItem.rightBarButtonItem = addItem;
    
    TableView *tableView = (TableView *)self.tableView;
    [[[[[[[RACObserve(tableView, holdIndexPath)
        doNext:^(NSIndexPath *indexPath) {
            @strongify(self);
            if (indexPath == nil) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }]
        ignore:nil]
        map:^AccessoryViewModel *(NSIndexPath *indexPath) {
            RoomViewModel *roomViewModel = self.viewModel.viewModels[indexPath.section];
            AccessoryViewModel *accessoryViewModel = roomViewModel.viewModels[indexPath.row];
            return accessoryViewModel;
        }]
        combineLatestWith:[RACSignal return:tableView]]
        map:^BrightnessViewController *(RACTuple *t) {
            RACTupleUnpack(AccessoryViewModel *accessoryViewModel, TableView *tableView) = t;
            if ([accessoryViewModel.brightness isEqualToNumber:@-1]) {
                return nil;
            }
            
            RACSignal *brightnessSignal =
                [RACObserve(tableView, translation)
                    scanWithStart:accessoryViewModel.brightness
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
            BrightnessViewController *vc = [[BrightnessViewController alloc] initWithViewModel:accessoryViewModel brightnessSignal:brightnessSignal];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            return vc;
        }]
        ignore:nil]
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
        flattenMap:^RACSignal *(NSArray *viewModels) {
            return [[[viewModels.rac_sequence
                map:^RACSignal *(RoomViewModel *viewModel) {
                    return [[viewModel.editCommand
                        executionSignals]
                        switchToLatest];
                }]
                signalWithScheduler:[RACScheduler mainThreadScheduler]]
                flatten];
        }]
        subscribeNext:^(RoomViewModel *roomViewModel) {
            @strongify(self);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:roomViewModel.name message:NSLocalizedString(@"Which action would you like to perform?", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self.viewModel.removeRoomCommand execute:roomViewModel];
            }];
            [alertController addAction:deleteAction];
            UIAlertAction *renameAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Rename", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UIAlertController *renameAlertController = [UIAlertController alertControllerWithTitle:roomViewModel.name message:NSLocalizedString(@"Enter a new name for this room.", nil) preferredStyle:UIAlertControllerStyleAlert];
                [renameAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self.viewModel.renameRoomCommand execute:RACTuplePack(roomViewModel, [[renameAlertController.textFields firstObject] text])];
                }];
                [renameAlertController addAction:okAction];
                UIAlertAction *cancelRenameAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil];
                [renameAlertController addAction:cancelRenameAction];
                [self presentViewController:renameAlertController animated:YES completion:nil];
            }];
            [alertController addAction:renameAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    
    [[RACObserve(self.viewModel, viewModels)
        mapReplace:self.tableView]
        subscribeNext:^(UITableView *tableView) {
            [tableView reloadData];
        }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    RoomViewModel *roomViewModel = self.viewModel.viewModels[indexPath.section];
    AccessoryViewModel *accessoryViewModel = roomViewModel.viewModels[indexPath.row];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:accessoryViewModel.name message:NSLocalizedString(@"Which action would you like to perform?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [accessoryViewModel.deleteAccessoryCommand execute:nil];
    }];
    [alertController addAction:deleteAction];
    UIAlertAction *renameAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Rename", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIAlertController *renameAlertController = [UIAlertController alertControllerWithTitle:accessoryViewModel.name message:NSLocalizedString(@"Enter a new name for this accessory.", nil) preferredStyle:UIAlertControllerStyleAlert];
        [renameAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [accessoryViewModel.renameAccessoryCommand execute:[[renameAlertController.textFields firstObject] text]];
        }];
        [renameAlertController addAction:okAction];
        UIAlertAction *cancelRenameAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil];
        [renameAlertController addAction:cancelRenameAction];
        [self presentViewController:renameAlertController animated:YES completion:nil];
    }];
    [alertController addAction:renameAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RoomHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([RoomHeaderView class])];
    
    headerView.viewModel = self.viewModel.viewModels[section];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.mockHeaderView sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.bounds), CGFLOAT_MAX)].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomViewModel *roomViewModel = self.viewModel.viewModels[indexPath.section];
    ViewModel *viewModel = roomViewModel.viewModels[indexPath.row];
    return ([viewModel isKindOfClass:[AccessoryViewModel class]]) ? 68.0 : 44.0;
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
    RoomViewModel *roomViewModel = self.viewModel.viewModels[indexPath.section];
    ViewModel *viewModel = roomViewModel.viewModels[indexPath.row];
    
    if ([viewModel isKindOfClass:[AccessoryViewModel class]]) {
        AccessoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccessoryCell class]) forIndexPath:indexPath];
        cell.viewModel = (AccessoryViewModel *)viewModel;
        return cell;
    } else if ([viewModel isKindOfClass:[EmptyViewModel class]]) {
        EmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyCell class]) forIndexPath:indexPath];
        cell.viewModel = (EmptyViewModel *)viewModel;
        return cell;
    }
    
    return nil;
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
