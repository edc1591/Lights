//
//  EmptyViewModel.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "EmptyViewModel.h"

@implementation EmptyViewModel

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actionCommand:(RACCommand *)actionCommand {
    self = [super init];
    if (self != nil) {
        _title = title;
        _message = message;
        _actionCommand = actionCommand;
    }
    return self;
}

@end
