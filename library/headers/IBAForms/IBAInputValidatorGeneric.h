//
//  IBAInputValidatorGeneric.h
//  IBAForms
//
//  Created by Sébastien HOUZE on 06/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBAInputValidatorGeneric : NSObject
{
    BOOL required;
    NSString *messageRequired;
    NSString *messageInvalid;
    NSString *error;
}

@property (nonatomic) BOOL required;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSString *messageRequired;
@property (nonatomic, retain) NSString *messageInvalid;

- (BOOL)isNotValid:(NSString *)stringToCheck;

@end
