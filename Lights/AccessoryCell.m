//
//  AccessoryCell.m
//  Lights
//
//  Created by Evan Coleman on 11/11/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "AccessoryCell.h"

#import "AccessoryViewModel.h"

#import <ChameleonFramework/Chameleon.h>

@implementation AccessoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        @weakify(self);
        
        self.accessoryType = UITableViewCellAccessoryDetailButton;
        self.textLabel.font = [UIFont lights_regularFontWithSize:18];
        [self setDefaultColor:[UIColor flatGrayColor]];
        
        UIImageView *onImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_on"]];
        [self setSwipeGestureWithView:onImageView
                                color:[UIColor flatYellowColor]
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState3
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                          @strongify(self);
                          [self.viewModel.onCommand execute:nil];
                      }];
        
        UIImageView *offImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_off"]];
        [self setSwipeGestureWithView:offImageView
                                color:[UIColor flatBlackColor]
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState1
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                          @strongify(self);
                          [self.viewModel.offCommand execute:nil];
                      }];
        
        RAC(self.textLabel, text) = RACObserve(self, viewModel.name);
        RAC(self.textLabel, textColor) = RACObserve(self, viewModel.statusColor);
    }
    return self;
}

@end
