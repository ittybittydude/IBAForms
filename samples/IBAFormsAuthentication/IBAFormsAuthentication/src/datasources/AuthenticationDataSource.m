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

#import "AuthenticationDataSource.h"
#import <IBAForms/IBAForms.h>

@implementation AuthenticationDataSource

- (id)initWithModel:(id)model formAction:(IBAButtonFormFieldBlock)action
{
	if ((self = [super initWithModel:model]))
	{
		IBAFormSection *login_form_section = [self addSectionWithHeaderTitle:NSLocalizedString(@"Identify Yourself", @"")
																 footerTitle:[NSString string]];
		[IBATextFormField emailTextFormFieldWithSection:login_form_section
												keyPath:@"emailAddress"
												  title:NSLocalizedString(@"Email Address", @"")
									   valueTransformer:nil];
		[IBATextFormField passwordTextFormFieldWithSection:login_form_section
												   keyPath:@"password"
													 title:NSLocalizedString(@"Password", @"")
										  valueTransformer:nil];

		IBAFormSection *submit_form_section = [self addSectionWithHeaderTitle:nil footerTitle:nil];
		IBAButtonFormField *submit_form_field = [[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Login", @"")
																					 icon:nil
																		   executionBlock:action];
		[submit_form_section addFormField:submit_form_field];
		[submit_form_field release], submit_form_field = nil;
	}

	return self;
}

@end
