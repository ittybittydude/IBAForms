//
//  FormModel.m
//  IBAFormsShowcase
//
//  Created by sean on 16/10/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "FormModel.h"


@implementation FormModel

@synthesize text;
@synthesize password;
@synthesize mandatoryDate;
@synthesize nonMandatoryDate;
@synthesize multiLineText;
@synthesize url;
@synthesize singlePickListItem;
@synthesize multiplePickListItems;

- (void)dealloc {
    [self setText:nil];
    [self setPassword:nil];
	[self setMandatoryDate:nil];
	[self setNonMandatoryDate:nil];
	[self setMultiLineText:nil];
	[self setURL:nil];
	[self setSinglePickListItem:nil];
	[self setMultiLineText:nil];
	
    [super dealloc];
}

@end
