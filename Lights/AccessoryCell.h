//
//  AccessoryCell.h
//  Lights
//
//  Created by Evan Coleman on 11/11/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

@class AccessoryViewModel;

@interface AccessoryCell : MCSwipeTableViewCell

@property (nonatomic) AccessoryViewModel *viewModel;

@end
