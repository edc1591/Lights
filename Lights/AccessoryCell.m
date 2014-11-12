//
//  AccessoryCell.m
//  Lights
//
//  Created by Evan Coleman on 11/11/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "AccessoryCell.h"

#import "AccessoryViewModel.h"

@implementation AccessoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        RAC(self.textLabel, text) = RACObserve(self, viewModel.name);
        RAC(self.textLabel, textColor) = RACObserve(self, viewModel.statusColor);
    }
    return self;
}

@end
