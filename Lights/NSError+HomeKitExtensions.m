//
//  NSError+HomeKitExtensions.m
//  Lights
//
//  Created by Evan Coleman on 12/7/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "NSError+HomeKitExtensions.h"

@implementation NSError (HomeKitExtensions)

- (BOOL)hk_isFatal {
    if (self.domain != HMErrorDomain) return NO;
    switch (self.code) {
        case HMErrorCodeUserDeclinedAddingUser:
        case HMErrorCodeUserDeclinedRemovingUser:
        case HMErrorCodeUserManagementFailed:
        case HMErrorCodeRecurrenceTooSmall:
        case HMErrorCodeInvalidValueType:
        case HMErrorCodeValueLowerThanMinimum:
        case HMErrorCodeValueHigherThanMaximum:
        case HMErrorCodeStringLongerThanMaximum:
        case HMErrorCodeHomeAccessNotAuthorized:
        case HMErrorCodeOperationNotSupported:
        case HMErrorCodeMaximumObjectLimitReached:
        case HMErrorCodeAccessorySentInvalidResponse:
        case HMErrorCodeStringShorterThanMinimum:
        case HMErrorCodeGenericError:
        case HMErrorCodeSecurityFailure:
        case HMErrorCodeCommunicationFailure:
        case HMErrorCodeMessageAuthenticationFailed:
        case HMErrorCodeInvalidMessageSize:
        case HMErrorCodeAccessoryDiscoveryFailed:
        case HMErrorCodeClientRequestError:
        case HMErrorCodeAccessoryResponseError:
        case HMErrorCodeNameDoesNotEndWithValidCharacters:
        case HMErrorCodeAccessoryIsBlocked:
        case HMErrorCodeInvalidAssociatedServiceType:
        case HMErrorCodeActionSetExecutionFailed:
        case HMErrorCodeActionSetExecutionPartialSuccess:
        case HMErrorCodeActionSetExecutionInProgress:
        case HMErrorCodeAccessoryOutOfCompliance:
        case HMErrorCodeDataResetFailure:
        case HMErrorCodeRecurrenceMustBeOnSpecifiedBoundaries:
        case HMErrorCodeDateMustBeOnSpecifiedBoundaries:
        case HMErrorCodeCannotActivateTriggerTooFarInFuture:
        case HMErrorCodeRecurrenceTooLarge:
        case HMErrorCodeReadWritePartialSuccess:
        case HMErrorCodeReadWriteFailure:
        case HMErrorCodeNetworkUnavailable:
        case HMErrorCodeAddAccessoryFailed:
        case HMErrorCodeMissingEntitlement:
            return YES;
        default:
            return NO;
    }
}

@end
