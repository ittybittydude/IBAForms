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

#import "IBAMultilineTextFormField.h"
#import "IBAFormConstants.h"
#import "IBAMultilineTextFormFieldCell.h"
#import "IBAMultilineTextViewController.h"
#import "IBAInputCommon.h"

@implementation IBAMultilineTextFormField

@synthesize multilineTextFormFieldCell; 

- (void)dealloc {
	IBA_RELEASE_SAFELY(multilineTextFormFieldCell);
	
	[super dealloc];
}

#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	return [self multilineTextFormFieldCell];
}


- (IBAMultilineTextFormFieldCell *)multilineTextFormFieldCell {
	if (multilineTextFormFieldCell == nil) {
		multilineTextFormFieldCell = [[IBAMultilineTextFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle reuseIdentifier:@"Cell"];
//		multilineTextFormFieldCell.textView.editable = NO;
	}
	
	return multilineTextFormFieldCell;
}

- (void)updateCellContents {
	self.multilineTextFormFieldCell.label.text = self.title;
	self.multilineTextFormFieldCell.textView.text = [self formFieldStringValue];
}

#pragma mark -
#pragma mark IBAInputRequestor

- (NSString *)dataType {
	return IBAInputDataTypeText;
}


#pragma mark -
#pragma mark Detail View Controller management
//- (BOOL)hasDetailViewController {
//	return YES;
//}
//
//- (UIViewController *)detailViewController {
//	IBAMultilineTextViewController *viewController = [[[IBAMultilineTextViewController alloc] initWithInputRequestor:self title:self.title] autorelease];
//	
//	return viewController;
//}


- (void)setInputRequestorValue:(id)aValue {
	[super setInputRequestorValue:aValue];
	[multilineTextFormFieldCell layoutTextView];
}


@end
