//
//  AccessoriesController.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "AccessoriesController.h"

@interface AccessoriesController () <HMAccessoryBrowserDelegate>

@property (nonatomic, readonly) HMAccessoryBrowser *accessoryBrowser;

@property (nonatomic) NSArray *accessories;

@end

@implementation AccessoriesController

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _accessoryBrowser = [[HMAccessoryBrowser alloc] init];
        _accessoryBrowser.delegate = self;
        
        [_accessoryBrowser startSearchingForNewAccessories];
    }
    return self;
}

- (void)dealloc {
    [self.accessoryBrowser stopSearchingForNewAccessories];
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
    self.accessories = browser.discoveredAccessories;
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory {
    self.accessories = browser.discoveredAccessories;
}

@end
