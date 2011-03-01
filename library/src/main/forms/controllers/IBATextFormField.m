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

#import "IBATextFormField.h"
#import "IBAFormConstants.h"
#import "IBAInputCommon.h"
#import "IBAInputManager.h"
#import "IBAInputManager.h"

@implementation IBATextFormField

@synthesize textFormFieldCell = textFormFieldCell_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(textFormFieldCell_);
	
	[super dealloc];
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	return [self textFormFieldCell];
}


- (IBATextFormFieldCell *)textFormFieldCell {
	if (textFormFieldCell_ == nil) {
		textFormFieldCell_ = [[IBATextFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
		textFormFieldCell_.textField.delegate = self;
		textFormFieldCell_.textField.enabled = NO;
	}
	
	return textFormFieldCell_;
}

- (void)updateCellContents {
	self.textFormFieldCell.label.text = self.title;
	self.textFormFieldCell.textField.text = [self formFieldStringValue];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return [[IBAInputManager sharedIBAInputManager] activateNextInputRequestor];;
}


#pragma mark -
#pragma mark IBAInputRequestor

- (NSString *)dataType {
	return IBAInputDataTypeText;
}

- (void)activate {
	self.textFormFieldCell.textField.enabled = YES;
	[super activate];
}

- (BOOL)deactivate {
	BOOL deactivated = [self setFormFieldValue:self.textFormFieldCell.textField.text];
	if (deactivated) {
		self.textFormFieldCell.textField.enabled = NO;
		deactivated = [super deactivate];
	}
	
	return deactivated;
}

- (UIResponder *)responder {
	return self.textFormFieldCell.textField;
}

@end
