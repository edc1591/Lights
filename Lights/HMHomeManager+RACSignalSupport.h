//
//  HMHomeManager+RACSignalSupport.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <HomeKit/HomeKit.h>

@interface HMHomeManager (RACSignalSupport)

/// Sends an NSArray of HMHome objects.
/// Requires a delegate to be set.
- (RACSignal *)rac_observeHomes;

- (RACSignal *)rac_addHomeWithName:(NSString *)name;
- (RACSignal *)rac_removeHome:(HMHome *)home;

@end
