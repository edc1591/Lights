//
//  RoomTableRowController.m
//  Lights
//
//  Created by Evan Coleman on 5/10/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

#import "RoomTableRowController.h"

#import "RoomViewModel.h"

@interface RoomTableRowController ()

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *nameLabel;

@end

@implementation RoomTableRowController

- (void)setViewModel:(RoomViewModel *)viewModel {
    _viewModel = viewModel;
    
    [self.nameLabel setText:_viewModel.name];
}

@end
