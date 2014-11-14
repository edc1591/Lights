//
//  TableViewController.m
//  Lights
//
//  Created by Evan Coleman on 11/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        _navigationBarColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.backgroundColor = [UIColor flatGrayColor];
//    self.tableView.separatorColor = [UIColor flatGrayColorDark];
    
    @weakify(self);
    [[RACSignal combineLatest:@[RACObserve(self, navigationBarColor), [self rac_signalForSelector:@selector(viewWillAppear:)]]
        reduce:^UIColor *(UIColor *color, id _){
            return color;
        }]
        subscribeNext:^(UIColor *barColor) {
            @strongify(self);
            self.navigationController.toolbar.barTintColor = [UIColor colorWithComplementaryFlatColorOf:barColor];
            self.navigationController.toolbar.tintColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:self.navigationController.toolbar.barTintColor isFlat:YES];
            self.navigationController.navigationBar.barTintColor = barColor;
            self.navigationController.navigationBar.tintColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:barColor isFlat:YES];
            self.navigationController.navigationBar.titleTextAttributes = @{ NSFontAttributeName: [UIFont lights_boldFontWithSize:18],
                                                                  NSForegroundColorAttributeName: [UIColor colorWithContrastingBlackOrWhiteColorOn:barColor
                                                                                                                                            isFlat:YES]
                                                                  };
            [[UIApplication sharedApplication] setStatusBarStyle:[ChameleonStatusBar statusBarStyleForColor:barColor] animated:YES];
        }];
    
    RACSignal *barButtonItemSignal =
        [RACSignal merge:@[RACObserve(self.navigationItem, leftBarButtonItem),
                           RACObserve(self.navigationItem, rightBarButtonItem)]];
    [[RACSignal combineLatest:@[barButtonItemSignal, RACObserve(self, navigationBarColor)]]
        subscribeNext:^(RACTuple *t) {
            RACTupleUnpack(UIBarButtonItem *barButtonItem, UIColor *barColor) = t;
            barButtonItem.tintColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:barColor isFlat:YES];
        }];
}

@end
