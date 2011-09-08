//
//  IBAInputValidatorGeneric.m
//  IBAForms
//
//  Created by Sébastien HOUZE on 06/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IBAInputValidatorGeneric.h"
#import "IBAFormSection.h"

@implementation IBAInputValidatorGeneric

@synthesize required, error, messageInvalid, messageRequired;

- (id)init {
    self = [super init];
    if (self) {
        error = @"";
        messageInvalid = [NSString stringWithString:@"invalid value for %@"];
        messageRequired = [NSString stringWithString:@"%@ is required"];
        required = NO;
    }
    return self;
}

- (BOOL)isNotValid:(NSString *)stringToCheck
{
    if (required) {
        if ([stringToCheck length] == 0) {
            error = messageRequired;
            return YES;
        }
    }
    error = @"";
    return NO;
}

@end
