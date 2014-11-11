//
//  HomesController.m
//  Lights
//
//  Created by Evan Coleman on 11/10/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HomesController.h"

#import "HMHomeManager+RACSignalSupport.h"
#import "HMHome+RACSignalSupport.h"

@interface HomesController () <HMHomeManagerDelegate>

@property (nonatomic, readonly) HMHomeManager *homeManager;

@property (nonatomic) NSArray *homes;

@end

@implementation HomesController

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _homeManager = [[HMHomeManager alloc] init];
        _homeManager.delegate = self;
        
        RAC(self, homes) =
            [[self rac_signalForSelector:@selector(homeManagerDidUpdateHomes:)]
                reduceEach:^NSArray *(HMHomeManager *homeManager){
                    return homeManager.homes;
                }];
        
    }
    return self;
}

- (void)dealloc {
    self.homeManager.delegate = nil;
}

- (RACSignal *)addHome:(NSString *)name {
    return [self.homeManager rac_addHomeWithName:name];
}

- (RACSignal *)removeHome:(HMHome *)home {
    return [self.homeManager rac_removeHome:home];
}

@end
