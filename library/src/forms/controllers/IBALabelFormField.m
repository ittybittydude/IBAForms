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

@implementation IBALabelFormField

- (IBAFormFieldCell *)cell {
	if (cell_ == nil) {
		cell_ = [[IBALabelFormCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
	}
	
	return cell_;
}

- (void)dealloc {
	IBA_RELEASE_SAFELY(cell_);
	
	[super dealloc];
}

- (void)updateCellContents {
	self.cell.label.text = [self formFieldValue];
}

@end
