//
//  HomesInterfaceController.m
//  Lights
//
//  Created by Evan Coleman on 5/10/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

#import "HomesInterfaceController.h"

#import "HomeTableRowController.h"

#import "HomesController.h"

#import "HomesViewModel.h"
#import "HomeViewModel.h"

@interface HomesInterfaceController ()

@property (nonatomic) HomesViewModel *viewModel;

@property (nonatomic) RACSubject *homeViewModelsSubject;

@property (nonatomic, weak) IBOutlet WKInterfaceTable *tableView;

@end

@implementation HomesInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    NSAssert([context isKindOfClass:[RACTuple class]], @"Context must be of type RACTuple");
    NSAssert([(RACTuple *)context count] == 2, @"Tuple must contain two objects");
    
    RACTupleUnpack(HomesController *homesController, RACSubject *homeViewModelsSubject) = (RACTuple *)context;
    
    self.homeViewModelsSubject = homeViewModelsSubject;
    self.viewModel = [[HomesViewModel alloc] initWithHomesController:homesController];
    
    @weakify(self);
    
    [RACObserve(self.viewModel, viewModels)
        subscribeNext:^(NSArray *viewModels) {
            @strongify(self);
            
            [self.tableView setNumberOfRows:[viewModels count] withRowType:NSStringFromClass([HomeTableRowController class])];
            
            [viewModels enumerateObjectsUsingBlock:^(HomeViewModel *homeViewModel, NSUInteger idx, BOOL *stop) {
                HomeTableRowController *rowController = [self.tableView rowControllerAtIndex:idx];
                rowController.viewModel = homeViewModel;
            }];
        }];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    HomeViewModel *homeViewModel = self.viewModel.viewModels[rowIndex];
    [self.homeViewModelsSubject sendNext:homeViewModel.homeController];
    [self dismissController];
}

@end



