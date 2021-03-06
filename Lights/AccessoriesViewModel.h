//
//  AccessoriesViewModel.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "ViewModel.h"

@class AccessoriesController;
@class HomeController;

@interface AccessoriesViewModel : ViewModel

@property (nonatomic, readonly) NSArray *viewModels;

@property (nonatomic, readonly) NSArray *roomViewModels;

- (instancetype)initWithAccessoriesController:(AccessoriesController *)accessoriesController homeController:(HomeController *)homeController;

@end
