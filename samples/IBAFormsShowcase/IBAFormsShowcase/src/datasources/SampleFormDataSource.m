//
// Copyright 2010 Itty Bitty Apps Pty Ltd
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import <IBAForms/IBAForms.h>
#import "SampleFormDataSource.h"
#import "StringToNumberTransformer.h"
#import "ShowcaseButtonStyle.h"

@implementation SampleFormDataSource

- (id)initWithModel:(id)aModel {
	if (self = [super initWithModel:aModel]) {
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
		[textInputTraitsSection addFormField:[numberField autorelease]];
		numberField.textFormFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;

		
		// Read-only fields
		IBAFormFieldStyle *readonlyFieldStyle = [[[IBAFormFieldStyle alloc] init] autorelease];
		readonlyFieldStyle.labelFrame = CGRectMake(IBAFormFieldLabelX, IBAFormFieldLabelY, IBAFormFieldLabelWidth + 100, IBAFormFieldLabelHeight);
		readonlyFieldStyle.labelTextAlignment = UITextAlignmentLeft;
    
		IBAFormSection *readonlyFieldSection = [self addSectionWithHeaderTitle:@"Read-Only Fields" footerTitle:nil];
		
        // IBAReadOnlyTextFormField displays the value the field is bound in a read-only text view. The title is displayed as the field's label.
		[readonlyFieldSection addFormField:[[[IBAReadOnlyTextFormField alloc] initWithKeyPath:@"readOnlyText" title:@"Read Only"] autorelease]];
		
        // IBATitleFormField displays the provided title in the field's label. No value is displayed for the field.
		[readonlyFieldSection addFormField:[[[IBATitleFormField alloc] initWithTitle:@"A title"] autorelease]];
        
		// IBALabelFormField displays the value the field is bound to as the field's label.
		IBALabelFormField *labelField = [[[IBALabelFormField alloc] initWithKeyPath:@"readOnlyText"] autorelease];
		labelField.formFieldStyle = readonlyFieldStyle;
		[readonlyFieldSection addFormField:labelField];

		
    
		// Some examples of how you might use the button form field
		IBAFormSection *buttonsSection = [self addSectionWithHeaderTitle:@"Buttons" footerTitle:nil];
		buttonsSection.formFieldStyle = [[[ShowcaseButtonStyle alloc] init] autorelease];
		
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
