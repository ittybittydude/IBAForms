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

#import "IBABooleanFormField.h"


@interface IBABooleanFormField () 
- (void)switchValueChanged:(id)sender;
@end



@implementation IBABooleanFormField

@synthesize booleanFormFieldCell;

- (void)dealloc {
	IBA_RELEASE_SAFELY(booleanFormFieldCell);
	
	[super dealloc];
}

#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	return [self booleanFormFieldCell];
}

- (IBABooleanFormFieldCell *)booleanFormFieldCell {
	if (booleanFormFieldCell == nil) {
		booleanFormFieldCell = [[IBABooleanFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
		[booleanFormFieldCell.switchControl addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
	}
	
	return booleanFormFieldCell;
}

- (void)updateCellContents {
	self.booleanFormFieldCell.label.text = self.title;
	[self.booleanFormFieldCell.switchControl setOn:[[self formFieldValue] boolValue]];
}

	 
- (void)switchValueChanged:(id)sender {
	if (sender == self.booleanFormFieldCell.switchControl) {
		[self setFormFieldValue:[NSNumber numberWithBool:self.booleanFormFieldCell.switchControl.on]];
	}
}

@end
