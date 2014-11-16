//
//  BrightnessView.h
//  Lights
//
//  Created by Evan Coleman on 11/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@class AccessoryViewModel;

@interface BrightnessViewController : UIViewController

- (instancetype)initWithViewModel:(AccessoryViewModel *)viewModel brightnessSignal:(RACSignal *)brightnessSignal;

@end
