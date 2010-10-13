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

@implementation IBATextFormField

@synthesize textFormFieldCell;

- (void)dealloc {
	IBA_RELEASE_SAFELY(textFormFieldCell);
	
	[super dealloc];
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	return [self textFormFieldCell];
}


- (IBATextFormFieldCell *)textFormFieldCell {
	if (textFormFieldCell == nil) {
		textFormFieldCell = [[IBATextFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
		textFormFieldCell.textField.delegate = self;
		textFormFieldCell.textField.enabled = NO;
	}
	
	return textFormFieldCell;
}

- (void)updateCellContents {
	self.textFormFieldCell.label.text = self.title;
	self.textFormFieldCell.textField.text = [self formFieldStringValue];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[[IBAInputManager sharedIBAInputManager] activateNextInputRequestor];
	
	return YES;
}


#pragma mark -
#pragma mark IBAInputRequestor

- (NSString *)dataType {
	return IBAInputDataTypeText;
}

- (void)activate {
	[super activate];
	
	textFormFieldCell.textField.enabled = YES;
	[self.textFormFieldCell.textField becomeFirstResponder];
}

- (BOOL)deactivate {
	BOOL deactivated = [self setFormFieldValue:self.textFormFieldCell.textField.text];
	if (deactivated) {
		[self.textFormFieldCell.textField resignFirstResponder];
		self.textFormFieldCell.textField.enabled = NO;
		deactivated = [super deactivate];
	}
	
	return deactivated;
}

@end
