//
//  RoomsViewController.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "TableViewController.h"

@class RoomsViewModel;

@interface RoomsViewController : TableViewController

@property (nonatomic, readonly) RoomsViewModel *viewModel;

- (instancetype)initWithViewModel:(RoomsViewModel *)viewModel;

@end
