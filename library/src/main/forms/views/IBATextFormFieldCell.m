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

#import "IBATextFormFieldCell.h"
#import "IBAFormConstants.h"

@implementation IBATextFormFieldCell

@synthesize textField = textField_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(textField_);
	
	[super dealloc];
}


- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier])) {
		// Create the text field for data entry
		self.textField = [[[UITextField alloc] initWithFrame:style.valueFrame] autorelease];
		self.textField.autoresizingMask = style.valueAutoresizingMask;
		self.textField.returnKeyType = UIReturnKeyNext;
		[self.cellView addSubview:self.textField];
	}
	
    return self;
}

- (void)activate {
	[super activate];
	
	self.textField.backgroundColor = self.formFieldStyle.activeColor;
}


- (void)applyFormFieldStyle {
	[super applyFormFieldStyle];
	
	self.textField.font = self.formFieldStyle.valueFont;
	self.textField.textColor = self.formFieldStyle.valueTextColor;
	self.textField.backgroundColor = self.formFieldStyle.valueBackgroundColor;
	self.textField.textAlignment = self.formFieldStyle.valueTextAlignment;
}

@end
