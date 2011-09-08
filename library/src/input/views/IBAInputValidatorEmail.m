//
//  IBAInputValidatorEmail.m
//  IBAForms
//
//  Created by Sébastien HOUZE on 07/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IBAInputValidatorEmail.h"

@implementation IBAInputValidatorEmail


-(id)init
{
    self = [super initWithRegex:@"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@([a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}"];
    
    return self; 
}

@end
