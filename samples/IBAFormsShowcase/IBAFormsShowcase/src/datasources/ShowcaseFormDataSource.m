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
#import "ShowcaseFieldStyle.h"

@interface ShowcaseFormDataSource()
- (void)displaySampleForm;
- (void)dismissSampleForm;
@end


@implementation ShowcaseFormDataSource

- (id)initWithModel:(id)aModel {
	if ((self = [super initWithModel:aModel])) {
		IBAFormSection *displayOptionsSection = [self addSectionWithHeaderTitle:@"Display Options" footerTitle:nil];
		displayOptionsSection.formFieldStyle = [[[ShowcaseFieldStyle alloc] init] autorelease];
		
		[displayOptionsSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:@"shouldAutoRotate" title:@"Autorotate"] autorelease]];
		[displayOptionsSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:@"tableViewStyleGrouped" title:@"Group"] autorelease]];
		[displayOptionsSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:@"modalPresentation" title:@"Modal"] autorelease]];
        [displayOptionsSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:@"displayNavigationToolbar" title:@"Nav Toolbar"] autorelease]];

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
		[buttonSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:@"Show Sample Form"
																		  icon:nil
																executionBlock:^{
																	[self displaySampleForm];
																}] autorelease]];
    }
	
    return self;
}

- (void)displaySampleForm {
	ShowcaseModel *showcaseModel = [self model];
	
	NSMutableDictionary *sampleFormModel = [[[NSMutableDictionary alloc] init] autorelease];
  
	// Values set on the model will be reflected in the form fields.
	[sampleFormModel setObject:@"A value contained in the model" forKey:@"readOnlyText"];
  
	SampleFormDataSource *sampleFormDataSource = [[[SampleFormDataSource alloc] initWithModel:sampleFormModel] autorelease];
	SampleFormController *sampleFormController = [[[SampleFormController alloc] initWithNibName:nil bundle:nil formDataSource:sampleFormDataSource] autorelease];
	sampleFormController.title = @"Sample Form";
	sampleFormController.shouldAutoRotate = showcaseModel.shouldAutoRotate;
	sampleFormController.tableViewStyle = showcaseModel.tableViewStyleGrouped ? UITableViewStyleGrouped : UITableViewStylePlain;
	
    [[IBAInputManager sharedIBAInputManager] setInputNavigationToolbarEnabled:showcaseModel.displayNavigationToolbar];
    
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
