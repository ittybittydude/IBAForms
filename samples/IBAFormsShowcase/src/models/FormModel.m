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
@synthesize textStyled;
@synthesize password;
@synthesize passwordStyled;
@synthesize mandatoryDate;
@synthesize nonMandatoryDate;
@synthesize multiLineText;
@synthesize singlePickListItem;
@synthesize multiplePickListItems;
@synthesize booleanValue;

- (void)dealloc {
    [self setText:nil];
	[self setTextStyled:nil];
    [self setPassword:nil];
	[self setPasswordStyled:nil];
	[self setMandatoryDate:nil];
	[self setNonMandatoryDate:nil];
	[self setMultiLineText:nil];
	[self setSinglePickListItem:nil];
	[self setMultiplePickListItems:nil];
	[self setBooleanValue:nil];

    [super dealloc];
}

- (id)init {
	self = [super init];
	if (self != nil) {
		self.multiplePickListItems = [NSArray arrayWithObjects:@"Honda", @"Toyota", nil];
	}

	return self;
}

@end
