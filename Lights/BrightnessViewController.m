//
//  BrightnessView.m
//  Lights
//
//  Created by Evan Coleman on 11/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BrightnessViewController.h"

#import "AccessoryViewModel.h"

@interface BrightnessViewController ()

@property (nonatomic) AccessoryViewModel *viewModel;

@property (nonatomic) UILabel *brightnessLabel;

@property (nonatomic) CGFloat brightness;

@end

@implementation BrightnessViewController

- (instancetype)initWithViewModel:(AccessoryViewModel *)viewModel brightnessSignal:(RACSignal *)brightnessSignal {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _viewModel = viewModel;
        
        RAC(self, brightness) = brightnessSignal;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.view addSubview:blurView];
    
    self.brightnessLabel = [[UILabel alloc] initForAutoLayout];
    self.brightnessLabel.font = [UIFont lights_boldFontWithSize:48];
    self.brightnessLabel.textColor = [UIColor whiteColor];
    self.brightnessLabel.textAlignment = NSTextAlignmentCenter;
    [blurView.contentView addSubview:self.brightnessLabel];
    
    @weakify(self);
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    [self.view addGestureRecognizer:gestureRecognizer];
    [[gestureRecognizer.rac_gestureSignal
        filter:^BOOL(UIGestureRecognizer *gestureRecognizer) {
            return (gestureRecognizer.state == UIGestureRecognizerStateRecognized);
        }]
        subscribeNext:^(id _) {
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    
    RAC(self.brightnessLabel, text) =
        [RACObserve(self, brightness)
            map:^NSString *(NSNumber *brightness) {
                return [NSString stringWithFormat:@"%0.0f%@", [brightness doubleValue], @"%"];
            }];
    
    [[[RACObserve(self, brightness)
        distinctUntilChanged]
        throttle:0.1]
        subscribeNext:^(NSNumber *brightness) {
            @strongify(self);
            [self.viewModel.setBrightnessCommand execute:brightness];
        }];
    
    [blurView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.brightnessLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

@end
