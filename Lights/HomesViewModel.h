//
//  HomesViewModel.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "ViewModel.h"

@class HomesController;

@interface HomesViewModel : ViewModel

@property (nonatomic, readonly) HomesController *homesController;

@property (nonatomic, readonly) NSArray *viewModels;

@property (nonatomic, readonly) RACCommand *addHomeCommand;
@property (nonatomic, readonly) RACCommand *removeHomeCommand;
@property (nonatomic, readonly) RACCommand *tapHomeCommand;

- (instancetype)initWithHomesController:(HomesController *)homesController;

@end
