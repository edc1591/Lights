//
//  AccessoryViewModel.m
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "AccessoryViewModel.h"

#import "RoomViewModel.h"

#import "HomeController.h"

#import "HMAccessory+RACSignalSupport.h"
#import "HMCharacteristic+RACSignalSupport.h"

@interface AccessoryViewModel () <HMAccessoryDelegate>

@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *brightness;
@property (nonatomic) UIColor *statusColor;

@end

@implementation AccessoryViewModel

- (instancetype)initWithAccessory:(HMAccessory *)accessory homeController:(HomeController *)homeController {
    self = [super init];
    if (self != nil) {
        _accessory = accessory;
        _accessory.delegate = self;
        
        RAC(self, name) = RACObserve(self.accessory, name);
        
        RAC(self, brightness) =
            [[[[self.accessory rac_getCharacterisitic:HMCharacteristicTypeBrightness]
                flattenMap:^RACSignal *(HMCharacteristic *characteristic) {
                    return [characteristic rac_observeValue];
                }]
                catchTo:[RACSignal return:@-1]]
                retry];
        
        RAC(self, statusColor) =
            [RACObserve(self.accessory, reachable)
                map:^UIColor *(NSNumber *reachable) {
                    return [reachable boolValue] ? [UIColor flatBlackColor] : [UIColor flatRedColor];
                }];
        
        @weakify(self);
        _pairAccessoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RoomViewModel *roomViewModel) {
            @strongify(self);
            return [[[homeController addAccessory:self.accessory]
                        materialize]
                        flattenMap:^RACSignal *(RACEvent *event) {
                            if (event.eventType == RACEventTypeCompleted) {
                                return [homeController assignAccessory:self.accessory toRoom:roomViewModel.room];
                            } else {
                                return [RACSignal error:event.error];
                            }
                        }];
        }];
        
        _deleteAccessoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [homeController removeAccessory:self.accessory];
        }];
        
        _renameAccessoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *newName) {
            @strongify(self);
            return [self.accessory rac_rename:newName];
        }];
        
        _onCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [[self.accessory rac_getCharacterisitic:HMCharacteristicTypePowerState]
                        flattenMap:^RACSignal *(HMCharacteristic *characteristic) {
                            return [characteristic rac_writeValue:@YES];
                        }];
        }];
        
        _offCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [[self.accessory rac_getCharacterisitic:HMCharacteristicTypePowerState]
                        flattenMap:^RACSignal *(HMCharacteristic *characteristic) {
                            return [characteristic rac_writeValue:@NO];
                        }];
        }];
        
        _setBrightnessCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *brightness) {
            brightness = @(round([brightness doubleValue])); // Make sure we send an integer
            @strongify(self);
            return [[self.accessory rac_getCharacterisitic:HMCharacteristicTypeBrightness]
                        flattenMap:^RACSignal *(HMCharacteristic *characteristic) {
                            return [characteristic rac_writeValue:brightness];
                        }];
        }];
    }
    return self;
}

@end
