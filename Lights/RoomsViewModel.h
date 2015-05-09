//
//  RoomsViewModel.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "ViewModel.h"

@class HomeController;

@interface RoomsViewModel : ViewModel

@property (nonatomic, readonly) NSArray *viewModels;

@property (nonatomic, readonly) NSString *homeName;

@property (nonatomic, readonly) RACCommand *addRoomCommand;
@property (nonatomic, readonly) RACCommand *removeRoomCommand;

/// Input: RACTuple, RoomViewModel and NSString
@property (nonatomic, readonly) RACCommand *renameRoomCommand;

@property (nonatomic, readonly) RACCommand *scanAccessoriesCommand;

- (instancetype)initWithHomeController:(HomeController *)homeController;

@end
