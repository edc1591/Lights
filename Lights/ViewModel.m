//
//  ViewModel.m
//  Lights
//
//  Created by Evan Coleman on 4/4/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _errors = [RACSubject subject];
    }
    return self;
}

@end
