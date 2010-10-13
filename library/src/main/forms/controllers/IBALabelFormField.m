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

#import "IBALabelFormField.h"
#import "IBAFormFieldStyle.h"

#define IBALabelX 10
#define IBALabelY 10
#define IBALabelWidth 240
#define IBALabelHeight 24
#define IBALabelFontSize 16

@implementation IBALabelFormField

- (IBAFormFieldCell *)cell {
	if (cell == nil) {
		cell = [[IBALabelFormCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
		formFieldStyle = [[IBAFormFieldStyle alloc] init];
		formFieldStyle.labelFont = [UIFont systemFontOfSize:IBALabelFontSize];
		formFieldStyle.labelFrame = CGRectMake(IBALabelX, IBALabelY, IBALabelWidth, IBALabelHeight);
		formFieldStyle.labelTextColor = self.formFieldStyle.valueTextColor;
		formFieldStyle.labelTextAlignment = UITextAlignmentLeft;
		
		cell.formFieldStyle = formFieldStyle;
	}
	
	return cell;
}

- (void)updateCellContents {
	self.cell.label.text = [self formFieldValue];
}

- (void)setFormFieldStyle:(IBAFormFieldStyle *)style {
	// can't set the style of a label form field
}

@end
