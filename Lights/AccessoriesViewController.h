//
//  AccessoriesViewController.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "TableViewController.h"

@class AccessoriesViewModel;

@interface AccessoriesViewController : TableViewController

- (instancetype)initWithViewModel:(AccessoriesViewModel *)viewModel;

@end
