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

#import "ShowcaseFormDataSource.h"
#import <IBAForms/IBAForms.h>
#import "SampleFormDataSource.h"
#import "SampleFormController.h"
#import "ShowcaseModel.h"
#import "ShowcaseButtonStyle.h"

@interface ShowcaseFormDataSource()
- (void)displaySampleForm;
- (void)dismissSampleForm;
@end


@implementation ShowcaseFormDataSource

- (id)initWithModel:(id)aModel {
	self = [super initWithModel:aModel];
	if (self != nil) {
		// Some basic form fields that accept text input
		IBAFormSection *displayOptionsSection = [self addSectionWithHeaderTitle:@"Display Options" footerTitle:nil];
		
		IBAFormFieldStyle *style = [[[IBAFormFieldStyle alloc] init] autorelease];
		style.labelTextColor = [UIColor blackColor];
		style.labelFont = [UIFont boldSystemFontOfSize:18];
		style.labelTextAlignment = UITextAlignmentLeft;
		style.labelFrame = CGRectMake(IBAFormFieldLabelX, 8, 140, IBAFormFieldLabelHeight);
		style.valueTextAlignment = UITextAlignmentRight;
		style.valueTextColor = [UIColor colorWithRed:0.220 green:0.329 blue:0.529 alpha:1.0];
		style.valueFont = [UIFont systemFontOfSize:16];
		style.valueFrame = CGRectMake(160, 13, 150, IBAFormFieldValueHeight);
		displayOptionsSection.formFieldStyle = style;
		
		
		[displayOptionsSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:@"shouldAutoRotate" 
																				title:@"Autorotate"] autorelease]];
		
		[displayOptionsSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:@"tableViewStyleGrouped" 
																					title:@"Group"] autorelease]];
		
		[displayOptionsSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:@"modalPresentation" 
																					title:@"Modal"] autorelease]];
		
		NSArray *modalPresentationStyleOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:
																									@"Full Screen", 
																									@"Page Sheet",
																									@"Form Sheet", 
																									@"Current Context",
																									nil]];
		
		IBASingleIndexTransformer *modalPresentationStyleTransformer = [[[IBASingleIndexTransformer alloc] initWithPickListOptions:modalPresentationStyleOptions] autorelease];
		
		[displayOptionsSection addFormField:[[[IBAPickListFormField alloc] initWithKeyPath:@"modalPresentationStyle"
																					 title:@"Modal Style"
																		  valueTransformer:modalPresentationStyleTransformer
																			 selectionMode:IBAPickListSelectionModeSingle
																				   options:modalPresentationStyleOptions] autorelease]];	
		
		
		IBAFormSection *buttonSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
		buttonSection.formFieldStyle = [[[ShowcaseButtonStyle alloc] init] autorelease];;
		
		IBAButtonFormField *buttonField = [[[IBAButtonFormField alloc] initWithTitle:@"Show Sample Form"
																		  icon:nil
																executionBlock:^{
																	[self displaySampleForm];
																}] autorelease];
		
		[buttonSection addFormField:buttonField];
		buttonField.cell.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
	
    return self;
}

- (void)displaySampleForm {
	ShowcaseModel *showcaseModel = [self model];
	
	NSMutableDictionary *sampleFormModel = [[[NSMutableDictionary alloc] init] autorelease];
	SampleFormDataSource *sampleFormDataSource = [[[SampleFormDataSource alloc] initWithModel:sampleFormModel] autorelease];
	SampleFormController *sampleFormController = [[[SampleFormController alloc] initWithNibName:nil bundle:nil formDataSource:sampleFormDataSource] autorelease];
	sampleFormController.title = @"Sample Form";
	sampleFormController.shouldAutoRotate = showcaseModel.shouldAutoRotate;
	sampleFormController.tableViewStyle = showcaseModel.tableViewStyleGrouped ? UITableViewStyleGrouped : UITableViewStylePlain;
	
	UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
	if (showcaseModel.modalPresentation) {
		UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																					 target:self 
																					 action:@selector(dismissSampleForm)] autorelease];
		sampleFormController.navigationItem.rightBarButtonItem = doneButton;
		UINavigationController *formNavigationController = [[[UINavigationController alloc] initWithRootViewController:sampleFormController] autorelease];
		formNavigationController.modalPresentationStyle = showcaseModel.modalPresentationStyle;
		[rootViewController presentModalViewController:formNavigationController animated:YES];
	} else {
		if ([rootViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)rootViewController pushViewController:sampleFormController animated:YES];
		}
	}
}

- (void)dismissSampleForm {
	[[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissModalViewControllerAnimated:YES];
}

@end
