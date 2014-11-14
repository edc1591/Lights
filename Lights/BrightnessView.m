//
//  BrightnessView.m
//  Lights
//
//  Created by Evan Coleman on 11/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BrightnessView.h"

@interface BrightnessView ()

@property (nonatomic, readonly) UILabel *brightnessLabel;

@property (nonatomic) CGFloat brightness;
@property (nonatomic) CGPoint lastTouchPoint;

@end

@implementation BrightnessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor blackColor];
        
        _brightnessLabel = [[UILabel alloc] initForAutoLayout];
        _brightnessLabel.font = [UIFont lights_boldFontWithSize:48];
        _brightnessLabel.textColor = [UIColor whiteColor];
        _brightnessLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_brightnessLabel];
        
        RAC(self.brightnessLabel, text) =
            [RACObserve(self, brightness)
                map:^NSString *(NSNumber *brightness) {
                    return [NSString stringWithFormat:@"%0.0f%@", [brightness doubleValue], @"%"];
                }];
        
        @weakify(self);
        [RACObserve(self, touchPoint)
            subscribeNext:^(NSValue *pointValue) {
                @strongify(self);
                if (CGPointEqualToPoint(self.lastTouchPoint, CGPointZero)) {
                    self.lastTouchPoint = [pointValue CGPointValue];
                } else {
                    CGFloat newBright = self.brightness + (self.lastTouchPoint.y - [pointValue CGPointValue].y);
                    if (newBright > 100) {
                        newBright = 100;
                    } else if (newBright < 0) {
                        newBright = 0;
                    }
                    self.brightness = newBright;
                    self.lastTouchPoint = [pointValue CGPointValue];
                }
            }];
        
        [_brightnessLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    return self;
}

@end
