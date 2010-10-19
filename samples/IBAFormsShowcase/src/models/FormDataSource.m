//
//  FormDataSource.m
//  IBAFormsShowcase
//
//  Created by sean on 16/10/10.
//  Copyright 2010 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "FormDataSource.h"
#import "IBATextFormField.h"
#import "IBAPasswordFormField.h"
#import "IBAMultilineTextFormField.h"
#import "IBAURLFormField.h"
#import "IBAButtonFormField.h"
#import "IBADateFormField.h"
#import "IBAPickListOptionsProvider.h"
#import "IBAPickListFormField.h"
#import "IBAFormFieldStyle.h"

@implementation FormDataSource

- (id)initWithModel:(id)aModel {
	self = [super initWithModel:aModel];
	if (self != nil) {
		// Some basic form fields that accept text input
		IBAFormSection *textFieldSection = [self addSectionWithHeaderTitle:@"Basic Form Fields" footerTitle:nil];		
		
		[textFieldSection addFormField:[[[IBATextFormField alloc] initWithKey:@"text" title:@"Text"] autorelease]];
		[textFieldSection addFormField:[[[IBAPasswordFormField alloc] initWithKey:@"password" title:@"Password"] autorelease]];
		[textFieldSection addFormField:[[[IBAMultilineTextFormField alloc] initWithKey:@"multiLineText" title:nil] autorelease]];
		[textFieldSection addFormField:[[[IBAURLFormField alloc] initWithKey:@"url" title:@"Website"] autorelease]];
		  
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
		
		[styledFieldSection addFormField:[[[IBATextFormField alloc] initWithKey:@"textStyled" title:@"Text"] autorelease]];
		[styledFieldSection addFormField:[[[IBAPasswordFormField alloc] initWithKey:@"passwordStyled" title:@"Password"] autorelease]];
		[styledFieldSection addFormField:[[[IBAURLFormField alloc] initWithKey:@"urlStyled" title:@"Website"] autorelease]];
		
		
		// Date fields
		IBAFormSection *dateFieldSection = [self addSectionWithHeaderTitle:@"Dates" footerTitle:nil];		

		NSDateFormatter *dateTimeFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateTimeFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateTimeFormatter setTimeStyle:NSDateFormatterNoStyle];	
		[dateTimeFormatter setDateFormat:@"EEE d MMM  h:mm a"];

		[dateFieldSection addFormField:[[[IBADateFormField alloc] initWithKey:@"dateTime" 
															 title:@"Date & Time" 
													  defaultValue:[NSDate date]
															  type:IBADateFormFieldTypeDateTime 
														  editable:NO 
														   movable:NO 
													 dateFormatter:dateTimeFormatter] autorelease]];

		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];	
		[dateFormatter setDateFormat:@"EEE d MMM yyyy"];
		
		[dateFieldSection addFormField:[[[IBADateFormField alloc] initWithKey:@"date" 
																		title:@"Date" 
																 defaultValue:[NSDate date]
																		 type:IBADateFormFieldTypeDate 
																	 editable:NO 
																	  movable:NO 
																dateFormatter:dateFormatter] autorelease]];
		
		NSDateFormatter *timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[timeFormatter setDateStyle:NSDateFormatterShortStyle];
		[timeFormatter setTimeStyle:NSDateFormatterNoStyle];	
		[timeFormatter setDateFormat:@"h:mm a"];
		
		[dateFieldSection addFormField:[[[IBADateFormField alloc] initWithKey:@"time" 
																		title:@"Time" 
																 defaultValue:[NSDate date]
																		 type:IBADateFormFieldTypeTime 
																	 editable:NO 
																	  movable:NO 
																dateFormatter:timeFormatter] autorelease]];
		  
		// Picklists
		IBAFormSection *pickListSection = [self addSectionWithHeaderTitle:@"Pick Lists" footerTitle:nil];		

		NSArray *pickListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:@"Apples", 
																					 @"Bananas", 
																					 @"Oranges", 
																					 @"Lemons", 
																					 nil]];
		
		[pickListSection addFormField:[[[IBAPickListFormField alloc] initWithKey:@"singlePickListItem"
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
		[pickListSection addFormField:[[[IBAPickListFormField alloc] initWithKey:@"multiplePickListItems"
																		   title:@"Multiple"
																valueTransformer:transformer
																   selectionMode:IBAPickListSelectionModeMultiple
																		 options:carListOptions] autorelease]];
		
		
		// Some examples of how you might use the button form field
		IBAFormSection *buttonsSection = [self addSectionWithHeaderTitle:@"Buttons" footerTitle:nil];		
		  
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
		  	  
@end
