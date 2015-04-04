//
//  TableViewController.h
//  Lights
//
//  Created by Evan Coleman on 11/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@class ViewModel;

@interface TableViewController : UITableViewController

@property (nonatomic) UIColor *navigationBarColor;

@property (nonatomic, readonly) ViewModel *viewModel;

- (instancetype)initWithViewModel:(ViewModel *)viewModel style:(UITableViewStyle)style;

@end
