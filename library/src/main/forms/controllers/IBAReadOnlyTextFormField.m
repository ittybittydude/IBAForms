//
//  Created by Chris Miles on 7/04/11.
//  Copyright 2011 Chris Miles. All rights reserved.
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

#import "IBAReadOnlyTextFormField.h"


@implementation IBAReadOnlyTextFormField

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
		textFormFieldCell_.textField.enabled = NO;
		textFormFieldCell_.textField.userInteractionEnabled = NO;	// read only
	}
	
	return textFormFieldCell_;
}

- (void)updateCellContents {
	self.textFormFieldCell.label.text = self.title;
	self.textFormFieldCell.textField.text = [self formFieldStringValue];
}


@end
