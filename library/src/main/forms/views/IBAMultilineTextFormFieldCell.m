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


static const CGFloat kTextViewPadding = 8.;

@interface IBAMultilineTextFormFieldCell ()
- (CGRect)textViewFrame:(CGSize)size;
@end


@implementation IBAMultilineTextFormFieldCell

@synthesize textView = textView_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(textView_);

	[super dealloc];
}


- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier])) {
		// Create the text view for data entry
		textView_ = [[UITextView alloc] initWithFrame:CGRectZero];
		textView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		textView_.scrollEnabled = NO;
		textView_.autocapitalizationType = UITextAutocapitalizationTypeSentences;
		textView_.autocorrectionType = UITextAutocorrectionTypeDefault;
		textView_.dataDetectorTypes = UIDataDetectorTypeAll;
		textView_.keyboardType = UIKeyboardTypeASCIICapable;
		textView_.font = style.valueFont;

		[self.cellView addSubview:textView_];
	}

    return self;
}

- (void)activate {
	[super activate];

//	self.textView.backgroundColor = [UIColor clearColor];
}


- (void)applyFormFieldStyle {
	[super applyFormFieldStyle];

	self.backgroundColor = [UIColor blueColor];
	self.textView.textColor = [UIColor blackColor]; //self.formFieldStyle.valueTextColor;
	self.textView.backgroundColor = [UIColor redColor]; //self.formFieldStyle.valueBackgroundColor;
}

- (CGSize)sizeThatFits:(CGSize)size {
	CGSize viewSize = [self textViewFrame:size].size;
	
	return viewSize;
}

- (void)layoutSubviews {
	self.textView.frame = [self textViewFrame:[self bounds].size];
	IBALogRect(self.textView.frame);
}

- (CGRect)textViewFrame:(CGSize)size {					   	
	CGFloat insetAdjustment = self.textView.contentInset.bottom + self.textView.contentInset.top;
	insetAdjustment = ([self.textView isFirstResponder]) ?  insetAdjustment : 0;
//	CGFloat contentSizeHeight = ([self.textView hasText]) ? self.textView.contentSize.height : textSize.height;
	
	CGRect newTextViewFrame = CGRectMake(0, 0, size.width, MAX(self.textView.contentSize.height + insetAdjustment,  44.));
	return newTextViewFrame;
}

@end

