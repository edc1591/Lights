//
//  HMHomeManager+RACSignalSupport.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "HMHomeManager+RACSignalSupport.h"

@implementation HMHomeManager (RACSignalSupport)

- (RACSignal *)rac_observeHomes {
    RACSignal *didUpdateSignal =
        [[[(NSObject *)self.delegate rac_signalForSelector:@selector(homeManagerDidUpdateHomes:)]
            reduceEach:^HMHomeManager *(HMHomeManager *homeManager){
                return homeManager;
            }]
            map:^NSArray *(HMHomeManager *homeManager) {
                return homeManager.homes;
            }];
    
    return [RACSignal merge:@[didUpdateSignal, RACObserve(self, homes)]];
}

- (RACSignal *)rac_addHomeWithName:(NSString *)name {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self willChangeValueForKey:@keypath(self, homes)];
        [self addHomeWithName:name completionHandler:^(HMHome *home, NSError *error) {
            @strongify(self);
            if (error == nil) {
                [self didChangeValueForKey:@keypath(self, homes)];
                [subscriber sendNext:home];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_removeHome:(HMHome *)home {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self willChangeValueForKey:@keypath(self, homes)];
        [self removeHome:home completionHandler:^(NSError *error) {
            @strongify(self);
            if (error != nil) {
                [subscriber sendError:error];
            } else {
                [self didChangeValueForKey:@keypath(self, homes)];
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

@end
