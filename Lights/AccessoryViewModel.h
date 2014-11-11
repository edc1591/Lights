//
//  AccessoryViewModel.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@class HomeController;

@interface AccessoryViewModel : NSObject

@property (nonatomic, readonly) HMAccessory *accessory;

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) RACCommand *pairAccessoryCommand;

- (instancetype)initWithAccessory:(HMAccessory *)accessory homeController:(HomeController *)homeController;

@end
