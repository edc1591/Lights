//
//  HomesController.h
//  Lights
//
//  Created by Evan Coleman on 11/10/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@interface HomesController : NSObject

@property (nonatomic, readonly) NSArray *homes;

- (RACSignal *)addHome:(NSString *)name;

- (RACSignal *)removeHome:(HMHome *)home;

@end
