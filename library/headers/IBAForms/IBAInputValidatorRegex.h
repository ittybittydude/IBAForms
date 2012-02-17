//
//  IBAInputValidatorRegex.h
//  IBAForms
//
//  Created by Sébastien HOUZE on 07/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBAInputValidatorGeneric.h"

@interface IBAInputValidatorRegex : IBAInputValidatorGeneric
{
    NSString *regex;
}

@property (nonatomic, retain) NSString *regex;

- (id)initWithRegex:(NSString *)regularExpression;

@end
