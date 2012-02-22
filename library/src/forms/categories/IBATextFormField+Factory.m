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

#import "IBATextFormField+Factory.h"

@implementation IBATextFormField (Factory)

+ (IBATextFormField *)emailTextFormFieldWithSection:(IBAFormSection *)section
											keyPath:(NSString *)keyPath
											  title:(NSString *)title
								   valueTransformer:(NSValueTransformer *)valueTransformer {
	IBATextFormField *textFormField = [[self alloc] initWithKeyPath:keyPath title:title valueTransformer:valueTransformer];
	[section addFormField:textFormField];

	IBATextFormFieldCell *formFieldCell = textFormField.textFormFieldCell;
	formFieldCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	formFieldCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
	formFieldCell.textField.keyboardType = UIKeyboardTypeEmailAddress;

	return [textFormField autorelease];
}

+ (IBATextFormField *)passwordTextFormFieldWithSection:(IBAFormSection *)section
											   keyPath:(NSString *)keyPath
												 title:(NSString *)title
									  valueTransformer:(NSValueTransformer *)valueTransformer {
	IBATextFormField *textFormField = [[self alloc] initWithKeyPath:keyPath title:title valueTransformer:valueTransformer];
	[section addFormField:textFormField];

	IBATextFormFieldCell *formFieldCell = textFormField.textFormFieldCell;
	formFieldCell.textField.secureTextEntry = YES;

	return [textFormField autorelease];
}

@end
