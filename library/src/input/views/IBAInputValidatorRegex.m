//
//  IBAInputValidatorRegex.m
//  IBAForms
//
//  Created by Sébastien HOUZE on 07/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IBAInputValidatorRegex.h"

@implementation IBAInputValidatorRegex

@synthesize regex;

- (id)initWithRegex:(NSString *)regularExpression
{
    self = [super init];
    if (self) {
        required = NO;
        regex = regularExpression;
    }
    return self;
}

- (BOOL)isNotValid:(NSString *)stringToCheck
{
    BOOL returnValue = NO;
    NSPredicate *stringTest = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] retain];

    if ([super isNotValid:stringToCheck])
        returnValue = YES;
    else if (!([stringTest evaluateWithObject:stringToCheck]))
    {
        returnValue = YES;
        error = messageInvalid;
    }
    return returnValue;
}


@end
