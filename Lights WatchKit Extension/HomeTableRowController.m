//
//  HomeTableRowController.m
//  Lights
//
//  Created by Evan Coleman on 5/10/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

#import "HomeTableRowController.h"

#import "HomeViewModel.h"

@interface HomeTableRowController ()

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *nameLabel;

@end

@implementation HomeTableRowController

- (void)setViewModel:(HomeViewModel *)viewModel {
    _viewModel = viewModel;
    
    [self.nameLabel setText:_viewModel.name];
}

@end
