//
//  EmptyCell.m
//  Lights
//
//  Created by Evan Coleman on 5/9/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

#import "EmptyCell.h"

#import "EmptyViewModel.h"

@implementation EmptyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.textLabel.textColor = [UIColor darkTextColor];
        self.textLabel.font = [UIFont lights_regularFontWithSize:14];
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.font = [UIFont lights_regularFontWithSize:11];
    }
    return self;
}

- (void)setViewModel:(EmptyViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.textLabel.text = _viewModel.title;
    self.detailTextLabel.text = _viewModel.message;
}

@end
