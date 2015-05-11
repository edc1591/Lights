//
//  RoomViewModel.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "ViewModel.h"

@class HomeController;

@interface RoomViewModel : ViewModel

@property (nonatomic, readonly) HMRoom *room;

@property (nonatomic, readonly) NSString *homeName;
@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) NSArray *viewModels;

@property (nonatomic, readonly) RACCommand *onCommand;
@property (nonatomic, readonly) RACCommand *offCommand;
@property (nonatomic, readonly) RACCommand *editCommand;

/// Input: NSString
@property (nonatomic, readonly) RACCommand *renameCommand;

- (instancetype)initWithRoom:(HMRoom *)room homeController:(HomeController *)homeController;

@end
