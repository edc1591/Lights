//
//  EmptyViewModel.h
//  Lights
//
//  Created by Evan Coleman on 11/9/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@interface EmptyViewModel : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *message;

@property (nonatomic, readonly) RACCommand *actionCommand;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actionCommand:(RACCommand *)actionCommand;

@end
