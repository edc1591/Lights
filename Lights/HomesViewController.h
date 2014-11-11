//
//  HomesViewController.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@class HomesViewModel;

@interface HomesViewController : UITableViewController

@property (nonatomic, readonly) HomesViewModel *viewModel;

- (instancetype)initWithViewModel:(HomesViewModel *)viewModel;

@end
