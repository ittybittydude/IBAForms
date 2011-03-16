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

#import "IBALabelFormCell.h"
#import "IBAFormConstants.h"

@implementation IBALabelFormCell

@synthesize valueLabel = valueLabel_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(valueLabel_);

	[super dealloc];
}


- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier]) {
		self.label.adjustsFontSizeToFitWidth = YES;

		// Create the value label for rendering readonly data.
		self.valueLabel = [[[UILabel alloc] initWithFrame:style.valueFrame] autorelease];
		self.valueLabel.autoresizingMask = style.valueAutoresizingMask;
		[self.cellView addSubview:self.valueLabel];
	}

	return self;
}

- (void)applyFormFieldStyle {
	[super applyFormFieldStyle];

	self.valueLabel.font = self.formFieldStyle.valueFont;
	self.valueLabel.textColor = self.formFieldStyle.valueTextColor;
	self.valueLabel.backgroundColor = self.formFieldStyle.valueBackgroundColor;
	self.valueLabel.textAlignment = self.formFieldStyle.valueTextAlignment;
}

@end
