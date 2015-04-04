//
//  AccessoryViewModel.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "ViewModel.h"

@class HomeController;

@interface AccessoryViewModel : ViewModel

@property (nonatomic, readonly) HMAccessory *accessory;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSNumber *brightness;
@property (nonatomic, readonly) UIColor *statusColor;

@property (nonatomic, readonly) RACCommand *pairAccessoryCommand;
@property (nonatomic, readonly) RACCommand *deleteAccessoryCommand;
@property (nonatomic, readonly) RACCommand *renameAccessoryCommand;

@property (nonatomic, readonly) RACCommand *onCommand;
@property (nonatomic, readonly) RACCommand *offCommand;
@property (nonatomic, readonly) RACCommand *setBrightnessCommand;

- (instancetype)initWithAccessory:(HMAccessory *)accessory homeController:(HomeController *)homeController;

@end
