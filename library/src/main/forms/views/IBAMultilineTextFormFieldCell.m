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

#import "IBAMultilineTextFormFieldCell.h"
#import "IBAFormConstants.h"

@interface IBAMultilineTextFormFieldCell ()
- (CGRect)textViewFrame;
@end


@implementation IBAMultilineTextFormFieldCell

@synthesize textView;

- (void)dealloc {
	IBA_RELEASE_SAFELY(textView);

	[super dealloc];
}


- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier]) {
		// Create the text view for data entry
		textView = [[UITextView alloc] initWithFrame:CGRectZero];
		textView.contentInset = UIEdgeInsetsZero;
		textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		textView.scrollEnabled = NO;
		textView.font = [UIFont systemFontOfSize:16];
		textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
		textView.autocorrectionType = UITextAutocorrectionTypeDefault;
		textView.dataDetectorTypes = UIDataDetectorTypeAll;
		textView.keyboardType =UIKeyboardTypeASCIICapable;

		[self.cellView addSubview:self.textView];
	}

    return self;
}

- (void)activate {
	[super activate];

	self.textView.backgroundColor = [UIColor clearColor];
}


- (void)applyFormFieldStyle {
	[super applyFormFieldStyle];

	self.textView.font = self.formFieldStyle.valueFont;
	self.textView.textColor = [UIColor blackColor]; //self.formFieldStyle.valueTextColor;
	self.textView.backgroundColor = self.formFieldStyle.valueBackgroundColor;

	[self layoutTextView];
}

- (void)layoutTextView {
	self.textView.frame = [self textViewFrame];
}

- (CGSize)sizeThatFits:(CGSize)size {
	CGRect newFrame = [self textViewFrame];
	int cellHeight = 26 + newFrame.size.height;
	int cellWidth = 320;

	return CGSizeMake(cellWidth, cellHeight);
}

- (CGRect)textViewFrame {
	CGSize newTextViewSize = [self.textView.text sizeWithFont:self.formFieldStyle.valueFont
											constrainedToSize:CGSizeMake(self.formFieldStyle.valueFrame.size.width + 40,
																		 1000) lineBreakMode:UILineBreakModeWordWrap];

	newTextViewSize.height = MAX(newTextViewSize.height, self.formFieldStyle.valueFrame.size.height);

	return CGRectMake(2, 18, 280, newTextViewSize.height + 8);
}

@end
