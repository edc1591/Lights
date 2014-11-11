//
//  RoomsViewController.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@class RoomsViewModel;

@interface RoomsViewController : UITableViewController

@property (nonatomic, readonly) RoomsViewModel *viewModel;

- (instancetype)initWithViewModel:(RoomsViewModel *)viewModel;

@end
