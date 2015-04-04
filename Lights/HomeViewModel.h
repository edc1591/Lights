//
//  HomeViewModel.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "ViewModel.h"

@class HomeController;

@interface HomeViewModel : ViewModel

@property (nonatomic, readonly) HMHome *home;
@property (nonatomic, readonly) HomeController *homeController;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *rooms;
@property (nonatomic, readonly) NSArray *accessories;

- (instancetype)initWithHome:(HMHome *)home homeController:(HomeController *)homeController;

@end
