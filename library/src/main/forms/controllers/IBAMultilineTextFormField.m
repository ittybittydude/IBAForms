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

@interface IBAMultilineTextFormField ()
- (void)postResizeNotification;
@end


@implementation IBAMultilineTextFormField

@synthesize multilineTextFormFieldCell; 

- (void)dealloc {
	multilineTextFormFieldCell.textView.delegate = nil;
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
		multilineTextFormFieldCell.textView.userInteractionEnabled = NO;
		multilineTextFormFieldCell.textView.delegate = self;
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

- (void)activate {
	[super activate];
	self.multilineTextFormFieldCell.textView.backgroundColor = [UIColor clearColor];
	self.multilineTextFormFieldCell.textView.userInteractionEnabled = YES;
	[self.multilineTextFormFieldCell.textView becomeFirstResponder];
}

- (BOOL)deactivate {
	BOOL deactivated = [self setFormFieldValue:self.multilineTextFormFieldCell.textView.text];
	if (deactivated) {
		[self.multilineTextFormFieldCell.textView resignFirstResponder];
		self.multilineTextFormFieldCell.textView.userInteractionEnabled = NO;
		deactivated = [super deactivate];
	}
	
	return deactivated;
}


#pragma mark -
#pragma mark IBAInputRequestor

- (void)textViewDidChange:(UITextView *)textView {
	[[NSNotificationCenter defaultCenter] postNotificationName:IBAFormFieldResized object:self userInfo:nil];

//	[self.multilineTextFormFieldCell.textView setNeedsLayout];
//	[self performSelector:@selector(postResizeNotification) withObject:nil afterDelay:0];
}

- (void)postResizeNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:IBAFormFieldResized object:self userInfo:nil];
}

@end
