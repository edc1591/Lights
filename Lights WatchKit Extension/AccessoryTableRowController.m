//
//  AccessoryTableRowController.m
//  Lights
//
//  Created by Evan Coleman on 5/10/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

#import "AccessoryTableRowController.h"

#import "AccessoryViewModel.h"

@interface AccessoryTableRowController ()

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *textLabel;

@end

@implementation AccessoryTableRowController

- (void)setViewModel:(AccessoryViewModel *)viewModel {
    _viewModel = viewModel;
    
    [self.textLabel setText:_viewModel.name];
}

@end
