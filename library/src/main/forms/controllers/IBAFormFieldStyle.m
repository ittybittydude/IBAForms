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

#import "IBAFormFieldStyle.h"
#import "IBAFormConstants.h"

@implementation IBAFormFieldStyle

@synthesize labelTextColor;
@synthesize labelTextAlignment;
@synthesize labelBackgroundColor;
@synthesize labelFont;
@synthesize labelFrame;
@synthesize valueTextColor;
@synthesize valueBackgroundColor;
@synthesize valueFont;
@synthesize valueFrame;
@synthesize valueTextAlignment;
@synthesize activeColor;

- (void)dealloc {
	IBA_RELEASE_SAFELY(labelTextColor);
	IBA_RELEASE_SAFELY(labelBackgroundColor);
	IBA_RELEASE_SAFELY(labelFont);
	
	IBA_RELEASE_SAFELY(valueTextColor);
	IBA_RELEASE_SAFELY(valueBackgroundColor);
	IBA_RELEASE_SAFELY(valueFont);
	
	IBA_RELEASE_SAFELY(activeColor);

	[super dealloc];
}


- (id)init {
	self = [super init];
	if (self != nil) {
		self.labelTextColor = IBAFormFieldLabelTextColor;
		self.labelBackgroundColor = IBAFormFieldLabelBackgroundColor;
		self.labelFont = IBAFormFieldLabelFont;
		self.labelFrame = CGRectMake(IBAFormFieldLabelX, IBAFormFieldLabelY, IBAFormFieldLabelWidth, IBAFormFieldLabelHeight);
		self.labelTextAlignment = IBAFormFieldLabelTextAlignment;
		
		self.valueTextColor = IBAFormFieldValueTextColor;
		self.valueBackgroundColor = IBAFormFieldValueBackgroundColor;
		self.valueFont = IBAFormFieldValueFont;
		self.valueFrame = CGRectMake(IBAFormFieldValueX, IBAFormFieldValueY, IBAFormFieldValueWidth, IBAFormFieldValueHeight);
		self.valueTextAlignment = IBAFormFieldValueTextAlignment;

		self.activeColor = IBAFormFieldActiveColor;
	}
	return self;
}

@end
