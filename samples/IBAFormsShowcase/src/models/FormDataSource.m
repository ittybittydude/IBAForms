//
//  FormDataSource.m
//  IBAFormsShowcase
//
//  Created by sean on 16/10/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import <IBAForms/IBAForms.h>
#import "FormDataSource.h"
#import "StringToNumberTransformer.h"

@implementation FormDataSource

- (id)initWithModel:(id)aModel {
	self = [super initWithModel:aModel];
	if (self != nil) {
		// Some basic form fields that accept text input
		IBAFormSection *basicFieldSection = [self addSectionWithHeaderTitle:@"Basic Form Fields" footerTitle:nil];

		[basicFieldSection addFormField:[[[IBATextFormField alloc] initWithKeyPath:@"text" title:@"Text"] autorelease]];
		[basicFieldSection addFormField:[[[IBAPasswordFormField alloc] initWithKeyPath:@"password" title:@"Password"] autorelease]];
		[basicFieldSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:@"booleanSwitchValue" title:@"Switch"] autorelease]];
		[basicFieldSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:@"booleanCheckValue" title:@"Check" type:IBABooleanFormFieldTypeCheck] autorelease]];

		// Styled form fields
		IBAFormSection *styledFieldSection = [self addSectionWithHeaderTitle:@"Styled Fields" footerTitle:nil];

		IBAFormFieldStyle *style = [[[IBAFormFieldStyle alloc] init] autorelease];
		style.labelTextColor = [UIColor blackColor];
		style.labelFont = [UIFont systemFontOfSize:14];
		style.labelTextAlignment = UITextAlignmentLeft;
		style.valueTextAlignment = UITextAlignmentRight;
		style.valueTextColor = [UIColor darkGrayColor];
		style.activeColor = [UIColor colorWithRed:0.934 green:0.791 blue:0.905 alpha:1.000];

		styledFieldSection.formFieldStyle = style;

		[styledFieldSection addFormField:[[[IBATextFormField alloc] initWithKeyPath:@"textStyled" title:@"Text"] autorelease]];
		[styledFieldSection addFormField:[[[IBAPasswordFormField alloc] initWithKeyPath:@"passwordStyled" title:@"Password"] autorelease]];


		// Date fields
		IBAFormSection *dateFieldSection = [self addSectionWithHeaderTitle:@"Dates" footerTitle:nil];

		NSDateFormatter *dateTimeFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateTimeFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateTimeFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateTimeFormatter setDateFormat:@"EEE d MMM  h:mm a"];

		[dateFieldSection addFormField:[[[IBADateFormField alloc] initWithKeyPath:@"dateTime"
															 title:@"Date & Time"
													  defaultValue:[NSDate date]
															  type:IBADateFormFieldTypeDateTime
													 dateFormatter:dateTimeFormatter] autorelease]];

		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateFormat:@"EEE d MMM yyyy"];

		[dateFieldSection addFormField:[[[IBADateFormField alloc] initWithKeyPath:@"date"
																		title:@"Date"
																 defaultValue:[NSDate date]
																		 type:IBADateFormFieldTypeDate
																dateFormatter:dateFormatter] autorelease]];

		NSDateFormatter *timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[timeFormatter setDateStyle:NSDateFormatterShortStyle];
		[timeFormatter setTimeStyle:NSDateFormatterNoStyle];
		[timeFormatter setDateFormat:@"h:mm a"];

		[dateFieldSection addFormField:[[[IBADateFormField alloc] initWithKeyPath:@"time"
																		title:@"Time"
																 defaultValue:[NSDate date]
																		 type:IBADateFormFieldTypeTime
																dateFormatter:timeFormatter] autorelease]];

		// Picklists
		IBAFormSection *pickListSection = [self addSectionWithHeaderTitle:@"Pick Lists" footerTitle:nil];

		NSArray *pickListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:@"Apples",
																					 @"Bananas",
																					 @"Oranges",
																					 @"Lemons",
																					 nil]];

		[pickListSection addFormField:[[[IBAPickListFormField alloc] initWithKeyPath:@"singlePickListItem"
																		   title:@"Single"
																valueTransformer:nil
																   selectionMode:IBAPickListSelectionModeSingle
																		 options:pickListOptions] autorelease]];

		NSArray *carListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:@"Honda",
																					  @"BMW",
																					  @"Holden",
																					  @"Ford",
																					  @"Toyota",
																					  @"Mitsubishi",
																					  nil]];

		IBAPickListFormOptionsStringTransformer *transformer = [[[IBAPickListFormOptionsStringTransformer alloc] initWithPickListOptions:carListOptions] autorelease];
		[pickListSection addFormField:[[[IBAPickListFormField alloc] initWithKeyPath:@"multiplePickListItems"
																		   title:@"Multiple"
																valueTransformer:transformer
																   selectionMode:IBAPickListSelectionModeMultiple
																		 options:carListOptions] autorelease]];

		// An example of modifying the UITextInputTraits of an IBATextFormField and using an NSValueTransformer
		IBAFormSection *textInputTraitsSection = [self addSectionWithHeaderTitle:@"Traits & Transformations" footerTitle:nil];
		IBATextFormField *numberField = [[IBATextFormField alloc] initWithKeyPath:@"number"
																		title:@"Number"
															 valueTransformer:[StringToNumberTransformer instance]];
		numberField.textFormFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;
		[textInputTraitsSection addFormField:[numberField autorelease]];


		// Some examples of how you might use the button form field
		IBAFormSection *buttonsSection = [self addSectionWithHeaderTitle:@"Buttons" footerTitle:nil];

		IBAFormFieldStyle *buttonStyle = [[[IBAFormFieldStyle alloc] init] autorelease];
		buttonStyle.labelTextColor = [UIColor colorWithRed:0.318 green:0.400 blue:0.569 alpha:1.0];
		buttonStyle.labelFont = [UIFont boldSystemFontOfSize:14];
		buttonStyle.labelTextAlignment = UITextAlignmentCenter;
		buttonStyle.labelFrame = CGRectMake(10, 8, 280, 30);
		
		buttonsSection.formFieldStyle = buttonStyle;
		
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:@"Go to Google"
																			 icon:nil
																   executionBlock:^{
																	   [[UIApplication sharedApplication]
																		openURL:[NSURL URLWithString:@"http://www.google.com"]];
																   }] autorelease]];

		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:@"Compose email"
																			 icon:nil
																   executionBlock:^{
																	   [[UIApplication sharedApplication]
																		openURL:[NSURL URLWithString:@"mailto:info@google.com"]];
																   }] autorelease]];

    }

    return self;
}

- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
	
	NSLog(@"%@", [self.model description]);
}

@end
