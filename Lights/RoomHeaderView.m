//
//  RoomHeaderView.m
//  Lights
//
//  Created by Evan Coleman on 11/11/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RoomHeaderView.h"

#import "RoomViewModel.h"

@interface RoomHeaderView ()

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIButton *onButton;
@property (nonatomic, readonly) UIButton *offButton;
@property (nonatomic, readonly) UIButton *editButton;

@end

@implementation RoomHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self != nil) {
        _titleLabel = [[UILabel alloc] initForAutoLayout];
        _titleLabel.font = [UIFont lights_boldFontWithSize:16];
        [self.contentView addSubview:_titleLabel];
        
        _onButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _onButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_onButton setTitle:NSLocalizedString(@"On", nil) forState:UIControlStateNormal];
        [_onButton sizeToFit];
        [self.contentView addSubview:_onButton];
        
        _offButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _offButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_offButton setTitle:NSLocalizedString(@"Off", nil) forState:UIControlStateNormal];
        [_offButton sizeToFit];
        [self.contentView addSubview:_offButton];
        
        _editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _editButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_editButton setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
        [_editButton sizeToFit];
        [self.contentView addSubview:_editButton];
        
        RAC(self.titleLabel, text) = RACObserve(self, viewModel.name);
        
        [_editButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:28];
        [_editButton autoSetDimension:ALDimensionWidth toSize:_editButton.bounds.size.width];
        [_editButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [_offButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_editButton withOffset:-28];
        [_offButton autoSetDimension:ALDimensionWidth toSize:_offButton.bounds.size.width];
        [_offButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

        [_onButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_offButton withOffset:-28];
        [_onButton autoSetDimension:ALDimensionWidth toSize:_onButton.bounds.size.width];
        [_onButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

        [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 14, 0, 0) excludingEdge:ALEdgeRight];
//        [_titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_onButton withOffset:-10];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, 38);
}

@end
