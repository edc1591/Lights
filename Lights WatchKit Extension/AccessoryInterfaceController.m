//
//  AccessoryInterfaceController.m
//  Lights
//
//  Created by Evan Coleman on 5/10/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

#import "AccessoryInterfaceController.h"

#import "AccessoryViewModel.h"

@interface AccessoryInterfaceController ()

@property (nonatomic) AccessoryViewModel *viewModel;

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *nameLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceSlider *brightnessSlider;

@end

@implementation AccessoryInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.viewModel = (AccessoryViewModel *)context;
    
    [self.nameLabel setText:self.viewModel.name];
    [self setTitle:self.viewModel.roomName];
    
    @weakify(self);
    
    [[RACObserve(self.viewModel, brightness)
        take:1]
        subscribeNext:^(NSNumber *brightness) {
            @strongify(self);
            
            [self.brightnessSlider setHidden:([brightness doubleValue] < 0)];
            
            if ([brightness doubleValue] >= 0) {
                [self.brightnessSlider setValue:[brightness floatValue]];
            }
        }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark Interface Actions

- (IBAction)handleOn {
    [self.viewModel.onCommand execute:nil];
}

- (IBAction)handleOff {
    [self.viewModel.offCommand execute:nil];
}

- (IBAction)handleBrightness:(float)value {
    [self.viewModel.setBrightnessCommand execute:@(value)];
}

@end



