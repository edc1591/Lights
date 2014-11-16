//
//  TableView.m
//  Lights
//
//  Created by Evan Coleman on 11/14/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "TableView.h"

@interface TableView () <UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat translation;
@property (nonatomic) NSIndexPath *holdIndexPath;

@end

@implementation TableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self != nil) {
        UILongPressGestureRecognizer *pressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:nil action:nil];
        [self addGestureRecognizer:pressGestureRecognizer];
        
        @weakify(self);
        [[[[pressGestureRecognizer.rac_gestureSignal
            doNext:^(UIGestureRecognizer *gestureRecognizer) {
                @strongify(self);
                if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                    self.holdIndexPath = nil;
                }
            }]
            filter:^BOOL(UIGestureRecognizer *gestureRecognizer) {
                return (gestureRecognizer.state == UIGestureRecognizerStateBegan);
            }]
            map:^NSIndexPath *(UIGestureRecognizer *gestureRecognizer) {
                CGPoint touchPoint = [gestureRecognizer locationInView:self];
                NSIndexPath *indexPath = [self indexPathForRowAtPoint:touchPoint];
                return indexPath;
            }]
            subscribeNext:^(NSIndexPath *indexPath) {
                @strongify(self);
                self.holdIndexPath = indexPath;
            }];
        
        RAC(self, translation) =
            [[[[pressGestureRecognizer.rac_gestureSignal
                filter:^BOOL(UIGestureRecognizer *gestureRecognizer) {
                    return (gestureRecognizer.state == UIGestureRecognizerStateChanged);
                }]
                map:^NSNumber *(UIGestureRecognizer *gestureRecognizer) {
                    @strongify(self);
                    return @([gestureRecognizer locationInView:self].y);
                }]
                combinePreviousWithStart:nil
                reduce:^NSNumber *(NSNumber *previous, NSNumber *current) {
                    return @([current doubleValue] - [previous ?: current doubleValue]);
                }]
                scanWithStart:nil
                reduce:^NSNumber *(NSNumber *translation, NSNumber *diff) {
                    return @([translation doubleValue] - [diff doubleValue]);
                }];
    }
    return self;
}

@end
