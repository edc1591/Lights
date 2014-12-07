//
//  NSError+HomeKitExtensions.h
//  Lights
//
//  Created by Evan Coleman on 12/7/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (HomeKitExtensions)

- (BOOL)hk_isFatal;

@end
