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

#import "LoginDataSource.h"

#import <IBAForms/IBAForms.h>
#import "IBAFormFieldStyle+Login.h"

@implementation LoginDataSource

- (id)initWithModel:(id)model formAction:(IBAButtonFormFieldBlock)action {
	if ((self = [super initWithModel:model])) {
		IBAFormSection *loginFormSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
		IBATextFormField *emailTextFormField = [IBATextFormField emailTextFormFieldWithSection:loginFormSection
                                                                                       keyPath:@"emailAddress"
                                                                                         title:NSLocalizedString(@"Email", @"")
                                                                              valueTransformer:nil];
		IBATextFormField *passwordTextFormField = [IBATextFormField passwordTextFormFieldWithSection:loginFormSection
                                                                                             keyPath:@"password"
                                                                                               title:NSLocalizedString(@"Password", @"")
                                                                                    valueTransformer:nil];

		[emailTextFormField setFormFieldStyle:[IBAFormFieldStyle textFormFieldStyle]];
		[passwordTextFormField setFormFieldStyle:[emailTextFormField formFieldStyle]];

		IBAFormSection *submitFormSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
		IBAButtonFormField *submitFormField = [[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Login", @"")
                                                                                   icon:nil
                                                                         executionBlock:action];
		[submitFormField setFormFieldStyle:[IBAFormFieldStyle buttonFormFieldStyle]];
		[submitFormSection addFormField:submitFormField];
		[submitFormField release], submitFormField = nil;
	}

	return self;
}

@end
