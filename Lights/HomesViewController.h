//
//  HomesViewController.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "TableViewController.h"

@class HomesViewModel;

@interface HomesViewController : TableViewController

@property (nonatomic, readonly) HomesViewModel *viewModel;

- (instancetype)initWithViewModel:(HomesViewModel *)viewModel;

@end
